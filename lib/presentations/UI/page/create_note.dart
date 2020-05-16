import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/application/constants.dart';
import 'package:note_app/presentations/UI/custom_widget/FAB.dart';
import 'package:note_app/presentations/UI/custom_widget/choose_title.dart';
import 'package:note_app/presentations/UI/custom_widget/custom_text_style.dart';
import 'package:note_app/presentations/UI/page/create_tag.dart';
import 'package:note_app/presentations/UI/page/customPaint.dart';
import 'package:note_app/presentations/UI/page/home_screen.dart';
import 'package:note_app/utils/database/dao/note_dao.dart';
import 'package:note_app/utils/database/model/note.dart';
import 'package:note_app/utils/database/model/noteItem.dart';

class CreateNote extends StatefulWidget {
  Notes note;
  CreateNote(Notes _note):note = _note;
  CreateNoteState createState() => CreateNoteState();
}

class CreateNoteState extends State<CreateNote> {

    bool visible = true;
    ScrollController mainController = ScrollController();
    TextEditingController txtController;

    void initState() {
      super.initState();

    }
    Future<void> _handleClickMe() async {
      return showDialog<void>(
context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('Save your changes to this note ?'),
            content: Text('Your changes will be canceled, press "Cancel" to continue or "Don\'t save" to exit. '),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('Don\'t save',style:Theme.of(context)
                    .textTheme
                    .headline7
                    .copyWith(color: Colors.black.withOpacity(0.2),fontWeight: Font.SemiBold)),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen()));
                },
              ),
              CupertinoDialogAction(
                child: Text('Continue',style:Theme.of(context)
              .textTheme
              .headline7
              .copyWith(color: Colors.blue,fontWeight: Font.SemiBold)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    Widget build(BuildContext context) {
      double w = MediaQuery.of(context).size.width / 100;
      double h = MediaQuery.of(context).size.height / 100;

   print("Page" + widget.note.contents.length.toString());
      return Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomPadding: false,
          floatingActionButton:
          FancyFab(widget.note),
          appBar: AppBar(
              title: Text('Create new note',style:TextStyle(color: Colors.black)),
            backgroundColor: Color.fromRGBO(255, 209, 16, 1.0),
            leading: BackButton(color: Colors.black,onPressed: (){
              _handleClickMe();

            },)

          ),
          body: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: h*2),
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: <Widget>[
                  Expanded(
                      flex: 6,
                      child:InkWell(onTap: (){
                        showDialog(context: context, builder: (BuildContext context) => Dialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            child: ChooseTitle()));
                      },
                          child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(width: w*4),
                            Text(
                              "New untitled note",
                              style: Theme.of(context)
                                  .textTheme
                                  .title
                                  .copyWith(color: Colors.black,fontWeight: Font.SemiBold),
                            ),
                            SizedBox(width: w*2),
                            Image.asset("assets/edit.png", fit: BoxFit.contain,width: w*5,height: w*5,)
                          ],
                        ),
                      ))),
                  Expanded(
                      child: GestureDetector(onTap:(){
                        NoteDAO.insertNote(widget.note);
                      },
                    child: Text(
                      "Save",
                      style: Theme.of(context)
                          .textTheme
                          .title
                          .copyWith(color: Colors.blue,fontWeight: Font.SemiBold),
                    ),
                  ))
                ]),
          Container( width: w * 25,
              height: h* 5,
                        margin: EdgeInsets.only(
                            left: 4 * MediaQuery.of(context).size.width / 100,
                            top: MediaQuery.of(context).size.height / 100 * 2,bottom: h),
                        decoration: BoxDecoration(border: Border.all(color: Colors.black,width: 2),
                            borderRadius: BorderRadius.all(Radius.circular(15),),
                            color: Colors.white),
              child:GestureDetector(
                onTap: () {
                  showDialog(context: context, builder: (BuildContext context) => Dialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      child: CreateTag()));
                },
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(width: w*2),
                              Icon(
                                Icons.local_offer,
                                color: Colors.black.withOpacity(0.4),
                              ),
                              SizedBox(width: w),
                              Text(
                                "Add tag",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline7
                                    .copyWith(
                                        color: Colors.black.withOpacity(0.4),fontWeight: Font.Bold),
                              )
                            ]))),
                (widget.note.contents != null)
        ?
                Expanded(child:Container(child:
                ListNoteItems((widget.note))
                ))
                    : Text("")
              ]));
    }

  }
class ListNoteItems extends StatefulWidget{
  List<NoteItem> listNote;
  Notes note;
  ListNoteItems(Notes _note) : note = _note;
  BlockText createState() =>BlockText();
}
class BlockText extends State<ListNoteItems> {
  TextEditingController txtController;
  Widget build(BuildContext context) {
//    print(widget.note.contents.length);
    double w = MediaQuery
        .of(context)
        .size
        .width / 100;
    double h = MediaQuery
        .of(context)
        .size
        .height / 100;
    if (widget.note.contents.length ==0){
      return Text("");
    }
    else{
    return ListView.builder(
        itemCount: widget.note.contents.length, itemBuilder: (context, index) {
      final item = widget.note.contents[index];
      if (item.type == "Text")
      {
        return
//          Wrap(direction: Axis.vertical,children: <Widget>[
        Container(height: h*25,
            margin: EdgeInsets.fromLTRB(w * 4, h * 2, w * 2, h),
            padding: EdgeInsets.fromLTRB(w, h, w, h),
            decoration: BoxDecoration(
                border: Border.all(width: 1.5, color: Colors.black),
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.greenAccent),
            child: TextFormField(
              maxLength: 1000,
              maxLines: 50,
              controller: txtController,
              style: TextStyle(
                  fontSize: 17,
                  fontStyle: FontStyle.normal,
                  color: Colors.black),
              validator: (value) {
                if (value.isEmpty) {
//                  return 'Pls enter some text';
                }
//              widget.listNote.add(NoteItem.s)
//                return value;
              },
            )
        );

}

      else if (item.type == "Image")
        {
          return Container(height: w*100,
          margin: EdgeInsets.fromLTRB(w * 4, h * 2, w * 2, h),
      padding: EdgeInsets.fromLTRB(w, h, w, h),
      decoration: BoxDecoration(
      border: Border.all(width: 1.5, color: Colors.black),
      borderRadius: BorderRadius.all(Radius.circular(10)),
      color: Colors.white),child:RaisedButton(autofocus: false,onPressed:(){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => CustomPaintPage("assets/img.png")));
              },child:
          Image.asset("assets/img.png",fit: BoxFit.contain,)));
        }
      return Container(height: h * 5,
      margin: EdgeInsets.fromLTRB(w * 4, h * 2, w * 2, h),
      padding: EdgeInsets.fromLTRB(w, h, w, h),
      decoration: BoxDecoration(
      border: Border.all(width: 1, color: Colors.black),
      borderRadius: BorderRadius.all(Radius.circular(10)),
      color: Colors.white),
          child: Row(mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(Icons.audiotrack, size: 20,color: Colors.black),
              SizedBox(width: w*2),
              Text("Em Gai Mua audio",style:Theme.of(context)
                  .textTheme
                  .headline7
                  .copyWith(
                  color: Colors.black))
            ],
          ));

    });
  }}
}
