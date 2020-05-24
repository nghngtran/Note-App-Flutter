import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/application/constants.dart';
import 'package:note_app/presentations/UI/custom_widget/FAB.dart';
import 'package:note_app/presentations/UI/custom_widget/choose_title.dart';
import 'package:note_app/presentations/UI/custom_widget/custom_text_style.dart';
import 'package:note_app/presentations/UI/custom_widget/tab_bar_note.dart';
import 'package:note_app/presentations/UI/page/MoreOptionsSheet.dart';
import 'package:note_app/presentations/UI/page/base_view.dart';
import 'package:note_app/presentations/UI/page/camera_access.dart';
import 'package:note_app/presentations/UI/page/create_tag.dart';
import 'package:note_app/presentations/UI/page/customPaint.dart';
import 'package:note_app/presentations/UI/page/home_screen.dart';
import 'package:note_app/presentations/UI/page/image_pick.dart';
import 'package:note_app/utils/database/dao/note_dao.dart';
import 'package:note_app/utils/database/model/note.dart';
import 'package:note_app/utils/database/model/noteItem.dart';
import 'package:note_app/view_model/list_tag_viewmodel.dart';
import 'package:note_app/view_model/note_view_model.dart';
import 'package:provider/provider.dart';

class CreateNote extends StatefulWidget {
  CreateNoteState createState() => CreateNoteState();
}

class CreateNoteState extends State<CreateNote> {
  ScrollController mainController = ScrollController();
  TagCreatedModel tagCreatedModel;

  var note = new Notes();
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    mainController.dispose();
    super.dispose();
  }

  Future<void> _handleClickMe() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Save your changes to this note ?'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Don\'t save'),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
            ),
            CupertinoDialogAction(
              child: Text('Continue'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width / 100;
    double h = MediaQuery.of(context).size.height / 100;
    print(note.contents.length);
    return BaseView<NoteViewModel>(
        onModelReady: (noteViewModel) => noteViewModel.getListItems(),
        builder: (context, noteViewModel, child) => Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomPadding: false,
            floatingActionButton: FancyFab(noteViewModel),
            appBar: AppBar(
                title: Text('Create new note',
                    style: TextStyle(color: Colors.black)),
                backgroundColor: Color.fromRGBO(255, 209, 16, 1.0),
                leading: BackButton(
                  color: Colors.black,
                  onPressed: () {
                    _handleClickMe();
                  },
                )),
            body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: h * 2),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(
                            flex: 6,
                            child: InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) => Dialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: ChooseTitle(noteViewModel)));
//                      print(note.title);
                                },
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(width: w * 4),
                                      Text(
//                                        Provider.of<Notes>(context,
//                                                listen: true)
//                                            .title,
                                        noteViewModel.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subhead
                                            .copyWith(
                                                color: Colors.black,
                                                fontWeight: Font.Regular),
                                      ),
                                      SizedBox(width: w * 2),
                                      Image.asset(
                                        "assets/edit.png",
                                        fit: BoxFit.contain,
                                        width: w * 5,
                                        height: w * 5,
                                      )
                                    ],
                                  ),
                                ))),
                        Expanded(
                            child: GestureDetector(
                          onTap: () {
                            note.contents = noteViewModel.contents;
                            print(note.contents[0].toString());
                            note.title = noteViewModel.title;
                            note.tags = noteViewModel.tags;
                            print(note.tags[0].toString());
                            NoteDAO.insertNote(note);
                            Future<Notes> notedetail;
                            var listNotes = NoteDAO.getNotes();
                            listNotes.then((list) => list.forEach((note) => {
                                  print(note.toString()),
                                  notedetail = NoteDAO.getNoteByID(note.id),
                                  notedetail.then((noteD) => {
                                        noteD.tags.forEach((tag) =>
                                            print("\t" + tag.toString())),
                                        noteD.contents.forEach((noteItem) =>
                                            print("\t" + noteItem.toString()))
                                      })
                                }));
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/', (Route<dynamic> route) => false);
                          },
                          child: Text(
                            "Save",
                            style: Theme.of(context).textTheme.title.copyWith(
                                color: Colors.blue, fontWeight: Font.SemiBold),
                          ),
                        ))
                      ]),
                  TagBarOfNote(noteViewModel),
                  (noteViewModel.contents.length != null)
                      ? Expanded(
                          child: Container(child: ListNoteItems(noteViewModel)))
                      : Text("")
                ])));
  }
}

class ListNoteItems extends StatelessWidget {
//  Notes note;
//
//  ListNoteItems(Notes _note) : note = _note;
  final NoteViewModel model;
  ListNoteItems(this.model);
  ScrollController _controller = new ScrollController();
  @override
  Widget build(BuildContext context) {
    Timer(Duration(milliseconds: 1000),
        () => _controller.jumpTo(_controller.position.maxScrollExtent));
    return ListView(
      controller: _controller,
      children: getChildrenNotes(),
    );
  }

  List<Widget> getChildrenNotes() {
    return model.contents.map((todo) => NoteItemWidget(todo)).toList();
  }
}

class EditText extends StatefulWidget {
  NoteItem item;

  EditText(NoteItem _item) : item = _item;

  EditTextState createState() => EditTextState();
}

class EditTextState extends State<EditText> {
  TextEditingController txtController = TextEditingController();
  var note_color;
  var _editableNote;

  void initState() {
    _editableNote = widget.item;
    note_color = _editableNote.note_color;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtController.dispose();
    super.dispose();
  }

  void _changeColor(Color newColorSelected) {
    print("note color changed");
    setState(() {
      note_color = newColorSelected;
      _editableNote.note_color = newColorSelected;
    });
  }

  void bottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext ctx) {
          return MoreOptionsSheet(
            color: note_color,
            callBackColorTapped: _changeColor,
          );
        });
  }

  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width / 100;
    double h = MediaQuery.of(context).size.height / 100;
    widget.item.setContent(txtController.text);
    return InkWell(
        onLongPress: () {
          bottomSheet(context);
        },
        child: Padding(
            padding: EdgeInsets.fromLTRB(w * 4, h / 2, w * 2, h),
            child: Wrap(children: <Widget>[
              TextFormField(
                  autocorrect: false,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(w, h, w, h),
                      fillColor: note_color,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                  maxLength: null,
                  maxLines: null,
                  controller: txtController,
                  style: TextStyle(
                      fontSize: 17,
                      fontStyle: FontStyle.normal,
                      color: Colors.black),
                  onSaved: (value) {
                    widget.item.setContent(txtController.text);
                    widget.item.setBgColor(note_color);

                    print(widget.item.content);
                  })
            ])));
  }
}

class NoteItemWidget extends StatelessWidget {
  final NoteItem item;

  NoteItemWidget(NoteItem _item) : item = _item;

  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width / 100;
    double h = MediaQuery.of(context).size.height / 100;
    if (item.type == "Text") {
      return EditText(item);
    } else if (item.type == "Image") {
      return CupertinoAlertDialog(
        title: Text('Get image from ?'),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text('Camera'),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                var cameras = CameraDescription();
                return TakePictureScreen(camera: cameras);
              }));
            },
          ),
          CupertinoDialogAction(
              child: Text('Gallery'),
              onPressed: () {
                Navigator.of(context).pushNamed('pick_image');
              }),
        ],
      );
    }
    return Container(
        height: h * 5,
        margin: EdgeInsets.fromLTRB(w * 4, h * 2, w * 2, h),
        padding: EdgeInsets.fromLTRB(w, h, w, h),
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.black),
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(Icons.audiotrack, size: 20, color: Colors.black),
            SizedBox(width: w * 2),
            Text("Em Gai Mua audio",
                style: Theme.of(context)
                    .textTheme
                    .headline7
                    .copyWith(color: Colors.black))
          ],
        ));
  }
}
