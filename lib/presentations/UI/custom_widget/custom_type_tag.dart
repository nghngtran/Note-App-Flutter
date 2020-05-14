import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/data/repository.dart';
import 'package:note_app/presentations/UI/custom_widget/custom_text_style.dart';
import 'package:note_app/presentations/UI/page/create_tag.dart';
import 'package:shared_preferences/shared_preferences.dart';



class CustomTag extends StatelessWidget {
  SharePrefTag prefTag = SharePrefTag();
//
//  String colorTag;
//  String nameTag;
//  CustomTag({@required String name, @required String color}) : nameTag = name,
//        colorTag = color;
  Widget build(BuildContext context) {

    return GestureDetector(onTap:(){},child: Container(
        margin: EdgeInsets.only(left : 4 * MediaQuery.of(context).size.width / 100, top:MediaQuery.of(context).size.height / 100),
        width: MediaQuery.of(context).size.width / 100 * 25,
        height: MediaQuery.of(context).size.height / 100 * 10,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: Colors.lightGreen),
        child: Center(child:Text("#" +
//          nameTag
            prefTag.read('name'),
          style: Theme.of(context)
              .textTheme
              .headline7
              .copyWith(color: Colors.white),
        ))));
  }
}

class TagBar extends StatefulWidget {

  final ScrollController horizontal = ScrollController();
  TagBar(horizontal);
  TagBarState createState(){
    return TagBarState();
  }
}
  class TagBarState extends State<TagBar>{
    List<CustomTag> listTags = List<CustomTag>();
//    get Tag from repo
//    String tagType;
//    var _tag = const[];
//    Future getTag() async{
//      SharedPreferences pref_tag = await SharedPreferences.getInstance();
//      tagType =  pref_tag.getString("name");
//      List collection = json.decode(tagType);
//      print(collection);
//      List<Tag> tag = collection.map((json) => Tag.fromJson(json)).toList();
//      print(tag);
//      setState(() {
//        _tag = tag;
//      });
//
//    }

    @override
    void initState() {
      super.initState();
    }
  Widget build(BuildContext context) {
      if (listTags.length == 0)
        return null;
//    listTags.add(CustomTag(name: "Assignment",color: "Green"));
//    listTags.add(CustomTag(name: "Assignment",color: "Green"));
//    listTags.add(CustomTag(name: "Presentation",color: "Green"));
    return
      Row(mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max, children: <Widget>[
      SizedBox (width: MediaQuery.of(context).size.width / 100 * 3),
      Container(width: MediaQuery.of(context).size.width / 100 * 10,
          height: MediaQuery.of(context).size.width / 100 * 9,
          margin: EdgeInsets.only(top:MediaQuery.of(context).size.height / 100 * 2, bottom:MediaQuery.of(context).size.height / 100),
          child:FloatingActionButton(onPressed:(){
           showDialog(context: context, builder: (BuildContext context) => Dialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),child: CreateTag()));
    },child: Icon(Icons.add, size: 20, color: Colors.black), backgroundColor: Colors.white)),
//      SizedBox (width: MediaQuery.of(context).size.width / 100 * 2),
      Container(
        width: MediaQuery.of(context).size.width/100*85,
       height: MediaQuery.of(context).size.height / 100 * 6,
        child: ListView.builder(
          controller: widget.horizontal,
            scrollDirection: Axis.horizontal,
            itemCount: listTags.length,
            itemBuilder: (context, index) {
              final item = listTags[index];
//            if (listTags.length != 0) ??
              return CustomTag(name: item.nameTag.toString());
            }))]
    );
  }
}
