import 'package:flutter/material.dart';

import '../colors&fonts.dart';

class GenderIconContent extends StatelessWidget {
 
  const GenderIconContent(
      {required this.sex,
      required this.label,
      required this.color,
      labelColor});
  final String label;
  final IconData sex;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          sex,
          size: 50.0,
          color: color,
        ),
        SizedBox(
          height: 10.0,
          width: 50.0,
          child: Divider(
            color: color,
            height: 16.0,
          ),
        ),
        Text(
          label,
          style: kLabelTextStyle,
        ),
      ],
    );
  }
}
