import 'dart:ffi';

import 'package:easy_pos/helpers/sql_helper.dart';
import 'package:easy_pos/models/order.dart';
import 'package:easy_pos/models/order_item.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class OrderItemDetails extends StatefulWidget {
  final Order? order;

  const OrderItemDetails({super.key, this.order});

  @override
  State<OrderItemDetails> createState() => _OrderItemDetailsState();
}

class _OrderItemDetailsState extends State<OrderItemDetails> {
  List<OrderItem>? orderItems;
  void initState() {
    getOrders();
    super.initState();
  }

  void getOrders() async {
    try {
      var sqlHelper = GetIt.I.get<SqlHelper>();
      var data =
          await sqlHelper.db!.rawQuery("""select O.* ,P.name as productName,
      P.description as productDescription,
      P.price as productPrice,
      P.image as productImage
      from orderProductItems O
      inner join products P
      where O.productId = P.id and orderId = ${widget.order?.id}
      """);

      if (data.isNotEmpty) {
        orderItems = [];
        for (var item in data) {
          orderItems!.add(OrderItem.fromJson(item));
        }
      } else {
        orderItems = [];
      }
    } catch (e) {
      print('Error In get data $e');
      orderItems = [];
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.order?.id != null ? 'Order Details' : ''),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
                height: 70,
                width: 400,
                color: Theme.of(context).primaryColor,
                child: Column(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Text('Order Label : ${widget.order?.label} ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      )),
                      Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [  
                        Text('Total Price : ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              
                              )),
                         Text(
                              ' $calculateTotalPriceWithoutDiscount ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.lineThrough,
                              )),
                         Text(' ${widget.order?.totalPrice} LE',

                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          )),
                         
                        ],)
                     
                 
                ])),
            SizedBox(
              height: 10,
            ),
            for (var item in orderItems!)
              Card(
                color: Color.fromARGB(255, 242, 240, 240),
                elevation: 5,
                surfaceTintColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Container(
                    width: 350,
                    height: 130,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                              width: 130,
                              height: 130,
                              child: Image.network(item.productImage ?? '')),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('${item.productName ?? ' '}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  )),
                              Text('${item.productDescription ?? ''}',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 134, 160, 170),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  )),
                              Text(
                                  '${item.productPrice}  LE , ${item.productCount} X ',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 138, 161, 170),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  )),
                              Text(
                                  'Total price : ${item.productCount! * item.productPrice! ?? 0} LE ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ))
                            ],
                          ),
                        ]),
                  ),
                ),
              ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  double get calculateTotalPriceWithoutDiscount {
    double total = 0;
  
      for (var item in orderItems!) {
      total = total +
          ((item.productCount ?? 0) * (item?.productPrice ?? 0));
    
    }

    return total;
  }

}
