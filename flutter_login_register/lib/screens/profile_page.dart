import 'package:flutter/material.dart';

class Chat extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Chat'),
        ),
        body: Center(child: Text('Chat', style: TextStyle(fontSize: 40))),
      );
}
