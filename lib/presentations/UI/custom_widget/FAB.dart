import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/presentations/UI/page/create_note.dart';
import 'package:note_app/presentations/UI/page/image_pick.dart';
import 'package:note_app/utils/database/model/note.dart';
import 'package:note_app/utils/database/model/noteItem.dart';
import 'package:note_app/view_model/note_view_model.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class FancyFab extends StatefulWidget {
//  Notes note;
// / FancyFab(Notes _note) : note = _note;
  final NoteViewModel model;
  FancyFab(this.model);
  @override
  _FancyFabState createState() => _FancyFabState();
}

class _FancyFabState extends State<FancyFab>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animateIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;
  bool isVisible;

  @override
  initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(
      begin: Colors.black,
      end: Colors.red,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Widget text() {
    return Container(
      child: FloatingActionButton(
        heroTag: "btnAdd",
        onPressed: () {
          final NoteItem noteItem = NoteItem("Text");
          Provider.of<Notes>(context, listen: true).addNoteItem(noteItem);
//          widget.note.addNoteItem(noteItem);
          widget.model.addNoteItem(noteItem);
          animate();
        },
        tooltip: 'Text',
        child: Icon(Icons.create),
      ),
    );
  }

  Widget image() {
    return Container(
      child: FloatingActionButton(
        heroTag: "btnImg",
        onPressed: () {
          final NoteItem noteItem = NoteItem("Image");
//          Provider.of<Notes>(context, listen: true).addNoteItem(noteItem);
          widget.model.addNoteItem(noteItem);
          animate();
        },
        tooltip: 'Image',
        child: Icon(Icons.camera_alt),
      ),
    );
  }

  Widget audio() {
    return Container(
      child: FloatingActionButton(
        heroTag: "btnSound",
        onPressed: () {
          final NoteItem noteItem = NoteItem("Audio");
          widget.model.addNoteItem(noteItem);
//          Provider.of<Notes>(context, listen: true).addNoteItem(noteItem);
          animate();
        },
        tooltip: 'Audio',
        child: Icon(Icons.audiotrack),
      ),
    );
  }

  Widget toggle() {
    return Container(
      child: FloatingActionButton(
        backgroundColor: _buttonColor.value,
        onPressed: animate,
        tooltip: 'Toggle',
        child: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: _animateIcon,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 3,
            0.0,
          ),
          child: text(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 2,
            0.0,
          ),
          child: image(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value,
            0.0,
          ),
          child: audio(),
        ),
        toggle(),
      ],
    );
  }
}
