import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/page_manager.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final PageManager _pageManager = PageManager();

Icon volume = Icon(
  FontAwesomeIcons.volumeUp,
  color: Colors.white,
);

class Music extends StatefulWidget {
  const Music({Key? key}) : super(key: key);

  @override
  _MusicState createState() => _MusicState();
}

class _MusicState extends State<Music> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    //_pageManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              "MUSIC",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
            IconButton(
              onPressed: prev,
              icon: Icon(
                FontAwesomeIcons.backward,
                color: Colors.white,
                size: 20,
              ),
            ),
            ValueListenableBuilder<ButtonState>(
              valueListenable: _pageManager.buttonNotifier,
              builder: (_, value, __) {
                switch (value) {
                  case ButtonState.loading:
                    return Container(
                      margin: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                      width: 20,
                    );
                  case ButtonState.paused:
                    return IconButton(
                      icon: Icon(
                        FontAwesomeIcons.play,
                        color: Colors.white,
                      ),
                      onPressed: _pageManager.play,
                    );
                  case ButtonState.playing:
                    return IconButton(
                      icon: Icon(
                        FontAwesomeIcons.pause,
                        color: Colors.white,
                      ),
                      onPressed: _pageManager.pause,
                    );
                }
              },
            ),
            IconButton(
              onPressed: next,
              icon: Icon(
                FontAwesomeIcons.forward,
                color: Colors.white,
                size: 20,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _pageManager.mute();
                });
              },
              icon: volume,
            ),
          ],
        ),
        ValueListenableBuilder<ProgressBarState>(
          valueListenable: _pageManager.progressNotifier,
          builder: (_, value, __) {
            return ProgressBar(
              timeLabelTextStyle: TextStyle(color: Colors.white),
              barHeight: 2,
              baseBarColor: Colors.grey,
              progressBarColor: Colors.white,
              thumbColor: Colors.white,
              thumbGlowColor: Colors.white12,
              bufferedBarColor: Colors.grey[400],
              thumbRadius: 8,
              thumbGlowRadius: 20,
              progress: value.current,
              buffered: value.buffered,
              total: value.total,
              onSeek: _pageManager.seek,
            );
          },
        ),
      ],
    );
  }

  next() {
    _pageManager.next();
  }

  prev() {
    _pageManager.prev();
  }
}
