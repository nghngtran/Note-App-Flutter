import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:note_app/presentations/UI/page/create_note.dart';
import 'package:note_app/presentations/UI/page/customPaint.dart';
import 'package:note_app/utils/model/noteItem.dart';
import 'package:note_app/view_model/note_view_model.dart';
import 'package:gallery_saver/gallery_saver.dart';

class PreviewImageScreen extends StatefulWidget {
//  final NoteViewModel model;
  final String imagePath;
  final NoteViewModel model;
  PreviewImageScreen(this.imagePath, NoteViewModel _model) : model = _model;

  @override
  _PreviewImageScreenState createState() => _PreviewImageScreenState();
}

class _PreviewImageScreenState extends State<PreviewImageScreen> {
  void _saveImage(Uint8List uint8List, Directory dir, String fileName,
      {Function success, Function fail}) async {
    bool isDirExist = await Directory(dir.path).exists();
    if (!isDirExist) Directory(dir.path).create();
    String tempPath = '${dir.path}$fileName';
    File image = File(tempPath);
    bool isExist = await image.exists();
    if (isExist) await image.delete();
    File(tempPath).writeAsBytes(uint8List).then((_) {
      print("succéess");
      if (success != null) success();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text('Preview your image',
              style: TextStyle(color: Theme.of(context).iconTheme.color)),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.check),
                onPressed: () async {
//                  print("save " + widget.imagePath);
//                  await GallerySaver.saveImage(widget.imagePath,
//                      albumName: "NoteApp");
                  Uint8List bytes =
                      File(widget.imagePath).readAsBytesSync() as Uint8List;
                  await _saveImage(
                      bytes,
                      Directory('/storage/emulated/0/NoteApp/'),
                      widget.imagePath.split("/").last);
                  NoteItem tmp = NoteItem("Image");
                  var pathImg = '/storage/emulated/0/NoteApp/' +
                      widget.imagePath.split("/").last;
                  tmp.content = pathImg;
                  widget.model.addNoteItem(tmp);
//                  Navigator.of(context)
//                      .push(
                  MaterialPageRoute(builder: (BuildContext context) {
                    return CreateNote();
                  });
                })
          ],
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
