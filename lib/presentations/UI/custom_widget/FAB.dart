//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:note_app/presentations/UI/page/create_note.dart';
//import 'package:note_app/presentations/UI/page/image_pick.dart';
//import 'package:note_app/utils/database/model/note.dart';
//import 'package:note_app/utils/database/model/noteItem.dart';
//import 'package:note_app/view_model/note_view_model.dart';
//import 'package:page_transition/page_transition.dart';
//import 'package:provider/provider.dart';
//import 'package:unicorndial/unicorndial.dart';
//
//class FancyFab extends StatefulWidget {
//  final NoteViewModel model;
//  FancyFab(this.model);
//  @override
//  _FancyFabState createState() => _FancyFabState();
//}
//
//class _FancyFabState extends State<FancyFab> {
//  List<UnicornButton> _getProfileMenu() {
//    List<UnicornButton> children = [];
//
//    children.add(_profileOption(
//        iconData: Icons.create,
//        onPressed: () {
//          final NoteItem noteItem = NoteItem("Text");
//          Provider.of<Notes>(context, listen: true).addNoteItem(noteItem);
//
//          widget.model.addNoteItem(noteItem);
//        }));
//    children.add(_profileOption(
//        iconData: Icons.camera_alt,
//        onPressed: () {
//          final NoteItem noteItem = NoteItem("Image");
//          widget.model.addNoteItem(noteItem);
//        }));
//    children.add(_profileOption(
//        iconData: Icons.audiotrack,
//        onPressed: () {
//          final NoteItem noteItem = NoteItem("Audio");
//          widget.model.addNoteItem(noteItem);
//        }));
//
//    return children;
//  }
//
//  Widget _profileOption({IconData iconData, Function onPressed}) {
//    return UnicornButton(
//        currentButton: FloatingActionButton(
//      backgroundColor: Colors.blue,
//      mini: true,
//      child: Icon(iconData),
//      onPressed: onPressed,
//    ));
//  }
//}
