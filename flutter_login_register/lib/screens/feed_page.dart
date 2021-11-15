import 'package:flutter/material.dart';

class FeedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('Feed'),
    ),
        body: Center(child: Text('Feed', style: TextStyle(fontSize: 40))),
      );
}
