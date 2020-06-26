import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:note_app/utils/model/noteItem.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:note_app/view_model/note_view_model.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:audiofileplayer/audiofileplayer.dart';
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
  ByteData _audioByteData;
  void initState() {
    super.initState();
    isRecording = false;
  }

  void _saveAudio(ByteData byteData, String fileName,
      {Function success, Function fail}) async {
    AudioPlayer advancedPlayer = AudioPlayer();
    advancedPlayer.startHeadlessService();
    final buffer = byteData.buffer;
    String tempPath = fileName;
    File image = File(tempPath);
    bool isExist = await image.exists();
    if (isExist) await image.delete();
    File(tempPath)
        .writeAsBytes(
            buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes))
        .then((_) {
      print("success");
      if (success != null) success();
    });
  }

  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width / 100;
    double h = MediaQuery.of(context).size.height / 100;
    getFilePath();
    return Container(
      width: w * 100,
      height: h * 30,

      child: GestureDetector(
          onTap: () async {
            setState(() {
              isRecording = !isRecording;
            });
            if (isRecording) {
              startRecord();
            } else {
              stopRecord();
              _loadAudioByteData();
              _saveAudio(_audioByteData, fileName);
              NoteItem tmp = NoteItem("Audio");
              print("File" + fileName);
              tmp.setContent(fileName);
              widget.model.addNoteItem(tmp);
              Navigator.of(context).pop();
            }
          },
          child: isRecording
              ? SpinKitThreeBounce(
                  color: Theme.of(context).iconTheme.color, size: 42)
              : Icon(Icons.mic_none, color: Theme.of(context).iconTheme.color)),
//
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

  void _loadAudioByteData() async {
    _audioByteData = await rootBundle.load(fileName);
    setState(() {});
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

  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = storageDirectory.path + "/record";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    fileName = sdPath + "/record_${DateTime.now()}.mp3";
    return fileName;
  }
}
