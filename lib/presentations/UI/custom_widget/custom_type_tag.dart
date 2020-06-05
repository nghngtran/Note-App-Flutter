import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/application/constants.dart';

import 'package:note_app/presentations/UI/page/create_tag.dart';
import 'package:note_app/utils/dao/tag_dao.dart';
import 'package:note_app/utils/model/tag.dart';
import 'package:note_app/view_model/list_tag_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:note_app/presentations/UI/custom_widget/custom_text_style.dart';

class CustomTag extends StatelessWidget {
  Tag tag;
  CustomTag(Tag _tag) : tag = _tag;
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {},
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
                    fontSize: 17,
                    fontFamily: Font.Name,
                    fontWeight: Font.Regular,
                    color: Colors.white),
              )))
        ]));
  }
}

class TagBar extends StatelessWidget {
  ScrollController horizontal;
  final List<Tag> listCreatedTag;
  TagBar(ScrollController _scroll, List<Tag> _listCreatedTag, this.model)
      : horizontal = _scroll,
        listCreatedTag = _listCreatedTag;
//  List<Tag> listTags = List<Tag>();
  final TagCreatedModel model;

  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SizedBox(width: MediaQuery.of(context).size.width / 100 * 3),
          Container(
              color: Theme.of(context).backgroundColor,
              width: MediaQuery.of(context).size.width / 100 * 10,
              height: MediaQuery.of(context).size.width / 100 * 9,
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 100 * 2,
                  bottom: MediaQuery.of(context).size.height / 100),
              child: FloatingActionButton(
                elevation: 0.0,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => Dialog(
                          elevation: 0.0,
                          backgroundColor: Theme.of(context).backgroundColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          child: CreateTag(model)));
                },
                child: Icon(Icons.add,
                    size: 20, color: Theme.of(context).iconTheme.color),
              )),
//      SizedBox (width: MediaQuery.of(context).size.width / 100 * 2),
          listCreatedTag.length > 0
              ? Expanded(
                  child: Container(
                      width: MediaQuery.of(context).size.width / 100 * 85,
                      height: MediaQuery.of(context).size.height / 100 * 6,
                      child: ListView.builder(
                          controller: horizontal,
                          scrollDirection: Axis.horizontal,
                          itemCount: listCreatedTag.length,
                          itemBuilder: (context, index) {
                            final item = listCreatedTag[index];
                            return CustomTag(item);
                          })))
              : Container()
        ]);
  }
}
