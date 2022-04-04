import 'package:flutter/material.dart';

import 'container_card.dart';

class Button extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const Button({this.text, this.onTap, this.color, this.edges});
  final Color? color;
  final Text? text;
  final Function()? onTap;
  final EdgeInsetsGeometry? edges;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: edges,
        width: double.infinity,
        child: ContainerCard(
          color: Colors.black,
          childContainer: Center(
            child: text,
          ),
        ),
      ),
    );
  }
}

class RoundedIconButton extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const RoundedIconButton({
    required this.icon,
    required this.action,
    required this.color,
  });
  final IconData icon;

  //final Function action;
  final void Function()? action;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        elevation: 5,
        color: color, // button color
        child: InkWell(
            splashColor: Colors.white, // inkwell color
            child: SizedBox(
              width: 50,
              height: 50,
              child: Icon(icon),
            ),
            //onLongPress: action,
            onTap: action),
      ),
    );
  }
}
