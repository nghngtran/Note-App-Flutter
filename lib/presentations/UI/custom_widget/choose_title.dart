import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/application/constants.dart';
import 'package:note_app/presentations/UI/page/base_view.dart';
import 'package:note_app/utils/database/model/note.dart';
import 'package:note_app/view_model/note_view_model.dart';
import 'package:provider/provider.dart';
import 'package:note_app/presentations/UI/custom_widget/custom_text_style.dart';

class ChooseTitle extends StatelessWidget {
  var title = "";
  final textController = TextEditingController();
  final NoteViewModel noteViewModel;
  ChooseTitle(NoteViewModel _note) : noteViewModel = _note;
  @override
  void initState() {
    title = "";
  }

  Widget build(BuildContext context) {
//    return BaseView<NoteViewModel>(
//        onModelReady: (noteViewModel) => noteViewModel.getListItems(),
//        builder: (context, noteViewModel, child) =>
    return Container(
        width: MediaQuery.of(context).size.width / 100 * 80,
        height: MediaQuery.of(context).size.height / 100 * 22,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: ColorTheme.colorBar,
        ),
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height / 100 * 2,
            left: MediaQuery.of(context).size.width / 100 * 2),
        child: Column(
          children: <Widget>[
            Text("Choose title",
                style: Theme.of(context)
                    .textTheme
                    .title
                    .copyWith(fontWeight: Font.SemiBold)),
            SizedBox(height: MediaQuery.of(context).size.height / 100 * 2),
            Row(children: <Widget>[
              SizedBox(width: MediaQuery.of(context).size.width / 100 * 3),
              Expanded(
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
                        borderSide: BorderSide(color: Colors.black, width: 1)),
                    hintText: "Title",
                    contentPadding: EdgeInsets.fromLTRB(5, 15, 0, 15),
                    hintStyle: TextStyle(color: Colors.black, fontSize: 14)),
              )),
              SizedBox(width: MediaQuery.of(context).size.width / 100 * 2),
            ]),
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
//                    SizedBox(
//                        width: MediaQuery.of(context).size.width / 100 * 10),
                Expanded(
                    flex: 1,
                    child: FlatButton(
                      color: Colors.white,
                      textColor: Colors.black,
                      child: Text("Cancel",
                          style: Theme.of(context).textTheme.headline7),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(5),
                          side: BorderSide(color: Colors.white)),
                    )),
//                    SizedBox(
//                        width: MediaQuery.of(context).size.width / 100 * 5),
                Expanded(
                    flex: 1,
                    child: FlatButton(
                      color: Colors.white,
                      textColor: Colors.blue,
                      child: Text("Save",
                          style: Theme.of(context).textTheme.headline7),
                      onPressed: () {
                        print(textController.text);
                        noteViewModel.setTitle(textController.text);
//
                        Provider.of<Notes>(context, listen: true)
                            .setTitle(textController.text);
                        Navigator.of(context).pop();
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(5),
                          side: BorderSide(color: Colors.white)),
                    )),
//                    SizedBox(
//                        width: MediaQuery.of(context).size.width / 100 * 10),
              ],
            )),
          ],
        ));
  }
}
