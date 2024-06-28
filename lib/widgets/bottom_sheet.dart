import 'package:flutter/material.dart';
import 'package:easy_pos/pages/clients.dart';

class BottomSheetModal extends StatelessWidget {
  String text;
  BottomSheetModal({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: 370,
              height: 100,
              // margin: EdgeInsets.only(top: 10.0),
              // padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 228, 227, 227),
                borderRadius: BorderRadius.circular(1.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // sort button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize:
                          Size(30, 25), // set width to 200 and height to 40
                    ),
                    onPressed: () {
                      // getSortedData('name', 'ASC');
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('$text'),
                      
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(30, 25),
                    ),
                    onPressed: () {
                      // getSortedData('name', 'DESC');
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Z'),
                        SizedBox(width: 2),
                        Icon(
                          Icons.arrow_forward_ios_sharp,
                          size: 15,
                        ),
                        SizedBox(width: 2),
                        Text('A'),
                      ],
                    ),
                  ),
                ],
              )),
        ]);
  }
}
