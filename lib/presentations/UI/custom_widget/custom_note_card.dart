import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note_app/application/constants.dart';
import 'package:note_app/presentations/UI/custom_widget/custom_text_style.dart';
import 'package:note_app/presentations/UI/page/edit_note.dart';
import 'package:note_app/utils/bus/note_bus.dart';
import 'package:note_app/utils/bus/thumbnail_bus.dart';
import 'package:note_app/utils/model/thumbnailNote.dart';
import 'package:note_app/view_model/list_tb_note_view_model.dart';

class NoteCard extends StatefulWidget {
  ThumbnailNote noteCard;
  NoteCard(ThumbnailNote note) : this.noteCard = note;

  NoteCardState createState() {
    return NoteCardState(noteCard);
  }
}

class DateNote {
  String date;
  DateNote({String dateNote}) : date = dateNote;
}

class NoteCardState extends State<NoteCard> {
  ThumbnailNote noteCard;

  NoteCardState(ThumbnailNote note) {
    this.noteCard = note;
  }

  Uint8List bytes;
  void enCodeImg() {
    File imgFile = File(noteCard.content);
    bytes = imgFile.readAsBytesSync();
  }

  Widget build(BuildContext context) {
    if (noteCard.type == "Image") {
      enCodeImg();
      return InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {},
          child: Container(
              margin: EdgeInsets.only(
                  top: 2 * MediaQuery.of(context).size.height / 100),
              padding:
                  EdgeInsets.all(4 * MediaQuery.of(context).size.width / 100),
              width: 45 * MediaQuery.of(context).size.width / 100,
              decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).iconTheme.color, width: 0.6),
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: Theme.of(context).backgroundColor,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(noteCard.title,
                      style: Theme.of(context)
                          .textTheme
                          .title
                          .copyWith(color: Colors.black)),
                  SizedBox(height: MediaQuery.of(context).size.height / 100),
                  Row(children: <Widget>[
                    noteCard.tags.length > 0
                        ? Icon(Icons.local_offer,
                            color: noteCard.tags.first.color, size: 16)
                        : Container(),
                    SizedBox(width: MediaQuery.of(context).size.width / 100),
                    noteCard.tags.length > 0
                        ? Text(noteCard.tags.first.title,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle
                                .copyWith(color: noteCard.tags.first.color))
                        : Container()
                  ]),
                  SizedBox(
                      height: 2 * MediaQuery.of(context).size.height / 100),
                  Stack(children: <Widget>[
                    Container(
                        width: 25 * MediaQuery.of(context).size.height / 100,
                        height: 20 * MediaQuery.of(context).size.height / 100,
                        child: Image.memory(
                          bytes,
                          fit: BoxFit.cover,
                        ))
                  ]),
                ],
              )));
    } else if (noteCard.type == "Text") {
      return InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditNote(noteCard)),
            );
          },
          onLongPress: () async {
//          Thumbnail xóa đúng, nhưng noteBus sai !!
            NoteBUS noteBus = NoteBUS();
            var stt = await noteBus.deleteNoteById(noteCard.noteId);
            NoteCreatedModel model = NoteCreatedModel();
            model.deleteNote(noteCard);
          },
          child: Container(
              margin: EdgeInsets.only(
                  top: 2 * MediaQuery.of(context).size.height / 100),
              padding:
                  EdgeInsets.all(4 * MediaQuery.of(context).size.width / 100),
              width: 45 * MediaQuery.of(context).size.width / 100,
              decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).iconTheme.color.withOpacity(0.6),
                    width: 0.5),
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: (noteCard.color == Colors.transparent)
                    ? Theme.of(context).backgroundColor
                    : noteCard.color,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(noteCard.title,
                      style: TextStyle(
                          fontSize: 17,
                          fontFamily: Font.Name,
                          fontWeight: Font.Medium,
                          color: Theme.of(context).iconTheme.color)),
                  SizedBox(height: MediaQuery.of(context).size.height / 100),
                  Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          noteCard.tags.length > 0
                              ? Icon(Icons.local_offer,
                                  color: noteCard.tags.first.color, size: 16)
                              : Container(),
                          SizedBox(
                              width: MediaQuery.of(context).size.width / 100),
                          noteCard.tags.length > 0
                              ? Text(noteCard.tags.first.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle
                                      .copyWith(
                                          color: noteCard.tags.first.color))
                              : Container()
                        ],
                      ) ??
                      Text(""),
                  SizedBox(
                      height: 2 * MediaQuery.of(context).size.height / 100),
                  Text(noteCard.content,
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: Font.Name,
                          fontWeight: Font.Regular,
                          color: Theme.of(context).iconTheme.color))
                ],
              )));
    }
  }
}
