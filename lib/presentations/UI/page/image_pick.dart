import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note_app/application/constants.dart';
import 'dart:io';
import 'package:note_app/presentations/UI/page/customPaint.dart';
import 'package:note_app/utils/model/note.dart';
import 'package:note_app/utils/model/noteItem.dart';
import 'package:note_app/view_model/note_view_model.dart';
import 'package:provider/provider.dart';

class PickImage extends StatefulWidget {
  final NoteViewModel model;
  PickImage(NoteViewModel _model) : model = _model;
  @override
  _PickImageState createState() => _PickImageState();
}

class _PickImageState extends State<PickImage> {
  Future<File> imageFile;

  pickImageFromGallery(ImageSource source) {
    setState(() {
      imageFile = ImagePicker.pickImage(source: source);
    });
  }

  Widget showImage(BuildContext context) {
    double w = MediaQuery.of(context).size.width / 100;
    double h = MediaQuery.of(context).size.height / 100;
    return FutureBuilder<File>(
      future: imageFile,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          return GestureDetector(
              onTap: () {
                Image tmp = new Image.file(snapshot.data);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CustomPaintPage(snapshot.data, widget.model)),
                );
              },
              child: Container(
                  width: w * 100,
                  padding: EdgeInsets.fromLTRB(w, h, w, 0),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                      color: Colors.white),
                  child: Image.file(
                    snapshot.data,
                  )));
        } else if (snapshot.error != null) {
          return Text(
            'Error Picking Image',
            style: Theme.of(context).textTheme.subhead,
            textAlign: TextAlign.center,
          );
        } else {
          return Text(
            'No Image Selected',
            style: Theme.of(context)
                .textTheme
                .subhead
                .copyWith(color: Theme.of(context).iconTheme.color),
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width / 100;
    double h = MediaQuery.of(context).size.height / 100;
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
            title: Text('Select image',
                style: TextStyle(color: Theme.of(context).iconTheme.color)),
//            backgroundColor: Color.fromRGBO(255, 209, 16, 1.0),
            leading: BackButton(
              color: Theme.of(context).iconTheme.color,
              onPressed: () {
                if (widget.model.contents.length > 0) {
                  NoteItem noteItem =
                      Provider.of<Notes>(context, listen: true).contents.last;
                  Provider.of<Notes>(context, listen: false)
                      .removeNoteItem(noteItem);
                }
                Navigator.of(context).pop();
              },
            )),
        body: Column(children: <Widget>[
          SizedBox(height: h * 3),
          Expanded(flex: 8, child: showImage(context)),
          SizedBox(height: h * 10),
          Expanded(
              child: Center(
                  child: Container(
                      height: h * 5,
                      width: w * 70,
                      child: RaisedButton(
                        autofocus: false,
                        child: Text("Select Image from Gallery",
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: Font.Name,
                              fontWeight: Font.Regular,
                            )),
                        onPressed: () {
                          pickImageFromGallery(ImageSource.gallery);
                        },
                      )))),
          SizedBox(height: h),
        ]));
  }
}
