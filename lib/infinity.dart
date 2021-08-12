import 'dart:ui';

import 'package:flutter/material.dart';

import 'emdr.dart';

class Infinity extends StatefulWidget {
  const Infinity({Key? key}) : super(key: key);

  @override
  _InfinityState createState() => _InfinityState();
}

class _InfinityState extends State<Infinity>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;
  late Path _path;

  int iTime = time * 2;
  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: iTime));

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
                color: color,
                borderRadius: BorderRadius.circular(30),
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Path drawPath() {
    Size size = Size(330, top * 2);
    Path path = Path();
    path.moveTo(40, size.height / 2);
    path.quadraticBezierTo(
        size.width / 4, size.height, size.width / 2, size.height / 2);
    path.quadraticBezierTo(
        (size.width / 4) * 3, 0, size.width, size.height / 2);
    path.quadraticBezierTo(
        (size.width / 4) * 3, size.height, size.width / 2, size.height / 2);
    path.quadraticBezierTo(size.width / 4, 0, 40, size.height / 2);
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

class PathPainter extends CustomPainter {
  Path path;

  PathPainter(this.path);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.redAccent.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    canvas.drawPath(this.path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
