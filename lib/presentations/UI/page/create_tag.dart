import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/application/app_localizations.dart';
import 'package:note_app/application/constants.dart';
import 'package:note_app/utils/database/dao/note_dao.dart';
import 'package:note_app/utils/database/dao/tag_dao.dart';
import 'package:note_app/utils/database/database.dart';
import 'package:note_app/utils/database/model/note.dart';
import 'package:note_app/utils/database/model/noteItem.dart';
import 'package:note_app/utils/database/model/tag.dart';

//class Tags {
//  String colorTag;
//  String nameTag;
//
//  Tags({@required String name, @required String color})
//      : nameTag = name,
//        colorTag = color;
//}

class CreateTag extends StatelessWidget {
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
          children: <Widget>[
            Text(AppLocalizations.of(context)
                .translate('create_tag')
                ,
                style: Theme.of(context)
                    .textTheme
                    .title
                    .copyWith(fontWeight: Font.SemiBold)),
            SizedBox(height: MediaQuery.of(context).size.height / 100 * 2),
            Row(children: <Widget>[
              SizedBox(width: MediaQuery.of(context).size.width / 100 * 5),
              Container(
                  width: MediaQuery.of(context).size.width / 100 * 12,
                  child: DropDownButton()),
              SizedBox(width: MediaQuery.of(context).size.width / 100 * 2),
              Expanded(
                  flex: 7,
                  child: TextField(
                    controller: textController,
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                        alignLabelWithHint: true,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide:
                                BorderSide(color: Colors.black38, width: 1)),
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
            ]),
            Expanded(
                child: Row(
              children: <Widget>[
                SizedBox(width: MediaQuery.of(context).size.width / 100 * 10),
                Expanded(
                    flex: 1,
                    child: FlatButton(
                      color: Colors.redAccent,
                      textColor: Colors.black,
                      child: Text(AppLocalizations.of(context)
                          .translate('cancel')
                          ,
                          style: Theme.of(context).textTheme.subhead),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(5),
                          side: BorderSide(color: Colors.red)),
                    )),
                SizedBox(width: MediaQuery.of(context).size.width / 100 * 5),
                Expanded(
                    flex: 1,
                    child: FlatButton(
                      color: Colors.blue,
                      textColor: Colors.black,
                      child: Text(AppLocalizations.of(context)
                          .translate('save')
                          ,
                          style: Theme.of(context).textTheme.subhead),
                      onPressed: () {
//                  Tag _tag = Tag(name: textController.text,color: Colors.purple.toString());

//                        Tag _other = new Tag();
//                        TagDAO.insertTag(_other);
//
//                        NoteItem textItem = new NoteItem("TEXT");
//                        textItem.setContent("Day la Text Item");
//
//                        Notes simpleNote = new Notes.withTag(_other);
//                        simpleNote.addNoteItem(textItem);
//                        NoteDAO.insertNote(simpleNote);
//
//                        NoteItem textItem1 = new NoteItem("TEXT");
//                        textItem1.setContent("Day la Text Item 1");
//
//                        Notes simpleNote1 = new Notes.withTag(_other);
//                        simpleNote1.addNoteItem(textItem1);
//                        NoteDAO.insertNote(simpleNote1);


                        Future<Notes> notedetail;
                        var listNotes = NoteDAO.getNotes();
                        listNotes.then((list) => list.forEach((note) => {
                              print(note.toString()),
                              notedetail = NoteDAO.getNoteByID(note.id),
                              notedetail.then((noteD) => {
                                    noteD.tags.forEach(
                                        (tag) => print("\t"+tag.toString())),
                                    noteD.contents.forEach((noteItem) =>
                                        print("\t"+noteItem.toString()))

                                  })
                            }));
                        //print(_tag1);
                        Navigator.of(context).pop();
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(5),
                          side: BorderSide(color: Colors.blue)),
                    )),
                SizedBox(width: MediaQuery.of(context).size.width / 100 * 10),
              ],
            )),
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
              child: Icon(Icons.local_offer, color: Colors.green, size: 22)),
          DropdownMenuItem(
              value: ColorTheme.blue.toString(),
              child: Icon(Icons.local_offer, color: Colors.blue, size: 22)),
          DropdownMenuItem(
              value: Colors.purple.toString(),
              child: Icon(Icons.local_offer, color: Colors.purple, size: 22)),
          DropdownMenuItem(
              value: Colors.pink.toString(),
              child: Icon(Icons.local_offer, color: Colors.pink, size: 22)),
          DropdownMenuItem(
              value: Colors.yellow.toString(),
              child: Icon(Icons.local_offer, color: Colors.yellow, size: 22)),
        ],
        onChanged: (value) {
          setState(() {
            _value = value;
          });
        },
        value: _value,
      );

  Widget build(BuildContext context) {
    return dropdownBtn();
  }
}
