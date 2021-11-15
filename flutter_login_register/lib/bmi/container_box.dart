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
        borderRadius: BorderRadius.circular(20.0),
        color: boxColor,
       
      ),
    );
  }
}