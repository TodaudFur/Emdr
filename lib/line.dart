import 'dart:ui';

import 'package:flutter/material.dart';

import 'emdr.dart';

class Line extends StatefulWidget {
  const Line({Key? key}) : super(key: key);

  @override
  _LineState createState() => _LineState();
}

class _LineState extends State<Line> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;
  late Path _path;
  int cTime = time;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: cTime));

    super.initState();
    _animation = Tween(begin: 20.0, end: 330.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.forward();
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return curved();
  }

  Container curved() {
    return Container(
      child: Stack(
        children: <Widget>[
          Positioned(
            top: top,
            left: _animation.value,
            child: Container(
              decoration: BoxDecoration(
                  color: color, borderRadius: BorderRadius.circular(30)),
              width: 30,
              height: 30,
              child: FittedBox(
                fit: BoxFit.fill,
                child: ballWidget,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
