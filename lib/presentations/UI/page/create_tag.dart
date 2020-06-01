import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/application/constants.dart';
import 'package:note_app/utils/database/dao/note_dao.dart';
import 'package:note_app/utils/database/dao/tag_dao.dart';
import 'package:note_app/utils/database/dao/thumbnail_dao.dart';
import 'package:note_app/utils/database/database.dart';
import 'package:note_app/utils/database/model/note.dart';
import 'package:note_app/utils/database/model/noteItem.dart';
import 'package:note_app/utils/database/model/tag.dart';
import 'package:note_app/utils/database/model/thumbnailNote.dart';
import 'package:note_app/view_model/list_tag_viewmodel.dart';
import 'package:note_app/presentations/UI/custom_widget/custom_text_style.dart';

class CreateTag extends StatelessWidget {
  Tag tag = new Tag();

  final textController = TextEditingController();
  final TagCreatedModel tagCreatedModel;
  CreateTag(this.tagCreatedModel);
  Widget build(BuildContext context) {
    tag.setColor(Colors.green);
    return Container(
        width: MediaQuery.of(context).size.width / 100 * 80,
        height: MediaQuery.of(context).size.height / 100 * 20,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Theme.of(context).backgroundColor,
        ),
        padding:
            EdgeInsets.only(top: MediaQuery.of(context).size.height / 100 * 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text("Create new tag",
                style: Theme.of(context).textTheme.title.copyWith(
                    fontWeight: Font.SemiBold,
                    color: Theme.of(context).iconTheme.color)),
            SizedBox(height: MediaQuery.of(context).size.height / 100 * 2),
            Expanded(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                  Wrap(children: <Widget>[DropDownButton(tag)]),
                  SizedBox(width: MediaQuery.of(context).size.width / 100),
                  Expanded(
                      flex: 7,
                      child: TextField(
                        controller: textController,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).iconTheme.color),
                        decoration: InputDecoration(
                            alignLabelWithHint: true,
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                    color: Colors.black38, width: 1)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                    color: Theme.of(context).iconTheme.color,
                                    width: 1)),
                            hintText: "Enter tag's name",
                            contentPadding: EdgeInsets.fromLTRB(5, 15, 0, 15),
                            hintStyle: TextStyle(
                                color: Theme.of(context).iconTheme.color,
                                fontSize: 13)),
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
                        color: Colors.transparent,
                        textColor: Theme.of(context).iconTheme.color,
                        child: Text("Cancel",
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: Font.Name,
                              fontWeight: Font.Regular,
                            )),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5),
                            side: BorderSide(
                                color: Colors.transparent, width: 0.5)),
                      )),
                  Expanded(
                      flex: 1,
                      child: FlatButton(
                        color: Colors.transparent,
                        textColor: Theme.of(context).iconTheme.color,
                        child: Text("Save",
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: Font.Name,
                                fontWeight: Font.Regular,
                                color: Colors.blue)),
                        onPressed: () {
//                          Provider.of<Tag>(context, listen: false)
//                              .setTitle(textController.text);
                          tag.setTitle(textController.text);
//                          Provider.of<Tag>(context, listen: false).setColor()
//                              .setTitle(textController.text);
//                          Future<List<ThumbnailNote>> lists = ThumbnailNoteDAO.getThumbnails();
//                          print("Testtttttttttttttttttt");
//                          //Print Thumbnail test
//                          lists.then((value) => {
//                            value.forEach((f)=>{
//                              print(f.toString())
//                            })
//                          });
//                          print("Finish Testtttt");
                          TagDAO.insertTag(tag);
                          //print(tag);
                          var _listTags = TagDAO.getTags();
                          List<Tag> listTags = List<Tag>();
                          _listTags.then((list) =>
                              list.forEach((tag) => listTags.add(tag)));
                          listTags.forEach((listT) => listT.toString());
//                          Provider.of<TagCreated>(context, listen: true)
//                              .addTag(tag);
                          tagCreatedModel.addToList(tag);
                          Navigator.of(context).pop();
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5),
                            side: BorderSide(
                                color: Colors.transparent, width: 0.5)),
                      ))
                ])),
          ],
        ));
  }
}

class DropDownButton extends StatefulWidget {
  Tag tag;
  DropDownButton(Tag _tag) : tag = _tag;
  @override
  _DropDownButtonState createState() => _DropDownButtonState();
}

class _DropDownButtonState extends State<DropDownButton> {
  var _value = Colors.green;

  DropdownButton dropdownBtn() => DropdownButton<Color>(
          items: [
            DropdownMenuItem(
                value: Colors.green,
                child: Icon(Icons.local_offer, color: Colors.green, size: 18)),
            DropdownMenuItem(
                value: Colors.blue,
                child: Icon(Icons.local_offer, color: Colors.blue, size: 18)),
            DropdownMenuItem(
                value: Colors.purple,
                child: Icon(Icons.local_offer, color: Colors.purple, size: 18)),
            DropdownMenuItem(
                value: Colors.pink,
                child: Icon(Icons.local_offer, color: Colors.pink, size: 18)),
            DropdownMenuItem(
                value: Colors.yellow,
                child: Icon(Icons.local_offer, color: Colors.yellow, size: 18)),
          ],
          onChanged: (value) {
            setState(() {
              _value = value;
              print(_value.toString());
//              Provider.of<Tag>(context, listen: true).setColor(value);
              widget.tag.setColor(_value);
            });
          },
          value: _value,
          hint: Text("Pick color"));

  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
        child: ButtonTheme(alignedDropdown: true, child: dropdownBtn()));
  }
}
