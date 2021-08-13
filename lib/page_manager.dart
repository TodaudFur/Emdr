import 'package:flutter/material.dart';
import 'package:flutter_app/music.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:just_audio/just_audio.dart';

class PageManager {
  final progressNotifier = ValueNotifier<ProgressBarState>(
    ProgressBarState(
      current: Duration.zero,
      buffered: Duration.zero,
      total: Duration.zero,
    ),
  );
  final buttonNotifier = ValueNotifier<ButtonState>(ButtonState.paused);

  late AudioPlayer _audioPlayer;

  PageManager() {
    init();
  }

  next() async {
    await _audioPlayer.seekToNext();
  }

  prev() async {
    await _audioPlayer.seekToPrevious();
  }

  void init() async {
    // initialize the song
    _audioPlayer = AudioPlayer();
    await _audioPlayer.setAudioSource(
      ConcatenatingAudioSource(
        children: [
          AudioSource.uri(Uri.parse("asset:///assets/music/test.mp3")),
          AudioSource.uri(Uri.parse("asset:///assets/music/test2.mp3")),
          AudioSource.uri(Uri.parse("asset:///assets/music/test3.mp3")),
          AudioSource.uri(Uri.parse("asset:///assets/music/test4.mp3")),
        ],
      ),
      initialIndex: 0,
      initialPosition: Duration.zero,
    );
    _audioPlayer.setLoopMode(LoopMode.all);

    // listen for changes in player state
    _audioPlayer.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;
      if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {
        buttonNotifier.value = ButtonState.loading;
      } else if (!isPlaying) {
        buttonNotifier.value = ButtonState.paused;
      } else if (processingState != ProcessingState.completed) {
        buttonNotifier.value = ButtonState.playing;
      } else {
        _audioPlayer.seek(Duration.zero);
        _audioPlayer.pause();
      }
    });

    // listen for changes in play position
    _audioPlayer.positionStream.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });

    // listen for changes in the buffered position
    _audioPlayer.bufferedPositionStream.listen((bufferedPosition) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: bufferedPosition,
        total: oldState.total,
      );
    });

    // listen for changes in the total audio duration
    _audioPlayer.durationStream.listen((totalDuration) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: totalDuration ?? Duration.zero,
      );
    });
  }

  void play() async {
    _audioPlayer.play();
  }

  void pause() {
    _audioPlayer.pause();
  }

  void seek(Duration position) {
    _audioPlayer.seek(position);
  }

  void dispose() {
    _audioPlayer.dispose();
  }

  void mute() {
    if (_audioPlayer.volume == 0) {
      _audioPlayer.setVolume(100);
      volume = Icon(
        FontAwesomeIcons.volumeUp,
        color: Colors.white,
      );
    } else {
      _audioPlayer.setVolume(0);
      volume = Icon(
        FontAwesomeIcons.volumeMute,
        color: Colors.white,
      );
    }
  }
}

class ProgressBarState {
  ProgressBarState({
    required this.current,
    required this.buffered,
    required this.total,
  });
  final Duration current;
  final Duration buffered;
  final Duration total;
}

enum ButtonState { paused, playing, loading }
