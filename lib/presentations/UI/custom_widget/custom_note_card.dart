import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/presentations/UI/custom_widget/custom_text_style.dart';

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

class NoteCardState extends State<NoteCard> {
  NoteCardModel noteCard;
  NoteCardState(NoteCardModel note) {
    this.noteCard = note;
    print(note.title.toString());
  }

  Widget build(BuildContext context) {
    print(noteCard.toString());
    print(noteCard.title.toString());
    Image img;
    if (noteCard.imgUrl != null) img = Image.network(noteCard.imgUrl);
    return InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {},
        child: Container(
            margin: EdgeInsets.only(
                top: 4 * MediaQuery.of(context).size.height / 100),
            padding:
                EdgeInsets.all(4 * MediaQuery.of(context).size.width / 100),
            width: 45 * MediaQuery.of(context).size.width / 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 30.0, // has the effect of softening the shadow
                  spreadRadius: 2.0, // has the effect of extending the shadow
                  offset: Offset(
                    10.0, // horizontal, move right 10
                    10.0, // vertical, move down 10
                  ),
                )
              ],
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
                            width: 2 * MediaQuery.of(context).size.width / 100),
                        Text(noteCard.typeTag,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle
                                .copyWith(color: Colors.blue))
                      ],
                    ) ??
                    Text("ko"),
                SizedBox(height: 2 * MediaQuery.of(context).size.height / 100),
                Text(noteCard.content,
                    style: Theme.of(context)
                        .textTheme
                        .headline7
                        .copyWith(color: Colors.black))
              ],
            )));
  }
}
