import 'dart:async';

import 'package:flutter/material.dart';

class EMDRBottom extends StatefulWidget {
  final ValueChanged<bool> update;
  EMDRBottom({required this.update});
  @override
  _EMDRBottomState createState() => _EMDRBottomState(update: update);
}

class _EMDRBottomState extends State<EMDRBottom> {
  final ValueChanged<bool> update;
  _EMDRBottomState({required this.update});

  int min = 30;
  late Timer _timer;
  bool _isPlaying = false;
  var _icon = Icons.play_arrow;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (_isPlaying) {
      _start();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              "[EMDR+Video 쿠폰] - ",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "남은 시간 : $min분",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
            ),
          ],
        ),
        Divider(
          color: Colors.white70,
          height: 10,
        ),
        Row(
          children: [
            Text(
              "EMDR",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: Colors.white,
                fontSize: 15,
              ),
            ),
            IconButton(
              onPressed: _click,
              icon: Icon(
                _icon,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _click() {
    if (min > 0) {
      setState(() {
        update(true);
        _isPlaying = !_isPlaying;
        if (_isPlaying) {
          _icon = Icons.pause;
          _start();
        } else {
          _icon = Icons.play_arrow;
          _pause();
        }
      });
    }
  }

  void _start() {
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      setState(() {
        if (min > 0) {
          min--;
        } else {
          setState(() {
            update(false);
            _icon = Icons.play_arrow;
            _pause();
          });
        }
      });
    });
  }

  void _pause() {
    _timer.cancel();
  }
}
