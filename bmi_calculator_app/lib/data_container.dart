import 'package:flutter/material.dart';

const textStyle1 = TextStyle(
  color: Color(0xFF000000),
  fontSize: 20.0,
);

class DataContainer extends StatelessWidget {
  DataContainer({required this.icon, required this.title});

  IconData icon;
  String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          icon,
          size: 80.0,
        ),
        SizedBox(height: 15.0),
        Text(title, style: textStyle1)
      ],
    );
  }
}
