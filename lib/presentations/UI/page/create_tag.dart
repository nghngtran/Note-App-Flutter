import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/application/constants.dart';
import 'package:note_app/utils/database/dao/note_dao.dart';
import 'package:note_app/utils/database/dao/tag_dao.dart';
import 'package:note_app/utils/database/database.dart';
import 'package:note_app/utils/database/model/note.dart';
import 'package:note_app/utils/database/model/noteItem.dart';
import 'package:note_app/utils/database/model/tag.dart';
import 'package:provider/provider.dart';

class CreateTag extends StatefulWidget {
  CreateTagState createState() => CreateTagState();
}

class CreateTagState extends State<CreateTag> {
  final textController = TextEditingController();

  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width / 100 * 80,
        height: MediaQuery.of(context).size.height / 100 * 25,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: ColorTheme.colorBar,
        ),
        padding:
            EdgeInsets.only(top: MediaQuery.of(context).size.height / 100 * 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text("Create new tag",
                style: Theme.of(context)
                    .textTheme
                    .title
                    .copyWith(fontWeight: Font.SemiBold)),
            SizedBox(height: MediaQuery.of(context).size.height / 100 * 2),
            Expanded(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
//              SizedBox(width: MediaQuery.of(context).size.width / 100 * 5),
                  Container(
                      width: MediaQuery.of(context).size.width / 100 * 30,
                      height: MediaQuery.of(context).size.height * 15,
                      child: DropDownButton()),
                  SizedBox(width: MediaQuery.of(context).size.width / 100),
                  Expanded(
                      flex: 5,
                      child: TextField(
                        controller: textController,
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 18),
                        decoration: InputDecoration(
                            alignLabelWithHint: true,
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                    color: Colors.black38, width: 1)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide:
                                    BorderSide(color: Colors.black, width: 1)),
                            hintText: "Enter tag's name",
                            contentPadding: EdgeInsets.fromLTRB(5, 15, 0, 15),
                            hintStyle:
                                TextStyle(color: Colors.black, fontSize: 16)),
                      )),
                  SizedBox(width: MediaQuery.of(context).size.width / 100 * 2),
                ])),
            Expanded(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
//                SizedBox(width: MediaQuery.of(context).size.width / 100 * 10),
                  Expanded(
                      flex: 1,
                      child: FlatButton(
                        color: Colors.white,
                        textColor: Colors.black,
                        child: Text("Cancel",
                            style: Theme.of(context).textTheme.subhead),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5),
                            side: BorderSide(color: Colors.black, width: 0.5)),
                      )),
                  Expanded(
                      flex: 1,
                      child: FlatButton(
                        color: Colors.white,
                        textColor: Colors.black,
                        child: Text("Save",
                            style: Theme.of(context).textTheme.subhead),
                        onPressed: () {
//                          Provider.of<Tag>(context, listen: false)
//                              .setTitle(textController.text);
                          Tag _tag = Tag.withTitle(textController.text, "123");

                          TagDAO.insertTag(_tag);
                          print(_tag);

//                          Navigator.of(context).popAndPushNamed('/');
                          // Future<Notes> notedetail;
                          //                            var listNotes = NoteDAO.getNotes();
                          //                            listNotes.then((list) => list.forEach((note) => {
                          //                                  print(note.toString()),
                          //                                  notedetail = NoteDAO.getNoteByID(note.id),
                          //                                  notedetail.then((noteD) => {
                          //                                        noteD.tags.forEach((tag) =>
                          //                                            print("\t" + tag.toString())),
                          //                                        noteD.contents.forEach((noteItem) =>
                          //                                            print("\t" + noteItem.toString()))
                          //                                      })
                          //                                }));
//                          Future<Tag> tag;

                          Navigator.of(context).pop();
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5),
                            side: BorderSide(color: Colors.black, width: 0.5)),
                      ))
                ])),
          ],
        ));
  }
}

class DropDownButton extends StatefulWidget {
  @override
  _DropDownButtonState createState() => _DropDownButtonState();
}

class _DropDownButtonState extends State<DropDownButton> {
  var _value = Colors.green.toString();

  DropdownButton dropdownBtn() => DropdownButton<String>(
          items: [
            DropdownMenuItem(
                value: Colors.green.toString(),
                child: Icon(Icons.local_offer, color: Colors.green, size: 18)),
            DropdownMenuItem(
                value: ColorTheme.blue.toString(),
                child: Icon(Icons.local_offer, color: Colors.blue, size: 18)),
            DropdownMenuItem(
                value: Colors.purple.toString(),
                child: Icon(Icons.local_offer, color: Colors.purple, size: 18)),
            DropdownMenuItem(
                value: Colors.pink.toString(),
                child: Icon(Icons.local_offer, color: Colors.pink, size: 18)),
            DropdownMenuItem(
                value: Colors.yellow.toString(),
                child: Icon(Icons.local_offer, color: Colors.yellow, size: 18)),
          ],
          onChanged: (value) {
            setState(() {
              _value = value;
//              Provider.of<Tag>(context, listen: true).setColor(value);
            });
          },
          value: _value,
          hint: Text("Pick color"));

  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
        child: ButtonTheme(alignedDropdown: true, child: dropdownBtn()));
  }
}
