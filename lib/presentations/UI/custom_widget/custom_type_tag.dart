import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/application/constants.dart';
import 'package:note_app/presentations/UI/page/base_view.dart';

import 'package:note_app/presentations/UI/page/create_tag.dart';
import 'package:note_app/utils/bus/tag_bus.dart';
import 'package:note_app/utils/dao/tag_dao.dart';
import 'package:note_app/utils/model/tag.dart';
import 'package:note_app/view_model/list_tag_view_model.dart';

//class CustomTag extends StatefulWidget {
//  Tag tag;
//
//  final ValueChanged<String> parentAction;
//  final ValueChanged<String> parentAction1;
//
//  CustomTag(
//      Tag _tag, ValueChanged<String> _parent, ValueChanged<String> _parent1)
//      : tag = _tag,
//        parentAction = _parent,
//        parentAction1 = _parent1;
//  CustomTagState createState() => CustomTagState();
//}
//
//class CustomTag extends StatelessWidget {
////  Tag tag;
//  Tag tag;
//
//  final ValueChanged<String> parentAction;
//  final ValueChanged<String> parentAction1;
//
//  CustomTag(
//      Tag _tag, ValueChanged<String> _parent, ValueChanged<String> _parent1)
//      : tag = _tag,
//        parentAction = _parent,
//        parentAction1 = _parent1;
////  CustomTagState createState() => CustomTagState();
//
//  Widget build(BuildContext context) {
//    return GestureDetector(
//        onTap: () {
//          parentAction(tag.id);
////          setState(() {
////            isChoosed = !isChoosed;
////          });
//        },
//        onLongPress: () {
//          showDialog(
//              context: context,
//              builder: (BuildContext context) => CupertinoAlertDialog(
//                    title: Text('Do you want to remove this tag ?'),
//                    actions: <Widget>[
//                      CupertinoDialogAction(
//                        child: Text('Cancel'),
//                        onPressed: () {
//                          Navigator.of(context).pop();
//                        },
//                      ),
//                      CupertinoDialogAction(
//                        child: Text('Yes'),
//                        onPressed: () {
//                          TagBUS tagbus = new TagBUS();
//                          tagbus.deleteTagById(tag.id);
//                          parentAction1("RELOAD!");
//                          Navigator.of(context).pop();
//                        },
//                      ),
//                    ],
//                  ));
////
//        },
//        child: isChoosed
//            ? Wrap(children: <Widget>[
//                Container(
//                    margin: EdgeInsets.only(
//                        left: 4 * MediaQuery.of(context).size.width / 100,
//                        top: MediaQuery.of(context).size.height / 100),
////            width: MediaQuery.of(context).size.width / 100 * 25,2
//                    height: MediaQuery.of(context).size.height / 100 * 5,
//                    padding: EdgeInsets.fromLTRB(
//                        MediaQuery.of(context).size.width / 100 * 2,
//                        0,
//                        MediaQuery.of(context).size.width / 100 * 2,
//                        0),
//                    decoration: BoxDecoration(
//                      borderRadius: BorderRadius.all(Radius.circular(15)),
//                      color: tag.color,
//                      border: Border.all(color: Colors.blueAccent, width: 3),
//                      boxShadow: [
//                        BoxShadow(
//                          color: Colors.blueAccent.withOpacity(0.5),
//                          spreadRadius: 4,
//                          blurRadius: 7,
//                          offset: Offset(0, 1.5), // changes position of shadow
//                        ),
//                      ],
//                    ),
//                    child: Center(
//                        child: Text(
//                      "#" + tag.title,
//                      style: TextStyle(
//                          fontSize: 17,
//                          fontFamily: Font.Name,
//                          fontWeight: Font.Regular,
//                          color: Colors.white),
//                    )))
//              ])
//            : Wrap(children: <Widget>[
//                Container(
//                    margin: EdgeInsets.only(
//                        left: 4 * MediaQuery.of(context).size.width / 100,
//                        top: MediaQuery.of(context).size.height / 100),
////            width: MediaQuery.of(context).size.width / 100 * 25,
//                    height: MediaQuery.of(context).size.height / 100 * 5,
//                    padding: EdgeInsets.fromLTRB(
//                        MediaQuery.of(context).size.width / 100 * 2,
//                        0,
//                        MediaQuery.of(context).size.width / 100 * 2,
//                        0),
//                    decoration: BoxDecoration(
//                      borderRadius: BorderRadius.all(Radius.circular(15)),
//                      color: widget.tag.color,
//                    ),
//                    child: Center(
//                        child: Text(
//                      "#" + widget.tag.title,
//                      style: TextStyle(
//                          fontSize: 17,
//                          fontFamily: Font.Name,
//                          fontWeight: Font.Regular,
//                          color: Colors.white),
//                    )))
//              ]));
//  }
//}
class TagBar extends StatefulWidget {
  ScrollController horizontal;
  TagBar(ScrollController _scroll, TagCreatedModel _model,
      ValueChanged<String> _parent, ValueChanged<String> _parent1)
      : horizontal = _scroll,
        model = _model,
        parentAction = _parent,
        parentAction1 = _parent1;
  TagCreatedModel model;
  final ValueChanged<String> parentAction; ////callback
  final ValueChanged<String> parentAction1; ////callback
  TagBarState createState() => TagBarState();
}

class TagBarState extends State<TagBar> {
  Tag isSelected = Tag();
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    //widget.model.loadData();
    return FutureBuilder(
      future: widget.model.loadData(),
      builder: (context, state) {
        if (state.connectionState == ConnectionState.done) {
          return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(width: MediaQuery
                .of(context)
                .size
                .width / 100 * 3),
            Container(
                color: Theme
                    .of(context)
                    .backgroundColor,
                width: MediaQuery
                    .of(context)
                    .size
                    .width / 100 * 9,
                height: MediaQuery
                    .of(context)
                    .size
                    .width / 100 * 9,
                margin: EdgeInsets.only(
                    top: MediaQuery
                        .of(context)
                        .size
                        .height / 100 * 2,
                    bottom: MediaQuery
                        .of(context)
                        .size
                        .height / 100),
                child: FloatingActionButton(
                  elevation: 0.0,
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            Dialog(
                                elevation: 0.0,
                                backgroundColor: Theme
                                    .of(context)
                                    .backgroundColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                child: CreateTag(widget.model)));
                  },
                  child: Icon(Icons.add,
                      size: 20, color: Theme
                          .of(context)
                          .iconTheme
                          .color),
                )),
            Expanded(
                child: Container(
                    padding: EdgeInsets.fromLTRB(
                        0, MediaQuery
                        .of(context)
                        .size
                        .height / 100, 0, 0),
                    width: MediaQuery
                        .of(context)
                        .size
                        .width / 100 * 85,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height / 100 * 8,
                    child: ListView.builder(
                        controller: widget.horizontal,
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.model
                            .getTagCreated()
                            .length,
                        itemBuilder: (context, index) {
                          final item = widget.model.getTagCreated()[index];
                          if (isSelected == item) {
                            return Wrap(children: <Widget>[
                              Container(
                                  margin: EdgeInsets.only(
                                      left: 4 *
                                          MediaQuery
                                              .of(context)
                                              .size
                                              .width /
                                          100,
                                      top: MediaQuery
                                          .of(context)
                                          .size
                                          .height /
                                          100),
                                  height: MediaQuery
                                      .of(context)
                                      .size
                                      .height /
                                      100 *
                                      5,
                                  padding: EdgeInsets.fromLTRB(
                                      MediaQuery
                                          .of(context)
                                          .size
                                          .width / 100 * 2,
                                      0,
                                      MediaQuery
                                          .of(context)
                                          .size
                                          .width / 100 * 2,
                                      0),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                    color: item.color,
                                    border: Border.all(
                                        color: Colors.blueAccent, width: 3),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blueAccent.withOpacity(
                                            0.5),
                                        spreadRadius: 4,
                                        blurRadius: 7,
                                        offset: Offset(
                                            0,
                                            1.5), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: GestureDetector(
                                      onTap: () {
                                        widget.parentAction(item.id);
                                      },
                                      onLongPress: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                CupertinoAlertDialog(
                                                  title: Text(
                                                      'Do you want to remove this tag ?'),
                                                  actions: <Widget>[
                                                    CupertinoDialogAction(
                                                      child: Text('Cancel'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                    CupertinoDialogAction(
                                                      child: Text('Yes'),
                                                      onPressed: () {
                                                        TagBUS tagbus =
                                                        new TagBUS();
                                                        tagbus.deleteTagById(
                                                            item.id);
                                                        widget.parentAction1(
                                                            "RELOAD!");
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                ));
                                      },
                                      child: Center(
                                          child: Text(
                                            "#" + item.title,
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontFamily: Font.Name,
                                                fontWeight: Font.Regular,
                                                color: Colors.white),
                                          ))))
                            ]);
                          }
                          return GestureDetector(
                              onTap: () {
                                setState(() {
                                  isSelected = item;
                                });
                                widget.parentAction(item.id);
                              },
                              onLongPress: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        CupertinoAlertDialog(
                                          title: Text(
                                              'Do you want to remove this tag ?'),
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
                                                TagBUS tagbus = new TagBUS();
                                                tagbus.deleteTagById(item.id);
                                                widget.parentAction1("RELOAD!");
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        ));
                              },
                              child: Wrap(children: <Widget>[
                                Container(
                                    margin: EdgeInsets.only(
                                        left: 4 *
                                            MediaQuery
                                                .of(context)
                                                .size
                                                .width /
                                            100,
                                        top: MediaQuery
                                            .of(context)
                                            .size
                                            .height /
                                            100),
                                    height: MediaQuery
                                        .of(context)
                                        .size
                                        .height /
                                        100 *
                                        5,
                                    padding: EdgeInsets.fromLTRB(
                                        MediaQuery
                                            .of(context)
                                            .size
                                            .width /
                                            100 *
                                            2,
                                        0,
                                        MediaQuery
                                            .of(context)
                                            .size
                                            .width /
                                            100 *
                                            2,
                                        0),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                      color: item.color,
                                    ),
                                    child: Center(
                                        child: Text(
                                          "#" + item.title,
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontFamily: Font.Name,
                                              fontWeight: Font.Regular,
                                              color: Colors.white),
                                        )))
                              ]));
                        })))
          ]);
        }
        return Row();
    });
  }
}
