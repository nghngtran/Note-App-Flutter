import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/presentations/UI/custom_widget/custom_note_card.dart';
import 'package:note_app/utils/bus/thumbnail_bus.dart';
import 'package:note_app/utils/model/thumbnailNote.dart';


Widget noteGridBuilder(BuildContext context, List<ThumbnailNote> indexes, ValueChanged<String> parent) {
  List<Widget> columnOne = List<Widget>();
  List<Widget> columnTwo = List<Widget>();
  final ValueChanged<String> parentAction = parent; ////callback

  bool secondColumnFirst = false;
  if ((indexes.length - 1).isEven) {
    secondColumnFirst = false;
  } else {
    secondColumnFirst = true;
  }

  for (int i = 0; i < indexes.length; i++) {
    int bIndex = (indexes.length - 1) - i;
    if (bIndex.isEven) {
      columnOne.add(NoteCard(indexes[bIndex], parentAction));
    } else {
      columnTwo.add(NoteCard(indexes[bIndex], parentAction));
    }
  }

  if (indexes.length > 0) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width / 2 - 4,
          child: Column(
            children: secondColumnFirst ? columnTwo : columnOne,
          ),
        ),
        Expanded(
          child: Container(
            width: MediaQuery.of(context).size.width / 2 - 4,
            child: Column(
              children: secondColumnFirst ? columnOne : columnTwo,
            ),
          ),
        )
      ],
    );
  } else
    return Container();
}

class NoteGrid extends StatefulWidget {
  List<ThumbnailNote> _note = List<ThumbnailNote>();
  final ValueChanged<String> parentAction; ////callback
  NoteGrid(List<ThumbnailNote> note, ValueChanged<String> _parent) : _note = note, parentAction = _parent;
  NoteGridState createState() => NoteGridState();
}

class NoteGridState extends State<NoteGrid> {
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[noteGridBuilder(context, widget._note, widget.parentAction)],
    );
  }
//  }
}
