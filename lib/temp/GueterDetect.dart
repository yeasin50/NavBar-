import 'package:flutter/material.dart';

class SwipeDetecHome extends StatefulWidget {
  SwipeDetecHome({Key key}) : super(key: key);

  @override
  _SwipeDetecHomeState createState() => _SwipeDetecHomeState();
}

class _SwipeDetecHomeState extends State<SwipeDetecHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity > 0) {
              print("SwipeLeft");
            } else if (details.primaryVelocity < 0) {
              print("Swipe Right");
            }
          },
          onVerticalDragEnd: (details) {
            if (details.primaryVelocity > 0) {
              print("Down side");
            } else if (details.primaryVelocity < 0) {
              print("Swipe Top");
            }
          },
          child: buildCenter()),
    );
  }

  Center buildCenter() {
    return Center(
      child: Container(
          height: 300,
          width: 350,
          color: Colors.red,
          child: Column(
            children: [
              Text("A"),
              Container(
                  color: Colors.white24,
                  width: 200,
                  height: 150,
                  child: Image.asset(
                    "assets/images/smile.jpg",
                    fit: BoxFit.cover,
                    width: 130,
                    height: 130,
                  )),
            ],
          )),
    );
  }
}
