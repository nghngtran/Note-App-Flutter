import 'dart:io' show Directory, FileSystemEntity, Platform;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:note_app/view_model/note_view_model.dart';

class ChooseFileAudio extends StatelessWidget {
  final NoteViewModel model;
//  Future<List<Directory>> _externalDocumentsDirectory;
  ChooseFileAudio(NoteViewModel _model) : model = _model;
  String _fileName;
  String _path;
  String _extension;
  FileType _pickingType = FileType.audio;
  void checkPermission() async {
    _path = await FilePicker.getFilePath(
        type: _pickingType,
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '')?.split(',')
            : null);
    _fileName = _path != null ? _path.split('/').last : '...';
    print(_fileName);
  }

  void _clearCachedFiles() {
    FilePicker.clearTemporaryFiles().then((result) {});
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width / 100;
    double h = MediaQuery.of(context).size.height / 100;
    checkPermission();
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('Pick audio',
              style: TextStyle(color: Theme.of(context).iconTheme.color)),
        ),
        body: GestureDetector(
            onTap: () {
              model.setContentChildItem(_path);
              Navigator.of(context).pop();
            },
            child: Container(
                height: h * 5,
                width: w * 100,
                padding: EdgeInsets.fromLTRB(w * 2, h, w, h),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.music_note,
                          color: Theme.of(context).iconTheme.color, size: 16),
//                      Text(
//                        _fileName,
//                        style: TextStyle(
//                            color: Theme.of(context).iconTheme.color,
//                            fontSize: 15),
//                      )
                    ]))));
  }
}
