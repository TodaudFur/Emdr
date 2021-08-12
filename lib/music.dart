import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class Music extends StatefulWidget {
  const Music({Key? key}) : super(key: key);

  @override
  _MusicState createState() => _MusicState();
}

class _MusicState extends State<Music> {
  double _currentSliderValue = 0;
  late Timer _timer;
  bool _isPlaying = false;
  var _icon = CupertinoIcons.play_arrow_solid;
  late AudioPlayer player;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    player = AudioPlayer();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer.cancel();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              "Music",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 15,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                CupertinoIcons.backward_fill,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _click();
                });
              },
              icon: Icon(
                _icon,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                CupertinoIcons.forward_fill,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                CupertinoIcons.speaker_slash,
                color: Colors.white,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 1,
          ),
          child: Slider(
            value: _currentSliderValue,
            min: 0,
            max: 100,
            divisions: 100,
            activeColor: Colors.white,
            inactiveColor: Colors.white,
            label: _currentSliderValue.round().toString(),
            onChanged: (double value) {
              setState(() {
                _currentSliderValue = value;
              });
            },
          ),
        ),
      ],
    );
  }

  void _click() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _icon = CupertinoIcons.pause_solid;
        _start();
      } else {
        _icon = CupertinoIcons.play_arrow_solid;
        _pause();
      }
    });
  }

  void _start() async {
    await player.setAsset('assets/music/test.mp3');
    player.play();
    print(player.currentIndex);
    /*_timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        //TODO:value++
      });
    });*/
  }

  void _pause() {
    player.pause();
    //_timer.cancel();
  }
}
