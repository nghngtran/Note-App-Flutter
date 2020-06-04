import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/application/constants.dart';
import 'package:note_app/presentations/UI/custom_widget/custom_text_style.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NoteCardModel {
  String title;
  String typeTag;
  String imgUrl;
  String content;

  NoteCardModel(
      {@required String name, String tag, String imageUrl, String contentCard})
      : title = name,
        typeTag = tag,
        imgUrl = imageUrl,
        content = contentCard;
}

class NoteCard extends StatefulWidget {
  NoteCardModel noteCard;
  NoteCard(NoteCardModel note) : this.noteCard = note;
  NoteCardState createState() {
    return NoteCardState(noteCard);
  }
}

class DateNote {
  String date;
  DateNote({String dateNote}) : date = dateNote;
}

class NoteCardState extends State<NoteCard> {
  NoteCardModel noteCard;
  NoteCardState(NoteCardModel note) {
    this.noteCard = note;
  }
  Widget build(BuildContext context) {
    if (noteCard.imgUrl != null) {
      return InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {},
          child: Container(
              margin: EdgeInsets.only(
                  top: 2 * MediaQuery.of(context).size.height / 100),
              padding:
                  EdgeInsets.all(4 * MediaQuery.of(context).size.width / 100),
              width: 45 * MediaQuery.of(context).size.width / 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: Colors.white,
//              boxShadow: [
//                BoxShadow(
//                  color: Colors.black38,
//                  blurRadius: 20.0, // has the effect of softening the shadow
//                  spreadRadius: 2.0, // has the effect of extending the shadow
//                  offset: Offset(
//                    8.0, // horizontal, move right 10
//                    8.0, // vertical, move down 10
//                  ),
//                )
//              ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(noteCard.title,
                      style: Theme.of(context)
                          .textTheme
                          .title
                          .copyWith(color: Colors.black)),
                  SizedBox(height: MediaQuery.of(context).size.height / 100),
                  Row(
                        children: <Widget>[
                          Icon(Icons.local_offer, color: Colors.blue, size: 16),
                          SizedBox(
                              width:
                                  2 * MediaQuery.of(context).size.width / 100),
                          Text(noteCard.typeTag,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle
                                  .copyWith(color: Colors.blue))
                        ],
                      ) ??
                      Text(""),
                  SizedBox(
                      height: 2 * MediaQuery.of(context).size.height / 100),
                  Stack(children: <Widget>[
                    Container(
                      width: 25 * MediaQuery.of(context).size.height / 100,
                      height: 20 * MediaQuery.of(context).size.height / 100,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage(noteCard.imgUrl),
                        fit: BoxFit.cover,
                      )),
                    )
                  ]),
//                 SizedBox(height: MediaQuery
//                     .of(context)
//                     .size
//                     .height / 100),
//                 Text(noteCard.content,
//                     style: Theme
//                         .of(context)
//                         .textTheme
//                         .headline7
//                         .copyWith(color: Colors.black))
                ],
              )));
    } else if (noteCard.imgUrl == null) {
      return InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {},
          child: Container(
              margin: EdgeInsets.only(
                  top: 2 * MediaQuery.of(context).size.height / 100),
              padding:
                  EdgeInsets.all(4 * MediaQuery.of(context).size.width / 100),
              width: 45 * MediaQuery.of(context).size.width / 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: Colors.yellow,
//              boxShadow: [
//                BoxShadow(
//                  color: Colors.black38,
//                  blurRadius: 20.0, // has the effect of softening the shadow
//                  spreadRadius: 2.0, // has the effect of extending the shadow
//                  offset: Offset(
//                    8.0, // horizontal, move right 10
//                    8.0, // vertical, move down 10
//                  ),
//                )
//              ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(noteCard.title,
                      style: Theme.of(context)
                          .textTheme
                          .title
                          .copyWith(color: Colors.black)),
                  SizedBox(height: MediaQuery.of(context).size.height / 100),
                  Row(
                        children: <Widget>[
                          Icon(Icons.local_offer, color: Colors.blue, size: 16),
                          SizedBox(
                              width:
                                  2 * MediaQuery.of(context).size.width / 100),
                          Text(noteCard.typeTag,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle
                                  .copyWith(color: Colors.blue))
                        ],
                      ) ??
                      Text(""),
                  SizedBox(
                      height: 2 * MediaQuery.of(context).size.height / 100),
                  Text(noteCard.content,
                      style: TextStyle( fontSize: 17,
                      fontFamily: Font.Name,
                      fontWeight: Font.Regular,
                          color: Colors.black))
                ],
              )));
    }
  }
}
