import 'package:flutter/material.dart';

class ContainerBox extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const ContainerBox({required this.boxColor, required this.childWidget});
  final Widget childWidget;
  final Color boxColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: childWidget,
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: boxColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5.0,
            blurRadius: 7.0,
            offset: Offset(0, 3),
          ),
        ],
      ),
    );
  }
}