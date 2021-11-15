import 'package:flutter/material.dart';

class ExitPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('Chat'),
    ),
        body: Center(child: Text('Exit', style: TextStyle(fontSize: 40))),
      );
}
