import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/presentations/UI/custom_widget/custom_note_card.dart';
class Note extends StatelessWidget {
  DateNote dateNote = DateNote();
  List<NoteCardModel> listNote = List<NoteCardModel>();
  Note({@required DateNote date, @required List<NoteCardModel> list}):
      dateNote = date,
      listNote = list;
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(height: MediaQuery.of(context).size.height/100*2),
        Padding(padding:EdgeInsets.only(left:4 * MediaQuery.of(context).size.width / 100),
            child:Text(dateNote.date,style: Theme.of(context)
        .textTheme
        .body2
        .copyWith(color: Colors.black,fontSize: 20))),
        noteGridBuilder(context,listNote)
        ],
    );
  }
}
Widget noteGridBuilder(BuildContext context, List<NoteCardModel> indexes) {
  List<Widget> columnOne = List<Widget>();
  List<Widget> columnTwo = List<Widget>();

  bool secondColumnFirst = false;
  if ((indexes.length - 1).isEven) {
    secondColumnFirst = false;
  } else {
    secondColumnFirst = true;
  }

  for (int i = 0; i < indexes.length; i++) {
    int bIndex = (indexes.length - 1) - i;
    if (bIndex.isEven) {
      columnOne.add(NoteCard(indexes[bIndex]));
    } else {
      columnTwo.add(NoteCard(indexes[bIndex]));
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
        Expanded(child:Container(
          width: MediaQuery.of(context).size.width / 2 - 4,
          child: Column(
            children: secondColumnFirst ? columnOne : columnTwo,
          ),
        ),
        )],
    );
  } else
    return null;
}
class NoteGrid extends StatelessWidget{
  List<Note> _note = List<Note>();
  NoteGrid(List<Note> note) : _note = note;
  Widget build(BuildContext context)
  {
    return Container (width:MediaQuery.of(context).size.width, child:
      ListView.builder(itemCount: _note.length,
        itemBuilder: (context, index){
      final item = _note[index];
      return item;
    }));
  }
}
