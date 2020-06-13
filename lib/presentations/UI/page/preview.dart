import 'dart:io';
import 'dart:typed_data';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:note_app/presentations/UI/page/customPaint.dart';
import 'package:note_app/view_model/note_view_model.dart';
import 'package:path/path.dart';

class PreviewImageScreen extends StatefulWidget {
  final NoteViewModel model;
  final String imagePath;

  PreviewImageScreen({this.imagePath, NoteViewModel modelView})
      : model = modelView;

  @override
  _PreviewImageScreenState createState() => _PreviewImageScreenState();
}

class _PreviewImageScreenState extends State<PreviewImageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text('Preview your image',
              style: TextStyle(color: Theme.of(context).iconTheme.color)),
          backgroundColor: Color.fromRGBO(255, 209, 16, 1.0),
        ),
        body: Center(
            child: GestureDetector(
                onTap: () {
                  Image tmp = Image.file(File(widget.imagePath));
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CustomPaintPage(
                              File(widget.imagePath), widget.model)));
                },
                child: Image.file(File(widget.imagePath), fit: BoxFit.cover))));
  }

  Future<ByteData> getBytesFromFile() async {
    Uint8List bytes = File(widget.imagePath).readAsBytesSync() as Uint8List;
    return ByteData.view(bytes.buffer);
  }
}
