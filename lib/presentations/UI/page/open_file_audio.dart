import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:note_app/utils/database/model/note.dart';
import 'package:note_app/utils/database/model/noteItem.dart';
import 'package:note_app/view_model/note_view_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_permissions/simple_permissions.dart';

class ChooseFileAudio extends StatelessWidget {
  final NoteViewModel model;
//  Future<List<Directory>> _externalDocumentsDirectory;
  ChooseFileAudio(NoteViewModel _model) : model = _model;
  FileSystemEntity choose;
  ScrollController controller = ScrollController();
  static Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  List<FileSystemEntity> _files;
  List<FileSystemEntity> _songs = [];
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width / 100;
    double h = MediaQuery.of(context).size.height / 100;
    SimplePermissions.requestPermission(Permission.ReadExternalStorage)
        .then((value) {
      if (value == PermissionStatus.authorized) {
        localPath.then((String value) {
          print("True");
          Directory dir = Directory('/storage/emulated/0/Download');

          _files = dir.listSync(recursive: true, followLinks: false);
          for (FileSystemEntity entity in _files) {
            String path = entity.path;
            if (path.endsWith('.mp3')) _songs.add(entity);
          }
        });
      }
    });
    print(_songs.length.toString());
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('Pick audio',
              style: TextStyle(color: Theme.of(context).iconTheme.color)),
        ),
        body: ListView.builder(
          controller: controller,
          itemCount: _songs.length,
          itemBuilder: (BuildContext context, int index) {
            final item = _songs[index];
            return GestureDetector(
                onTap: () {
                  choose = item;
                  NoteItem tmp = NoteItem("Audio");
                  tmp.type = "Audio";
                  tmp.content = item.path;
//                  Provider.of<Notes>(context, listen: true).addNoteItem(tmp);
                  model.addNoteItem(tmp);
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
                              color: Theme.of(context).iconTheme.color,
                              size: 16),
                          Text(
                            item.path,
                            style: TextStyle(
                                color: Theme.of(context).iconTheme.color,
                                fontSize: 15),
                          )
                        ])));
          },
        ));
  }
}
