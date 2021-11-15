import 'package:flutter/material.dart';

const textStyle1 = TextStyle(
  color: Colors.white,
  fontSize: 15.0,
);

const textStyle2 = TextStyle(
  color: Colors.white,
  fontSize: 45.0,
  fontWeight: FontWeight.w900
);

const textStyle3 = TextStyle(
  color: Colors.white,
  fontSize: 30.0,
);


// ignore: must_be_immutable
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
          size: 50.0,
          color: Colors.white,
        ),
        SizedBox(height: 5.0),
        Text(title, style: textStyle1)
      ],
    );
  }
}
