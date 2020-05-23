import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/presentations/UI/custom_widget/custom_text_style.dart';
import 'package:note_app/presentations/UI/page/create_tag.dart';
import 'package:note_app/utils/database/dao/tag_dao.dart';
import 'package:note_app/utils/database/model/tag.dart';
import 'package:provider/provider.dart';

class CustomTag extends StatelessWidget {
  Tag tag;
  CustomTag(Tag _tag) : tag = _tag;
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {},
        child: Container(
            margin: EdgeInsets.only(
                left: 4 * MediaQuery.of(context).size.width / 100,
                top: MediaQuery.of(context).size.height / 100),
            width: MediaQuery.of(context).size.width / 100 * 25,
            height: MediaQuery.of(context).size.height / 100 * 10,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Colors.lightGreen),
            child: Center(
                child: Text(
              "#" + Provider.of<Tag>(context, listen: true).title,
              style: Theme.of(context)
                  .textTheme
                  .headline7
                  .copyWith(color: Colors.white),
            ))));
  }
}

class TagBar extends StatelessWidget {
  final ScrollController horizontal = ScrollController();
  TagBar(horizontal);

  List<Tag> listTags = List<Tag>();
  var _listTags = TagDAO.getTags();

  Widget build(BuildContext context) {
    _listTags.then((list) =>
        list.forEach((tag) => {list.forEach((tag) => listTags.add(tag))}));
    listTags.forEach((tag) => print(tag.toString()));
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SizedBox(width: MediaQuery.of(context).size.width / 100 * 3),
          Container(
              width: MediaQuery.of(context).size.width / 100 * 10,
              height: MediaQuery.of(context).size.width / 100 * 9,
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 100 * 2,
                  bottom: MediaQuery.of(context).size.height / 100),
              child: FloatingActionButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => Dialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            child: CreateTag()));
                  },
                  child: Icon(Icons.add, size: 20, color: Colors.black),
                  backgroundColor: Colors.white)),
//      SizedBox (width: MediaQuery.of(context).size.width / 100 * 2),
          (listTags.length != 0)
              ? Expanded(
                  child: Container(
                      width: MediaQuery.of(context).size.width / 100 * 85,
                      height: MediaQuery.of(context).size.height / 100 * 6,
                      child: ListView.builder(
                          controller: horizontal,
                          scrollDirection: Axis.horizontal,
                          itemCount: listTags.length,
                          itemBuilder: (context, index) {
                            final item = listTags[index];

                            return CustomTag(item);
                          })))
              : Text("")
        ]);
  }
}
