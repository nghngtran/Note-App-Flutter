import 'package:flutter/material.dart';
import 'package:note_app/presentations/UI/page/create_note.dart';
import 'package:note_app/utils/database/model/noteItem.dart';
import 'package:page_transition/page_transition.dart';

class FancyFab extends StatefulWidget {
  final Function() onPressed;
  final String tooltip;
   Icon icon = Icon(Icons.add);

  FancyFab({this.onPressed, this.tooltip, this.icon});

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

  static List<NoteItem> listNote =  List<NoteItem>();
  void _addWidget(){
    setState(() {
      NoteItem newNote = NoteItem.withFullInfo("124","264",NoteItemType.TEXT,"Ahihi","abd","adf",DateTime.now(),DateTime.now());
      listNote.add(newNote);
    });
  }
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
      child: FloatingActionButton(heroTag: "btnAdd",
        onPressed:(){
          _addWidget();
//        _secondPage(context,CreateNote(listNote));
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateNote(listNote)));
        },
        tooltip: 'Text',
        child: Icon(Icons.create),
      ),
    );
  }
  _secondPage(BuildContext context, Widget page) async {
    final dataFromSecondPage = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    ) as List<NoteItem>;

  }
  Widget image() {
    return Container(
      child: FloatingActionButton(heroTag: "btnImg",
        onPressed: null,
        tooltip: 'Image',
        child: Icon(Icons.camera_alt),
      ),
    );
  }

  Widget audio() {
    return Container(
      child: FloatingActionButton(heroTag: "btnSound",
        onPressed: null,
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
            _translateButton.value *3,
            0.0,
          ),
          child: text(),
        ),
        Transform(
          transform: Matrix4.translationValues(
           0.0,
            _translateButton.value*2 ,
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