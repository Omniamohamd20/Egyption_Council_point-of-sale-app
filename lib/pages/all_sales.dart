import 'package:data_table_2/data_table_2.dart';
import 'package:easy_pos/helpers/sql_helper.dart';
import 'package:easy_pos/models/order.dart';
import 'package:easy_pos/pages/order_item_details.dart';
import 'package:easy_pos/widgets/app_table.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class AllSales extends StatefulWidget {
  const AllSales({super.key});

  @override
  State<AllSales> createState() => _AllSalesState();
}

class _AllSalesState extends State<AllSales> {
  List<Order>? orders;
  bool _showWidget = false;
  int pressedCount = 0;
  bool priceFilterPressed = false;
  bool discountFilterPressed = false;

  @override
  void initState() {
    getOrders();
    super.initState();
  }

  void getOrders() async {
    try {
      var sqlHelper = GetIt.I.get<SqlHelper>();
      var data = await sqlHelper.db!.rawQuery("""
      select O.* ,C.name as clientName,C.phone as clientPhone,C.address as clientAddress 
      from orders O
      inner join clients C
      where O.clientId = C.id
      """);

      if (data.isNotEmpty) {
        orders = [];
        for (var item in data) {
          orders!.add(Order.fromJson(item));
        }
      } else {
        orders = [];
      }
    } catch (e) {
      print('Error In get data $e');
      orders = [];
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Sales'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // search,filter,sort row
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Container(
                width: 295,
                height: 50,
                child: TextField(
                  onChanged: (value) async {
                    var sqlHelper = GetIt.I.get<SqlHelper>();
                    if (priceFilterPressed) {
                      var result = await sqlHelper.db!.rawQuery("""
    select O.* ,C.name as clientName,C.phone as clientPhone,C.address as clientAddress 
      from orders O
      inner join clients C
      where O.clientId = C.id AND
       (label LIKE '%$value%' OR totalPrice LIKE '%$value%' OR clientName LIKE '%$value%') 
       AND totalPrice>1000 ;
          """);
                      if (result.isNotEmpty) {
                        orders = [];
                        for (var item in result) {
                          orders!.add(Order.fromJson(item));
                        }
                      } else {
                        orders = [];
                      }
                 
                    }
                   else if (discountFilterPressed) {
                      var result = await sqlHelper.db!.rawQuery("""
    select O.* ,C.name as clientName,C.phone as clientPhone,C.address as clientAddress 
      from orders O
      inner join clients C
      where O.clientId = C.id AND discount>15 AND
       (label LIKE '%$value%' OR totalPrice LIKE '%$value%' OR clientName LIKE '%$value%')  ;
          """);
                      if (result.isNotEmpty) {
                        orders = [];
                        for (var item in result) {
                          orders!.add(Order.fromJson(item));
                        }
                      } else {
                        orders = [];
                      }
                  
                    } else if (priceFilterPressed & discountFilterPressed) {
                      var result = await sqlHelper.db!.rawQuery("""
    select O.* ,C.name as clientName,C.phone as clientPhone,C.address as clientAddress 
      from orders O
      inner join clients C
      where O.clientId = C.id AND
       (label LIKE '%$value%' OR totalPrice LIKE '%$value%' OR clientName LIKE '%$value%') AND totalPrice>1000 AND discount>15;
          """);
                      if (result.isNotEmpty) {
                        orders = [];
                        for (var item in result) {
                          orders!.add(Order.fromJson(item));
                        }
                      } else {
                        orders = [];
                      }
                     
                    }else{
                      var result = await sqlHelper.db!.rawQuery("""
    select O.* ,C.name as clientName,C.phone as clientPhone,C.address as clientAddress 
      from orders O
      inner join clients C
      where O.clientId = C.id AND
       (label LIKE '%$value%' OR totalPrice LIKE '%$value%' OR clientName LIKE '%$value%') AND totalPrice>1000 AND discount>15;
          """);
                      if (result.isNotEmpty) {
                        orders = [];
                        for (var item in result) {
                          orders!.add(Order.fromJson(item));
                        }
                      } else {
                        orders = [];
                      }
                    

                    }
                      setState(() {});
                  },
                  decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5.0),
                          bottomLeft: Radius.circular(5.0),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(1)),
                      ),
                      hintText: 'search'),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(2),
                width: 40,
                height: 50,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5.0),
                    bottomRight: Radius.circular(5.0),
                  ),
                  color: Theme.of(context).primaryColor,
                  border: Border(
                    top: BorderSide(color: Colors.black, width: 1.0),
                    right: BorderSide(color: Colors.black, width: 1.0),
                    bottom: BorderSide(color: Colors.black, width: 1.0),
                  ),
                ),

                // color: Theme.of(context).primaryColor,
                child: IconButton(
                    iconSize: 18,
                    onPressed: () {
                      setState(() {
                        pressedCount % 2 == 0
                            ? (getSortedData('id', 'ASC'), pressedCount++)
                            : (getSortedData('id', 'DESC'), pressedCount++);
                      });
                    },
                    icon: Icon(
                      Icons.sort,
                      color: Colors.white,
                    )),
              ),
              Container(
                  padding: const EdgeInsets.all(2),
                  width: 35,
                  height: 50,
                  child: IconButton(
                      iconSize: 18,
                      onPressed: () {
                        setState(() {
                          _showWidget = !_showWidget;
                        });
                      },
                      icon: Icon(
                        _showWidget
                            ? Icons.filter_alt_off_rounded
                            : Icons.filter_alt,
                        color: Theme.of(context).primaryColor,
                        size: 25,
                      )))
            ]),
            SizedBox(
              height: 10,
            ),
            //filter
            if (_showWidget)
              Row(
                  // mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width: 370,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 228, 227, 227),
                          borderRadius: BorderRadius.circular(1.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // sort button
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    minimumSize: Size(30, 25),
                                    backgroundColor: priceFilterPressed
                                        ? Colors.blue
                                        : Colors.white),
                                onPressed: () async {
                                  setState(() {
                                    priceFilterPressed = !priceFilterPressed;
                                  });
                                },
                                child: Text('Total price more than 1000  LE',style: TextStyle(color:   priceFilterPressed?Colors.white:Colors.blue),)),
                            SizedBox(
                              width: 5,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(30, 25),
                                backgroundColor: discountFilterPressed
                                        ? Colors.blue
                                        : Colors.white
                              ),
                              onPressed: () {
                                 setState(() {
                                discountFilterPressed = !discountFilterPressed;
                                });
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Dicount more than 15%',style: TextStyle(color:   discountFilterPressed? Colors.white
                                            : Colors.blue),),
                                ],
                              ),
                            ),
                          ],
                        )),
                  ]),

            const SizedBox(
              height: 10,
            ),
            Expanded(
                child: AppTable(
                    minWidth: 1100,
                    columns: const [
                      DataColumn(label: Text('Id')),
                      DataColumn(label: Text('Label')),
                      DataColumn(label: Text('Total Price')),
                      DataColumn(label: Text('Discount')),
                      DataColumn(label: Text('Client Name')),
                      DataColumn(label: Text('Client phone')),
                      DataColumn(label: Text('Client Address')),
                      DataColumn(label: Center(child: Text('Actions'))),
                    ],
                    source: OrderDataSource(
                      ordersEx: orders,
                      onShow: (order) async {
                        var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) => OrderItemDetails(
                                      order: order,
                                    )));
                        if (result ?? false) {
                          getOrders();
                        }
                      },
                      onDelete: (order) {
                        onDeleteRow(order.id!);
                      },
                    ))),
          ],
        ),
      ),
    );
  }

  Future<void> onDeleteRow(int id) async {
    try {
      var dialogResult = await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Delete order'),
              content:
                  const Text('Are you sure you want to delete this order?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text('Delete'),
                ),
              ],
            );
          });

      if (dialogResult ?? false) {
        var sqlHelper = GetIt.I.get<SqlHelper>();
        var result = await sqlHelper.db!.delete(
          'orders',
          where: 'id =?',
          whereArgs: [id],
        );
        if (result > 0) {
          getOrders();
        }
      }
    } catch (e) {
      print('Error In delete data $e');
    }
  }

  Future<void> getSortedData(String columnName, String sortType) async {
    var sqlHelper = GetIt.I.get<SqlHelper>();
    var data;
    if (sortType == "ASC") {
      data = await sqlHelper.db!.rawQuery("""
SELECT * FROM Orders ORDER BY $columnName ASC;
""");
    }
    if (sortType == "DESC") {
      data = await sqlHelper.db!.rawQuery("""
SELECT * FROM Orders ORDER BY $columnName DESC;
""");
    }
    if (data.isNotEmpty) {
      orders = [];
      for (var item in data) {
        orders!.add(Order.fromJson(item));
      }
    } else {
      orders = [];
    }
    setState(() {});
  }
}

class OrderDataSource extends DataTableSource {
  List<Order>? ordersEx;

  void Function(Order) onShow;
  void Function(Order) onDelete;
  OrderDataSource(
      {required this.ordersEx, required this.onShow, required this.onDelete});

  @override
  DataRow? getRow(int index) {
    return DataRow2(cells: [
      DataCell(Text('${ordersEx?[index].id}')),
      DataCell(Text('${ordersEx?[index].label}')),
      DataCell(Text('${ordersEx?[index].totalPrice}')),
      DataCell(Text('${ordersEx?[index].discount}')),
      DataCell(Text('${ordersEx?[index].clientName}')),
      DataCell(Text('${ordersEx?[index].clientPhone}')),
      DataCell(Text('${ordersEx?[index].clientAddress}')),
      DataCell(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              onPressed: () {
                onShow(ordersEx![index]);
              },
              icon: const Icon(Icons.visibility)),
          IconButton(
              onPressed: () {
                onDelete(ordersEx![index]);
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              )),
        ],
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => ordersEx?.length ?? 0;

  @override
  int get selectedRowCount => 0;
}
