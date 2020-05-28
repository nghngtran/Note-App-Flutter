import 'dart:io';
import 'dart:typed_data';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:note_app/presentations/UI/page/customPaint.dart';
import 'package:path/path.dart';

class PreviewImageScreen extends StatefulWidget {
  final String imagePath;

  PreviewImageScreen({this.imagePath});

  @override
  _PreviewImageScreenState createState() => _PreviewImageScreenState();
}

class _PreviewImageScreenState extends State<PreviewImageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Preview your image'),
          backgroundColor: Color.fromRGBO(255, 209, 16, 1.0),
        ),
        body: Center(
            child: GestureDetector(
                onTap: () {
                  Image tmp = Image.file(File(widget.imagePath));
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CustomPaintPage(tmp)));
                },
                child: Image.file(File(widget.imagePath), fit: BoxFit.cover))));
  }

  Future<ByteData> getBytesFromFile() async {
    Uint8List bytes = File(widget.imagePath).readAsBytesSync() as Uint8List;
    return ByteData.view(bytes.buffer);
  }
}
