import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note_app/application/constants.dart';

import 'package:note_app/presentations/UI/page/edit_note.dart';
import 'package:note_app/utils/bus/note_bus.dart';
import 'package:note_app/utils/bus/thumbnail_bus.dart';
import 'package:note_app/utils/model/tag.dart';
import 'package:note_app/utils/model/thumbnailNote.dart';
import 'package:note_app/view_model/list_tb_note_view_model.dart';

class NoteCard extends StatefulWidget {
  ThumbnailNote noteCard;
  final ValueChanged<String> parentAction; ////callback
  NoteCard(ThumbnailNote note, ValueChanged<String> parent)
      : this.noteCard = note,
        parentAction = parent;

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

  Widget showTag(BuildContext context, Tag tag) {
    return Wrap(children: <Widget>[
      Icon(Icons.local_offer, color: tag.color, size: 16),
      SizedBox(width: MediaQuery.of(context).size.width / 100),
      Text(tag.title,
          style:
              Theme.of(context).textTheme.subtitle.copyWith(color: tag.color))
    ]);
  }

  Widget build(BuildContext context) {
    print(noteCard.content);
    if (noteCard.content == "Empty Note!") {
      return InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditNote(noteCard)),
            );
          },
          onLongPress: () async {
            showDialog(
                context: context,
                builder: (BuildContext context) => CupertinoAlertDialog(
                  title: Text('Do you want to remove this note ?'),
                  actions: <Widget>[
                    CupertinoDialogAction(
                      child: Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    CupertinoDialogAction(
                      child: Text('Yes'),
                      onPressed: () async {
                        NoteBUS noteBus = NoteBUS();
                        var stt =
                        await noteBus.deleteNoteById(noteCard.noteId);
                        NoteCreatedModel model = NoteCreatedModel();
                        model.deleteNote(noteCard);
                        widget.parentAction("RELOAD!");
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ));
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
    color: (noteCard.color == Theme.of(context).cardColor)
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
      ])])));
    }
    else if (noteCard.content.length > 0) {
      if (noteCard.type == "Image") {
        enCodeImg();
        return InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditNote(noteCard)),
              );
            },
            onLongPress: () async {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => CupertinoAlertDialog(
                        title: Text('Do you want to remove this note ?'),
                        actions: <Widget>[
                          CupertinoDialogAction(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          CupertinoDialogAction(
                            child: Text('Yes'),
                            onPressed: () async {
                              NoteBUS noteBus = NoteBUS();
                              var stt =
                                  await noteBus.deleteNoteById(noteCard.noteId);
                              NoteCreatedModel model = NoteCreatedModel();
                              model.deleteNote(noteCard);
                              widget.parentAction("RELOAD!");
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ));
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
                  color: Theme.of(context).cardColor,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(noteCard.title,
                        style: Theme.of(context).textTheme.title.copyWith(
                            color: Theme.of(context).iconTheme.color)),
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
              showDialog(
                  context: context,
                  builder: (BuildContext context) => CupertinoAlertDialog(
                        title: Text('Do you want to remove this note ?'),
                        actions: <Widget>[
                          CupertinoDialogAction(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          CupertinoDialogAction(
                            child: Text('Yes'),
                            onPressed: () async {
                              NoteBUS noteBus = NoteBUS();
                              var stt =
                                  await noteBus.deleteNoteById(noteCard.noteId);
                              NoteCreatedModel model = NoteCreatedModel();
                              model.deleteNote(noteCard);
                              widget.parentAction("RELOAD!");
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ));
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
                  color: (noteCard.color == Theme.of(context).cardColor)
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
                    noteCard.tags.length > 0
                        ? noteCard.tags.length > 2
                            ? Wrap(
//                              mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  showTag(context, noteCard.tags.first),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          100 *
                                          2),
                                  showTag(context, noteCard.tags[1]),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          100 *
                                          3),
                                  Container(
//                                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    width: MediaQuery.of(context).size.width /
                                        100 *
                                        4,
                                    height: MediaQuery.of(context).size.width /
                                        100 *
                                        4,
                                    child: CircleAvatar(
                                        backgroundColor: Colors.orangeAccent
                                            .withOpacity(0.8),
                                        child: Text(
                                            "+" +
                                                (noteCard.tags.length - 2)
                                                    .toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle
                                                .copyWith(
                                                    color: Theme.of(context)
                                                        .iconTheme
                                                        .color,
                                                    fontWeight: Font.Regular,
                                                    fontSize: 10))),
                                  )
                                ],
                              )
                            : Wrap(
//
                                children: <Widget>[
                                    showTag(context, noteCard.tags.first)
                                  ])
                        : Text(""),
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

      else if(noteCard.type == "Audio")
        { return InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditNote(noteCard)),
            );
          },
          onLongPress: () async {
            showDialog(
                context: context,
                builder: (BuildContext context) => CupertinoAlertDialog(
                      title: Text('Do you want to remove this note ?'),
                      actions: <Widget>[
                        CupertinoDialogAction(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        CupertinoDialogAction(
                          child: Text('Yes'),
                          onPressed: () async {
                            NoteBUS noteBus = NoteBUS();
                            var stt =
                                await noteBus.deleteNoteById(noteCard.noteId);
                            NoteCreatedModel model = NoteCreatedModel();
                            model.deleteNote(noteCard);
                            widget.parentAction("RELOAD!");
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ));
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
                color: Theme.of(context).backgroundColor,
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
                        Icon(Icons.audiotrack,
                            size: 24, color: Theme.of(context).iconTheme.color),
                        SizedBox(
                            height:
                                2 * MediaQuery.of(context).size.height / 100),
                        Text(noteCard.content.split('/').last.substring(0, 10),
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: Font.Name,
                                fontWeight: Font.Regular,
                                color: Theme.of(context).iconTheme.color))
                      ],
                    )
                  ])));}
    }
  }
}
