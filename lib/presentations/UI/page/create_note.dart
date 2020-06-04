import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note_app/application/constants.dart';
import 'package:note_app/presentations/UI/custom_widget/FAB.dart';
import 'package:note_app/presentations/UI/custom_widget/choose_title.dart';
import 'package:note_app/presentations/UI/custom_widget/custom_text_style.dart';
import 'package:note_app/presentations/UI/custom_widget/tab_bar_note.dart';
import 'package:note_app/presentations/UI/page/MoreOptionsSheet.dart';
import 'package:note_app/presentations/UI/page/base_view.dart';
import 'package:note_app/presentations/UI/page/camera.dart';
import 'package:note_app/presentations/UI/page/camera_access.dart';
import 'package:note_app/presentations/UI/page/create_tag.dart';
import 'package:note_app/presentations/UI/page/customPaint.dart';
import 'package:note_app/presentations/UI/page/home_screen.dart';
import 'package:note_app/presentations/UI/page/image_pick.dart';
import 'package:note_app/presentations/UI/page/open_file_audio.dart';
import 'package:note_app/presentations/UI/page/record_audio.dart';
import 'package:note_app/utils/database/dao/note_dao.dart';
import 'package:note_app/utils/database/model/note.dart';
import 'package:note_app/utils/database/model/noteItem.dart';
import 'package:note_app/view_model/list_tag_viewmodel.dart';
import 'package:note_app/view_model/note_view_model.dart';
import 'package:painter2/painter2.dart';
import 'package:provider/provider.dart';
import 'package:unicorndial/unicorndial.dart';

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

  Widget dialogImg(BuildContext context, NoteViewModel model) {
    return CupertinoAlertDialog(
      title: Text('Get image from ?'),
      actions: <Widget>[
        CupertinoDialogAction(
          child: Text('Camera'),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return CameraScreen();
            }));
          },
        ),
        CupertinoDialogAction(
            child: Text('Gallery'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context) {
                  return PickImage(model);
                }),
              );
            })
      ],
    );
  }

  Widget dialogSound(BuildContext context, NoteViewModel model) {
    return CupertinoAlertDialog(
        title: Text('Get sound from ?'),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text('Record'),
            onPressed: () {
//              Navigator.
////              popAndPushNamed(context, 'record');
//                  push(context,
//                      MaterialPageRoute(builder: (BuildContext context) {
//                return Record(model);
//              }));
            },
          ),
          CupertinoDialogAction(
              child: Text('Mp3'),
              onPressed: () {
//                Navigator.push(context,
//                    MaterialPageRoute(builder: (BuildContext context) {
//                  return ChooseFileAudio(model);
//                }));
              })
        ]);
  }

  List<UnicornButton> _getProfileMenu(NoteViewModel model) {
    List<UnicornButton> children = [];
    children.add(_profileOption(
        iconData: Icons.create,
        onPressed: () {
          final NoteItem noteItem = NoteItem("Text");
//          Provider.of<Notes>(context, listen: true).addNoteItem(noteItem);
          model.addNoteItem(noteItem);
        },
        hero: "txt"));
    children.add(_profileOption(
        iconData: Icons.camera_alt,
        onPressed: () {
//          final NoteItem noteItem = NoteItem("Image");
//          model.addNoteItem(noteItem);
          showDialog(context: context, child: dialogImg(context, model));
        },
        hero: "img"));
    children.add(_profileOption(
        iconData: Icons.audiotrack,
        onPressed: () {
          final NoteItem noteItem = NoteItem("Audio");
          model.addNoteItem(noteItem);
          showDialog(child: dialogSound(context, model), context: context);
        },
        hero: "sound"));

    return children;
  }

  Widget _profileOption({IconData iconData, Function onPressed, String hero}) {
    return UnicornButton(
        currentButton: FloatingActionButton(
      heroTag: hero,
      backgroundColor: Theme.of(context).backgroundColor,
      mini: true,
      child: Icon(iconData, color: Theme.of(context).iconTheme.color),
      onPressed: onPressed,
    ));
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

    return BaseView<NoteViewModel>(
        onModelReady: (noteViewModel) => noteViewModel.getListItems(),
        builder: (context, noteViewModel, child) => Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            resizeToAvoidBottomPadding: false,
            floatingActionButton: UnicornDialer(
              parentButtonBackground: Colors.blue,
              orientation: UnicornOrientation.VERTICAL,
              parentButton:
                  Icon(Icons.add, color: Theme.of(context).primaryColor),
              childButtons: _getProfileMenu(noteViewModel),
            ),
            appBar: AppBar(
                title: Text('Create new note',
                    style: TextStyle(color: Theme.of(context).iconTheme.color)),
                leading: BackButton(
                  color: Theme.of(context).iconTheme.color,
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
                                          elevation: 0.0,
                                          backgroundColor:
                                              Theme.of(context).backgroundColor,
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
                                                color: Theme.of(context)
                                                    .iconTheme
                                                    .color,
                                                fontWeight: Font.Regular),
                                      ),
                                      SizedBox(width: w * 2),
                                      Icon(Icons.edit,
                                          size: 20,
                                          color:
                                              Theme.of(context).iconTheme.color)
                                    ],
                                  ),
                                ))),
                        Expanded(
                            child: GestureDetector(
                          onTap: () {
                            note.setListNoteItems(noteViewModel.contents);
                            note.setTitle(noteViewModel.title);
                            note.setTag(noteViewModel.tags);

                            NoteDAO.insertNote(note);
                            print(note.contents);
                            print(note.contents.length);
                            //Print List Note
                            print("\n[List Note]\n");
//                            var notes = NoteDAO.getNoteByID(note.id);
//                            notes.then((value)=> print(value.toString()));
                            var listNotes = NoteDAO.getNotes();
                            listNotes.then((list) => list.forEach((note) => {
                                  print(note.toString()),
                                }));
                            print("\n[/List Note]\n");
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/', (Route<dynamic> route) => false);
                          },
                          child: Text(
                            "Save",
                            style: Theme.of(context).textTheme.title.copyWith(
                                color: Colors.blue, fontWeight: Font.Regular),
                          ),
                        ))
                      ]),
                  TagBarOfNote(noteViewModel, heroTag: "TagNote"),
                  (noteViewModel.contents.length != null)
                      ? Expanded(
                          child: Container(child: ListNoteItems(noteViewModel)))
                      : Text("")
                ])));
  }
}

class ListNoteItems extends StatelessWidget {
  final NoteViewModel model;
  ListNoteItems(this.model);
  ScrollController _controller = new ScrollController();
  @override
  Widget build(BuildContext context) {
//    Timer(Duration(milliseconds: 1000),
//        () => _controller.jumpTo(_controller.position.maxScrollExtent));
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
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: InkWell(
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)))),
                      maxLength: null,
                      maxLines: null,
                      controller: txtController,
                      style: TextStyle(
                          fontSize: 17,
                          fontStyle: FontStyle.normal,
                          color: Theme.of(context).iconTheme.color),
                      onSaved: (value) {
                        widget.item.setContent(txtController.text);
                        widget.item.setBgColor(note_color);
                        print(widget.item.content);
                      })
                ]))));
  }
}

class NoteItemWidget extends StatelessWidget {
  final NoteItem item;
  NoteItemWidget(NoteItem _item) : item = _item;
  Uint8List bytes;
  void enCodeImg() {
    final picker = ImagePicker();
    File imgFile = File(item.content);
    print(item.content);
    ImagePicker.pickImage(source: ImageSource.gallery);
    bytes = imgFile.readAsBytesSync();
  }

  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width / 100;
    double h = MediaQuery.of(context).size.height / 100;
    if (item.type == "Text") {
      return EditText(item);
    } else if (item.type == "Image") {
      enCodeImg();

      return Container(
          width: w * 100,
          height: w * 100,
          margin: EdgeInsets.fromLTRB(w * 2, h, w * 2, h),
          padding: EdgeInsets.fromLTRB(w, h, w, h),
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.white),
          child: Image.memory(bytes));
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
            Text(item.content,
                style: TextStyle(
                    fontSize: 17,
                    fontFamily: Font.Name,
                    fontWeight: Font.Regular,
                    color: Colors.black))
          ],
        ));
  }

  Widget fileAudio(BuildContext context) {
    double w = MediaQuery.of(context).size.width / 100;
    double h = MediaQuery.of(context).size.height / 100;
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
                style: TextStyle(
                    fontSize: 17,
                    fontFamily: Font.Name,
                    fontWeight: Font.Regular,
                    color: Colors.black))
          ],
        ));
  }
}
