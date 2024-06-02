 import 'package:flutter/material.dart';

class GridViewItem extends StatelessWidget {
  final Color color;
  final String label;
  final IconData iconData;
  const GridViewItem(
      {required this.label,
      required this.color,
      required this.iconData,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: color.withOpacity(.3),
            child: Icon(
              iconData,
              color: color,
              size: 40,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          )
        ],
      ),
    );
  }
}
