import 'dart:io';
import 'package:flutter/material.dart';
import 'package:note_app/presentations/UI/custom_widget/custom_list_notes.dart';
import 'package:note_app/utils/model/noteItem.dart';

import 'package:note_app/view_model/note_view_model.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';

enum RecordStatus {
  IDEL,
  RECORDING,
  PAUSE,
// COMPLETE,
// ERROR,
}

class Record extends StatefulWidget {
  final NoteViewModel model;
  Record(NoteViewModel _model) : model = _model;
  RecordState createState() => RecordState();
}

class RecordState extends State<Record> {
  bool isComplete = false;
  String fileName = "";
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width / 100;
    double h = MediaQuery.of(context).size.height / 100;
    return Container(
      width: w * 100,
      height: h * 20,
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          border: Border(
              left: BorderSide(color: Colors.transparent),
              right: BorderSide(color: Colors.transparent)),
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).backgroundColor),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: h * 2),
          GestureDetector(
              onTap: () {
                getFilePath();
                NoteItem tmp = NoteItem("Audio");
                tmp.content = fileName;
                widget.model.addNoteItem(tmp);
                Navigator.of(context).pushNamed('create_note');
              },
              child: Icon(Icons.check,
                  color: Theme.of(context).iconTheme.color, size: 20)),
          Center(
            child: Icon(Icons.mic_none,
                color: Theme.of(context).iconTheme.color, size: 20),
          ),
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              InkWell(
                child: Icon(
                  Icons.play_circle_filled,
                  color: Theme.of(context).iconTheme.color,
                  size: 20,
                ),
                onTap: () async {
                  startRecord();
                },
              ),
              InkWell(
                  child: Icon(
                    Icons.play_circle_outline,
                    color: Theme.of(context).iconTheme.color,
                    size: 20,
                  ),
                  onTap: () async {
                    play();
                  }),
              InkWell(
                child: Icon(
                  Icons.stop,
                  color: Theme.of(context).iconTheme.color,
                  size: 20,
                ),
                onTap: () async {
                  stopRecord();
                },
              )
            ],
          ))
        ],
      ),
    );
  }

  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  void startRecord() async {
    bool hasPermission = await checkPermission();
    if (hasPermission) {
      recordFilePath = await getFilePath();
      isComplete = false;
      RecordMp3.instance.start(recordFilePath, (type) {
        setState(() {});
      });
    } else {}
    setState(() {});
  }

  void pauseRecord() {
    if (RecordMp3.instance.status == RecordStatus.PAUSE) {
      bool s = RecordMp3.instance.resume();
      if (s) {
        setState(() {});
      }
    } else {
      bool s = RecordMp3.instance.pause();
      if (s) {
        setState(() {});
      }
    }
  }

  void stopRecord() {
    bool s = RecordMp3.instance.stop();
    if (s) {
      isComplete = true;
      setState(() {});
    }
  }

  void resumeRecord() {
    bool s = RecordMp3.instance.resume();
    if (s) {
      setState(() {});
    }
  }

  String recordFilePath;

  void play() {
    if (recordFilePath != null && File(recordFilePath).existsSync()) {
      AudioPlayer audioPlayer = AudioPlayer();
      audioPlayer.play(recordFilePath, isLocal: true);
    }
  }

  int i = 0;

  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = storageDirectory.path + "/record";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    fileName = sdPath + "/test_${i++}.mp3";
    return fileName;
  }
}
