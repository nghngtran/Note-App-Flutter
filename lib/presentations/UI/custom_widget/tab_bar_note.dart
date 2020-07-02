import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/application/constants.dart';
import 'package:note_app/presentations/UI/custom_widget/custom_type_tag.dart';
import 'package:note_app/utils/bus/tag_bus.dart';
import 'package:note_app/utils/dao/tag_dao.dart';
import 'package:note_app/utils/model/tag.dart';
import 'package:note_app/view_model/list_tag_view_model.dart';
import 'package:note_app/view_model/note_view_model.dart';


import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:provider/provider.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class CreateTagNote extends StatefulWidget {
  final NoteViewModel noteModel;
  final TagCreatedModel tagCreatedModel;
  CreateTagNote(NoteViewModel _model, TagCreatedModel _tagModel)
      : noteModel = _model,
        tagCreatedModel = _tagModel;
  CreateTagNoteState createState() => CreateTagNoteState();
}

class CreateTagNoteState extends State<CreateTagNote> {
  Tag tag = Tag();
  final TextEditingController controller = TextEditingController();

  List<Tag> tagCreated = List<Tag>();

  bool valid;
  Color tagColor;
  AutoCompleteTextField searchTextField;

  Widget build(BuildContext context) {
    //tagColor = Colors.green;
    return Container(
        width: MediaQuery.of(context).size.width / 100 * 80,
        height: MediaQuery.of(context).size.height / 100 * 20,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(
              color: Theme.of(context).dividerColor,
              width: 1),
          color: Theme.of(context).backgroundColor,
        ),
        padding:
            EdgeInsets.only(top: MediaQuery.of(context).size.height / 100 * 2),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: <
            Widget>[
          Text("Add tag",
              style: Theme.of(context).textTheme.title.copyWith(
                  fontWeight: Font.SemiBold,
                  color: Theme.of(context).iconTheme.color)),
          SizedBox(height: MediaQuery.of(context).size.height / 100 * 2),
          Expanded(
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <
                  Widget>[
            Wrap(children: <Widget>[DropDownButtonNote(tag, color: tagColor)]),
            SizedBox(width: MediaQuery.of(context).size.width / 100),
            Expanded(
              flex: 7,
              child: searchTextField = AutoCompleteTextField<Tag>(
                  controller: controller,
                  style: TextStyle(color: Theme.of(context).iconTheme.color),
                  decoration: InputDecoration(
                      suffixIcon: Container(
                        width: 85.0,
                        height: 60.0,
                      ),
                      contentPadding:
                          EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 20.0),
                      filled: true,
                      hintText: "Tag's title",
                      hintStyle:
                          TextStyle(color: Theme.of(context).iconTheme.color)),
                  submitOnSuggestionTap: true,
                  clearOnSubmit: false,
                  suggestions: widget.tagCreatedModel.getTagCreated(),
                  itemBuilder: (context, item) {
                    return Container(
                        color: Colors.transparent,
                        height: MediaQuery.of(context).size.height / 100 * 6,
                        padding: EdgeInsets.fromLTRB(15, 5, 0, 0),
                        child: Text(item.title,
                            style: TextStyle(
                                color: Theme.of(context).iconTheme.color,
                                fontSize: 16)));
                  },
                  key: null,
                  itemSubmitted: (item) {
                    for (var i in widget.noteModel.tags) {
                      if (item.title == i.title && item.color == i.color) {
                        Navigator.of(context).pop();
                        return;
                      }
                    }
                    setState(() {
//                      tag = item;
                      tagColor = item.color;
                      controller.text = item.title;
                      tag.setTitle(item.title);
                      tag.setColor(tagColor);
                      tag.setID(item.id);

                      widget.noteModel.addTag(tag);
                      Navigator.of(context).pop();
                    });
                  },
                  itemSorter: (a, b) {
                    return a.title.compareTo(b.title);
                  },
                  itemFilter: (item, query) {
                    return item.title
                        .toLowerCase()
                        .startsWith(query.toLowerCase());
                  }),
            ),
            SizedBox(width: MediaQuery.of(context).size.width / 100 * 2)
          ])),
          Expanded(
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <
                  Widget>[
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
                      side: BorderSide(color: Colors.transparent, width: 0.5)),
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
                  onPressed: () async {
                    if (tagColor != null) {
                      tag.setColor(tagColor);
                    }
                    tag.setTitle(controller.text);

                    for (var i in widget.tagCreatedModel
                        .getTagCreated()) //check if tag existed
                    {
                      if (i.title == tag.title) //tag existed
                      {
                        for (var j in widget.noteModel.tags) {
                          if (tag.title == j.title) {
                            //tag existed in note
                            Navigator.of(context).pop();
                            return;
                          }
                        }
                        //tag has yet to exist in note
                        tag.setColor(i.color);
                        widget.noteModel.addTag(tag);
                        Navigator.of(context).pop();
                        return;
                      }
                    }
                    //tag doesn't exist
                    widget.noteModel.addTag(tag);
                    TagBUS tagbus = new TagBUS();
                    var stt = await tagbus.addTag(tag);
                    if (stt) {
                      widget.tagCreatedModel.addToList(tag);
                    }
                    Navigator.of(context).pop();
                    print(widget.noteModel.tags.first);
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(5),
                      side: BorderSide(color: Colors.transparent, width: 0.5)),
                ))
          ]))
        ]));
  }
}

class DropDownButtonNote extends StatefulWidget {
  Tag tag;
  Color color = Colors.green;
  DropDownButtonNote(Tag _tag, {Color color})
      : tag = _tag,
        color = color;
  @override
  _DropDownButtonNoteState createState() => _DropDownButtonNoteState();
}

class _DropDownButtonNoteState extends State<DropDownButtonNote> {
  Color _value;
  void initState() {
    super.initState();
    if (widget.color == null) {
      _value = Colors.green;
    } else {
      _value = widget.color;
    }
    widget.tag.setColor(Colors.green);
  }

  DropdownButton dropdownBtn() => DropdownButton<Color>(
      elevation: 0,
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


class TagBarOfNote extends StatelessWidget {
  ScrollController horizontal;
  TagBarOfNote(this.model, {String heroTag});
//  List<Tag> listTags = List<Tag>();
  final NoteViewModel model;
  TagCreatedModel tagCreatedModel = TagCreatedModel();
  Widget build(BuildContext context) {
    tagCreatedModel.loadData();
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SizedBox(width: MediaQuery.of(context).size.width / 100 * 3),
          Container(
              color: Theme.of(context).backgroundColor,
              width: MediaQuery.of(context).size.width / 100 * 10,
              height: MediaQuery.of(context).size.width / 100 * 8,
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 100 * 2,
                  bottom: MediaQuery.of(context).size.height / 100),
              child: FloatingActionButton(
                elevation: 0.0,
                heroTag: "createTag",
//                backgroundColor: Theme.of(context).backgroundColor,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => Dialog(
                          elevation: 0.0,
                          backgroundColor: Theme.of(context).backgroundColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          child: Stack(children: <Widget>[
                            CreateTagNote(model, tagCreatedModel)
                          ])));
                },
                child: Icon(Icons.add,
                    size: 20, color: Theme.of(context).iconTheme.color),
              )),

          Expanded(
              child: Container(
                  width: MediaQuery.of(context).size.width / 100 * 85,
                  height: MediaQuery.of(context).size.height / 100 * 6,
                  child: ListView.builder(
                      controller: horizontal,
                      scrollDirection: Axis.horizontal,
                      itemCount: model.tags.length,
                      itemBuilder: (context, index) {
                        final item = model.tags[index];
                        return CustomTagNote(item, model);
                      })))
//              : Container()
        ]);
  }
}

class CustomTagNote extends StatelessWidget {
  Tag tag;
  final NoteViewModel model;
  CustomTagNote(Tag _tag, NoteViewModel _model)
      : tag = _tag,
        model = _model;
  Widget build(BuildContext context) {
    return GestureDetector(
        onLongPress: () {
          showDialog(
              context: context,
              builder: (BuildContext context) => CupertinoAlertDialog(
                    title: Text('Remove tag ?'),
                    actions: <Widget>[
                      CupertinoDialogAction(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      CupertinoDialogAction(
                        child: Text('Yes'),
                        onPressed: () {
                          model.removeTagOfNote(tag);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ));
        },
        child: Wrap(children: <Widget>[
          Container(
              margin: EdgeInsets.only(
                  left: 4 * MediaQuery.of(context).size.width / 100,
                  top: MediaQuery.of(context).size.height / 100),
//            width: MediaQuery.of(context).size.width / 100 * 25,
              height: MediaQuery.of(context).size.height / 100 * 5,
              padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width / 100 * 2,
                  0,
                  MediaQuery.of(context).size.width / 100 * 2,
                  0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: tag.color),
              child: Center(
                  child: Text(
                "#" + tag.title,
                style: TextStyle(
                    fontSize: 15,
                    fontFamily: Font.Name,
                    fontWeight: Font.Regular,
                    color: Colors.white),
              )))
        ]));
  }
}
