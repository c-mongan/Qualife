import 'package:flutter/material.dart';

class ActivityIcon extends StatelessWidget {
  String image;
  String name;
  Color colour;
  ActivityIcon(this.image, this.name, this.colour, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 80,
        child: Column(
          children: <Widget>[
            Image.asset(
              image,
              height: 45,
              width: 45,
            ),
            Text(
              name,
              style: const TextStyle(fontSize: 12, color: Colors.white),
            )
          ],
        ),
        decoration: BoxDecoration(
          border: Border.all(color: colour),
        ));
  }
}

class MoodIcon extends StatelessWidget {
  String image;
  String name;
  Color colour;
  MoodIcon({required this.name, required this.image, required this.colour});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Image.asset(
            image,
            height: 40,
            width: 40,
          ),
          Text(
            name,
            style: TextStyle(fontSize: 12, color: Colors.white),
          )
        ],
      ),
      decoration: BoxDecoration(
        border: Border.all(color: colour),
      ),
      height: 75,
      width: 55,
    );
  }
}

class DisplayMoodIcon extends StatelessWidget {
  String image;

  DisplayMoodIcon({
    required this.image,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Image.asset(
            image,
            height: 45,
            width: 45,
          ),
        ],
      ),
      height: 75,
      width: 55,
    );
  }
}
