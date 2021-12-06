import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: Center(child: Text('Profile', style: TextStyle(fontSize: 40))),
      );
}
