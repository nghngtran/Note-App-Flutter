import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/application/constants.dart';

class ChooseTitle extends StatelessWidget{
  final textController = TextEditingController();

  Widget build(BuildContext context)
  {
    return Container(
        width: MediaQuery.of(context).size.width/100*80,
        height: MediaQuery.of(context).size.height/100*25,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: ColorTheme.colorBar,
        ),
        padding: EdgeInsets.only(top:MediaQuery.of(context).size.height/100*2,left:MediaQuery.of(context).size.width/100*2),
        child: Column(
          children: <Widget>[

            Text("Choose title",style: Theme.of(context)
                .textTheme
                .title.copyWith(fontWeight: Font.SemiBold)),
            SizedBox(height: MediaQuery.of(context).size.height/100*2),
            Row(
                children: <Widget>[
                  SizedBox(width: MediaQuery.of(context).size.width/100*5),
                  Expanded(flex: 7,
                      child: TextField(
                        controller: textController,
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 18),
                        decoration: InputDecoration(
                            alignLabelWithHint: true,
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide:
                                BorderSide(color: Colors.black38, width: 1)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide:
                                BorderSide(color: Colors.black, width: 1)),
                            hintText: "Enter name",
                            contentPadding: EdgeInsets.fromLTRB(5, 15, 0, 15),
                            hintStyle: TextStyle(color: Colors.black, fontSize: 16)),
                      )),
                  SizedBox(width: MediaQuery.of(context).size.width/100*2),
                ]),
            Expanded(child:Row(
              children: <Widget>[
                SizedBox(width: MediaQuery.of(context).size.width/100*10),
                Expanded(flex: 1,child: FlatButton(color: Colors.redAccent,textColor: Colors.black,child: Text("Cancel",style: Theme.of(context)
                    .textTheme
                    .subhead),onPressed: (){
                  Navigator.of(context).pop();
                },shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(5),
                    side: BorderSide(color: Colors.red)
                ),
                )),
                SizedBox(width: MediaQuery.of(context).size.width/100*5),
                Expanded(flex: 1,child: FlatButton(color: Colors.blue,textColor: Colors.black,child: Text("Save",style: Theme.of(context)
                    .textTheme
                    .subhead), onPressed: (){},
             shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(5),
                    side: BorderSide(color: Colors.blue)
                ),)),
                SizedBox(width: MediaQuery.of(context).size.width/100*10),
              ],
            )),

          ],)

    );
  }
}