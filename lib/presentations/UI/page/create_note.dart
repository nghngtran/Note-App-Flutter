import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/application/constants.dart';
import 'package:note_app/presentations/UI/custom_widget/FAB.dart';
import 'package:note_app/presentations/UI/custom_widget/choose_title.dart';
import 'package:note_app/presentations/UI/custom_widget/custom_text_style.dart';
import 'package:note_app/presentations/UI/page/create_tag.dart';
import 'package:note_app/presentations/UI/page/customPaint.dart';
import 'package:note_app/presentations/UI/page/home_screen.dart';
import 'package:note_app/presentations/UI/page/image_pick.dart';
import 'package:note_app/utils/database/dao/note_dao.dart';
import 'package:note_app/utils/database/model/note.dart';
import 'package:note_app/utils/database/model/noteItem.dart';
import 'package:provider/provider.dart';

class CreateNote extends StatefulWidget {
  CreateNoteState createState() => CreateNoteState();
}

class CreateNoteState extends State<CreateNote> {

  ScrollController mainController = ScrollController();
  Notes note ;
  void initState() {
    super.initState();

  }
  @override
 void dispose(){

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
    note= new Notes();
    double w = MediaQuery.of(context).size.width / 100;
    double h = MediaQuery.of(context).size.height / 100;
    return
        Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomPadding: false,
            floatingActionButton: FancyFab(note),
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
                                          child: ChooseTitle()));
                                },
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(width: w * 4),
                                      Text(
                                        "New untitled note",
                                        style: Theme.of(context)
                                            .textTheme
                                            .title
                                            .copyWith(
                                                color: Colors.black,
                                                fontWeight: Font.Light),
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
Navigator.of(context).pop();
                          },
                          child: Text(
                            "Save",
                            style: Theme.of(context).textTheme.title.copyWith(
                                color: Colors.blue, fontWeight: Font.SemiBold),
                          ),
                        ))
                      ]),
                  Container(
                      width: w * 30,
                      height: h * 5,
                      margin: EdgeInsets.only(
                          left: 4 * MediaQuery.of(context).size.width / 100,
                          top: MediaQuery.of(context).size.height / 100 * 2,
                          bottom: h),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                          color: Colors.white),
                      child: GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) => Dialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    child: CreateTag()));
                          },
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(width: w * 2),
                                Icon(
                                  Icons.local_offer,
                                  color: Colors.black.withOpacity(0.4),
                                ),
                                SizedBox(width: w),
                                Text(
                                  "Add tag",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline7
                                      .copyWith(
                                          color: Colors.black.withOpacity(0.4),
                                          fontWeight: Font.Bold),
                                )
                              ]))),
                  (note.contents != null)
                      ? Expanded(child: Container(child:
                          Consumer<Notes>(//                    <--- Consumer
                              builder: (context, note, child) {
                          print(note.contents.length);
                          return Stack(
                              children: <Widget>[ListNoteItems((note))]);
                        })))
                      : Text("")
                ]));
  }
}

class ListNoteItems extends StatelessWidget {
  Notes note;

  ListNoteItems(Notes _note) : note = _note;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: getChildrenNotes(),
    );
  }

  List<Widget> getChildrenNotes() {
    return note.contents.map((todo) => NoteItemWidget(todo)).toList();
  }
}


class EditText extends StatefulWidget {
  NoteItem item;

  EditText(NoteItem _item) : item = _item;

  EditTextState createState() => EditTextState();
}

class EditTextState extends State<EditText> {
  TextEditingController txtController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width / 100;
    double h = MediaQuery.of(context).size.height / 100;
    widget.item.setContent(txtController.text);
    return Padding(
        padding: EdgeInsets.fromLTRB(w * 4, h/2, w * 2, h),
        child: TextFormField(
            autocorrect: false,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(w, h, w, h),
                fillColor: Colors.greenAccent,
                filled: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)))),
            maxLength: 1000,
            maxLines: 10,
            controller: txtController,
            style: TextStyle(
                fontSize: 17, fontStyle: FontStyle.normal, color: Colors.black),
            onSaved: (value) {
              widget.item.setContent(txtController.text);
              print(widget.item.content);
            }));
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
              Navigator.of(context).pop();
            },
          ),
          CupertinoDialogAction(
              child: Text('Gallery'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context) {
                      return PickImage();
                    }));
              }
          ),
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