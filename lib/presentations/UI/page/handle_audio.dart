import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:note_app/application/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wave/wave.dart';
import 'package:wave/config.dart';

enum PlayerState { stopped, playing, paused }

class HandleAudio extends StatefulWidget {
  final String url;
  final PlayerMode mode;

  HandleAudio(
      {Key key, @required this.url, this.mode = PlayerMode.MEDIA_PLAYER})
      : super(key: key);

  HandleAudioState createState() => HandleAudioState(url, mode);
}

class HandleAudioState extends State<HandleAudio> {
  String url;
  PlayerMode mode;

  AudioPlayer _audioPlayer;
  AudioPlayerState _audioPlayerState;
  Duration _duration;
  Duration _position;

  PlayerState _playerState = PlayerState.stopped;
  StreamSubscription _durationSubscription;
  StreamSubscription _positionSubscription;
  StreamSubscription _playerCompleteSubscription;
  StreamSubscription _playerErrorSubscription;
  StreamSubscription _playerStateSubscription;

  get _isPlaying => _playerState == PlayerState.playing;

  get _isPaused => _playerState == PlayerState.paused;

  get _durationText => _duration?.toString()?.split('.')?.first ?? '';

  get _positionText => _position?.toString()?.split('.')?.first ?? '';

  HandleAudioState(this.url, this.mode);
  bool visibilityProgress = false;
  bool isPlaying = false;
  bool isCompleted = false;
  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  bool playDone() {
    if (_position.inMilliseconds == _duration.inMilliseconds) return true;
    return false;
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerErrorSubscription?.cancel();
    _playerStateSubscription?.cancel();
    super.dispose();
  }

  void _onComplete() {
    setState(() => _playerState = PlayerState.stopped);
  }

  void _initAudioPlayer() {
    _audioPlayer = AudioPlayer(mode: mode);

    _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);

      // TODO implemented for iOS, waiting for android impl
      if (Theme.of(context).platform == TargetPlatform.iOS) {
//        // (Optional) listen for notification updates in the background
        _audioPlayer.startHeadlessService();
      }
    });

    _positionSubscription =
        _audioPlayer.onAudioPositionChanged.listen((p) => setState(() {
              _position = p;
            }));

    _playerCompleteSubscription =
        _audioPlayer.onPlayerCompletion.listen((event) {
      _onComplete();
      setState(() {
        _position = _duration;
      });
    });

    _playerErrorSubscription = _audioPlayer.onPlayerError.listen((msg) {
      print('audioPlayer error : $msg');
      setState(() {
        _playerState = PlayerState.stopped;
        _duration = Duration(seconds: 0);
        _position = Duration(seconds: 0);
      });
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        _audioPlayerState = state;
      });
    });

    _audioPlayer.onNotificationPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() => _audioPlayerState = state);
    });
  }

  Future<int> _play() async {
    final playPosition = (_position != null &&
            _duration != null &&
            _position.inMilliseconds > 0 &&
            _position.inMilliseconds < _duration.inMilliseconds)
        ? _position
        : null;

    final result = await _audioPlayer.play(this.url, position: playPosition);

    if (result == 1) {
      setState(() => _playerState = PlayerState.playing);
    }

    // default playback rate is 1.0
    // this should be called after _audioPlayer.play() or _audioPlayer.resume()
    // this can also be called everytime the user wants to change playback rate in the UI
//    _audioPlayer.setPlaybackRate(playbackRate: 1.0);

    return result;
  }

  Future<int> _pause() async {
    final result = await _audioPlayer.pause();
    if (result == 1) setState(() => _playerState = PlayerState.paused);
    return result;
  }

  Future<int> _stop() async {
    final result = await _audioPlayer.stop();
    if (result == 1) {
      setState(() {
        _playerState = PlayerState.stopped;
        _position = Duration();
      });
    }
    return result;
  }

  _buildCard(BuildContext context,
      {Config config, Color backgroundColor = Colors.transparent}) {
    double w = MediaQuery.of(context).size.width / 100;
    double h = MediaQuery.of(context).size.height / 100;

    return Card(
        color: Colors.transparent,
        elevation: 0.0,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(0.0))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
                child: Opacity(
                    opacity: 0.9,
                    child: WaveWidget(
                      config: config,
                      backgroundColor: backgroundColor,
                      size: Size(w * 100, h * 15),
                      waveAmplitude: 0,
                    ))),
            SizedBox(height: h),
            Expanded(
                child: Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                        _position != null
                            ? '${_positionText ?? ''} / ${_durationText ?? ''}'
                            : _duration != null ? _durationText : '',
                        style: TextStyle(
                            fontSize: 15,
                            color: Theme.of(context).iconTheme.color)))),
          ],
        )
//        )
        );
  }

  MaskFilter _blur;
  final List<MaskFilter> _blurs = [
    null,
    MaskFilter.blur(BlurStyle.normal, 5.0),
    MaskFilter.blur(BlurStyle.inner, 5.0),
    MaskFilter.blur(BlurStyle.outer, 5.0),
    MaskFilter.blur(BlurStyle.solid, 5.0),
  ];
  int _blurIndex = 0;
  MaskFilter _nextBlur() {
    if (_blurIndex == _blurs.length - 1) {
      _blurIndex = 0;
    } else {
      _blurIndex = _blurIndex + 1;
    }
    _blur = _blurs[_blurIndex];
    return _blurs[_blurIndex];
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width / 100;
    double h = MediaQuery.of(context).size.height / 100;
    return InkWell(
        onTap: () {
          setState(() {
            isPlaying = !isPlaying;
            visibilityProgress = !visibilityProgress;
          });
          isPlaying ? _play() : _pause();
        },
        child: Container(
            height: MediaQuery.of(context).size.height / 100 * 8,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.fromLTRB(w * 4, h * 2, w * 2, h),
            padding: EdgeInsets.fromLTRB(w, h, w, h),
            child: (visibilityProgress)
                ? _buildCard(context,
                    config: CustomConfig(
                      gradients: [
                        [Colors.blue, Colors.blueAccent],
                        [Colors.redAccent, Colors.deepPurpleAccent],
                        [Colors.purple, Colors.lightBlue],
                        [Colors.lightBlue, Colors.deepPurple]
                      ],
                      durations: [35000, 19440, 10800, 6000],
                      heightPercentages: [0.20, 0.23, 0.25, 0.30],
                      blur: _blur,
                      gradientBegin: Alignment.bottomLeft,
                      gradientEnd: Alignment.topRight,
                    ))
                : SizedBox(
                    width: w * 2,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(Icons.audiotrack,
                              size: 24,
                              color: Theme.of(context).iconTheme.color),
                          SizedBox(width: w * 2),
                          url.length > 0
                              ? Text(url.split('/').last.substring(0, 30),
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontFamily: Font.Name,
                                      fontWeight: Font.Regular,
                                      color: Theme.of(context).iconTheme.color))
                              : null
                        ]))));
  }
}
