import 'dart:ui';

import 'package:flutter/material.dart';

import 'emdr.dart';

class Light extends StatefulWidget {
  const Light({Key? key}) : super(key: key);

  @override
  _LightState createState() => _LightState();
}

class _LightState extends State<Light> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;
  late Path _path;
  int cTime = time * 2;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: cTime));

    super.initState();
    _animation = Tween(begin: 5.0, end: 30.0).animate(_controller)
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
            left: 180,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFFFFFFF),
                    blurRadius: _animation.value,
                    spreadRadius: 5,
                    offset: Offset(
                      0.0,
                      0.0,
                    ),
                  ),
                ],
              ),
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
