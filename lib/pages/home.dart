import 'package:easy_pos/helpers/sql_helper.dart';
import 'package:easy_pos/models/exchange.dart';
import 'package:easy_pos/models/order.dart';
import 'package:easy_pos/pages/all_sales.dart';
import 'package:easy_pos/pages/categories.dart';
import 'package:easy_pos/pages/clients.dart';
import 'package:easy_pos/pages/products.dart';
import 'package:easy_pos/pages/sale_ops.dart';
import 'package:easy_pos/widgets/grid_view_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ExchangeData>? exchange;
  List<Order>? orders;
  bool isLoading = true;
  bool isTableIntilized = false;
  @override
  void getExchange() async {
    try {
      var sqlHelper = GetIt.I.get<SqlHelper>();
      var data = await sqlHelper.db!.query('exchange');
      if (data.isNotEmpty) {
        exchange = [];
        for (var item in data) {
          exchange!.add(ExchangeData.fromJson(item));
        }
      } else {
        exchange = [];
      }
    } catch (e) {
      print('Error In get data $e');
      exchange = [];
    }

    setState(() {});
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

  void initState() {
    intilizeTables();
    super.initState();
    getExchange();
    getOrders();
  }

  void intilizeTables() async {
    var sqlHelper = GetIt.I.get<SqlHelper>();
    isTableIntilized = await sqlHelper.createTables();
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Container(),
      appBar: AppBar(),
      body: Column(
        children: [
          Row(
            children: [
              // FloatingActionButton(onPressed: () async {
              //   var sqlHelper = GetIt.I.get<SqlHelper>();
              // var data = sqlHelper.db!.execute("""ALTER TABLE orders ADD COLUMN createdAt TEXT""");

              // }),
              Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height / 2.8 +
                      (kIsWeb ? 40 : 0),
                  color: Theme.of(context).primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Easy Pos',
                              style: TextStyle(
                                color: Color.fromRGBO(255, 255, 255, 1),
                                fontWeight: FontWeight.w800,
                                fontSize: 24,
                              ),
                            ),
                            //checking the database is working or not
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: isLoading
                                  ? Transform.scale(
                                      scale: .5,
                                      child: const CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    )
                                  : CircleAvatar(
                                      backgroundColor: isTableIntilized
                                          ? Colors.green
                                          : Colors.red,
                                      radius: 10,
                                    ),
                            )
                          ],
                        ),
                        headerItem('Exchange Rate',
                            '${exchange?[0].fromCurrency} ${exchange?[0].fromCurrencyName} = ${exchange?[0].toCurrency} ${exchange?[0].toCurrencyName}'),
                        headerItem('Today\'s Sales', '$salesOfTheDay EGP'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
              child: Container(
            color: const Color(0xfffbfafb),
            padding: const EdgeInsets.all(20),
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              children: [
//  GridViewItem is StatelessWidget from widets folder(reusable widget)
                GridViewItem(
                  color: Colors.orange,
                  iconData: Icons.calculate,
                  label: 'All Sales',
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const AllSales()));
                  },
                ),
                GridViewItem(
                  color: Colors.pink,
                  iconData: Icons.inventory_2,
                  label: 'Products',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ProductsPage()));
                  },
                ),
                GridViewItem(
                  color: Colors.lightBlue,
                  iconData: Icons.groups,
                  label: 'Clients',
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const ClientsPage()));
                  },
                ),
                GridViewItem(
                  color: Colors.green,
                  iconData: Icons.point_of_sale,
                  label: 'New Sale',
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const SaleOpsPage()));
                  },
                ),
                GridViewItem(
                  color: Colors.yellow,
                  iconData: Icons.category,
                  label: 'Categories',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const CategoriesPage()));
                  },
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }

//resuble componant
  Widget headerItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Card(
        color: const Color(0xff206ce1),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double get salesOfTheDay {
    double salesOfDay = 0;
    for (var item in orders!)
      if (item.label ==
          '#OR${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}')
        salesOfDay = salesOfDay + (item.totalPrice ?? 0);
    getOrders();
    return salesOfDay;
  }
}
