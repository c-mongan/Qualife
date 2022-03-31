import 'package:flutter/material.dart';

class ContainerCard extends StatelessWidget {
  const ContainerCard(
      {required this.color,
      required this.childContainer,
      this.gesture,
      this.radius = 25.0});
  final Color color;
  final Widget childContainer;
  final void Function()? gesture;
  //final Function gesture;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: gesture,
      child: Container(
        child: childContainer,
        margin: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
