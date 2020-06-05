import 'dart:io';
import 'package:flutter/material.dart';
import 'package:note_app/presentations/UI/custom_widget/custom_list_notes.dart';
import 'package:note_app/utils/model/noteItem.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:note_app/view_model/note_view_model.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/cupertino.dart';

import 'package:record_mp3/record_mp3.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';

enum RecordStatus {
  IDEL,
  RECORDING,
  PAUSE,
}

class Record extends StatefulWidget {
  final NoteViewModel model;
  Record(NoteViewModel _model) : model = _model;
  RecordState createState() => RecordState();
}

class RecordState extends State<Record> {
  bool isComplete;
  bool isRecording;
  String fileName = "";
  void initState() {
    super.initState();
    isRecording = false;
  }

  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width / 100;
    double h = MediaQuery.of(context).size.height / 100;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: w * 100,
        height: h * 30,
        color: Colors.yellow,
        child: GestureDetector(
            onTap: () async {
              setState(() {
                isRecording = !isRecording;
              });
              if (isRecording) {
                getFilePath();
                NoteItem tmp = NoteItem("Audio");
                print("FIle" + fileName);
                tmp.setContent(fileName);
                widget.model.addNoteItem(tmp);
                startRecord();
              } else {
                stopRecord();
                Navigator.of(context).pop();
              }
            },
            child: isRecording
                ? SpinKitThreeBounce(
                    color: Theme.of(context).iconTheme.color, size: 42)
                : Icon(Icons.mic_none,
                    color: Theme.of(context).iconTheme.color)),
//
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
    print("stop");
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
