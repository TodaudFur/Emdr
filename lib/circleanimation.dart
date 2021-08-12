import 'dart:ui';

import 'package:flutter/material.dart';

import 'emdr.dart';

class CircleAnimation extends StatefulWidget {
  const CircleAnimation({Key? key}) : super(key: key);

  @override
  CircleAnimationState createState() => CircleAnimationState();
}

class CircleAnimationState extends State<CircleAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;
  late Path _path;
  int cTime = time * 2;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: cTime));

    super.initState();
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.forward();
    _controller.repeat();
    _path = drawPath();
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
            top: calculate(_animation.value).dy,
            left: calculate(_animation.value).dx,
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

  Path drawPath() {
    Path path = Path();
    path.addOval(Rect.fromCircle(center: Offset(180, top), radius: 100));
    return path;
  }

  Offset calculate(value) {
    PathMetrics pathMetrics = _path.computeMetrics();
    PathMetric pathMetric = pathMetrics.elementAt(0);
    value = pathMetric.length * value;
    Tangent? pos = pathMetric.getTangentForOffset(value);
    return pos!.position;
  }
}
