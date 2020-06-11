import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note_app/application/constants.dart';
import 'package:note_app/presentations/UI/custom_widget/choose_title.dart';
import 'package:note_app/presentations/UI/custom_widget/tab_bar_note.dart';
import 'package:note_app/presentations/UI/page/MoreOptionsSheet.dart';
import 'package:note_app/presentations/UI/page/base_view.dart';

import 'package:note_app/presentations/UI/page/camera.dart';
import 'package:note_app/presentations/UI/page/handle_audio.dart';
import 'package:note_app/presentations/UI/page/home_screen.dart';
import 'package:note_app/presentations/UI/page/image_pick.dart';
import 'package:note_app/presentations/UI/page/record_audio.dart';
import 'package:note_app/utils/bus/note_bus.dart';
import 'package:note_app/utils/bus/tag_bus.dart';
import 'package:note_app/utils/bus/thumbnail_bus.dart';
import 'package:note_app/utils/model/note.dart';
import 'package:note_app/utils/model/noteItem.dart';
import 'package:note_app/utils/model/thumbnailNote.dart';
import 'package:note_app/view_model/list_tb_note_view_model.dart';
import 'package:note_app/view_model/list_tag_view_model.dart';
import 'package:note_app/view_model/note_view_model.dart';
import 'package:unicorndial/unicorndial.dart';

class EditNote extends StatefulWidget {
  final ThumbnailNote current;
  //Notes cur = Notes();
  EditNote(ThumbnailNote pass) : current = pass; //?????????

  EditNoteState createState() => EditNoteState();
}

class EditNoteState extends State<EditNote> {
  ScrollController mainController = ScrollController();
  TagCreatedModel tagCreatedModel;
  String _fileName = "";
  String _path;
  NoteCreatedModel noteCreatedModel;
  FileType _pickingType = FileType.audio;

  //var note = new Notes();

  Notes cur = Notes();

  void Load() async
  {
    var notebus = new NoteBUS();
    cur = await notebus.getNoteById(widget.current.noteId);
    print(cur.title);
  }
  void initState() {
    super.initState();
    //Load();
  }

  @override
  void dispose() {
    mainController.dispose();
    super.dispose();
  }

  Widget dialogImg(BuildContext context, NoteViewModel model) {
    return CupertinoAlertDialog(
      title: Text('Get image from ?'),
      actions: <Widget>[
        CupertinoDialogAction(
          child: Text('Camera'),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return CameraScreen();
            }));
          },
        ),
        CupertinoDialogAction(
            child: Text('Gallery'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context) {
                  return PickImage(model);
                }),
              );
            })
      ],
    );
  }

  Widget dialogSound(BuildContext context, NoteViewModel model) {
    return CupertinoAlertDialog(
        title: Text('Get sound from ?'),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text('Record'),
            onPressed: () {
              Navigator.of(context).pop();
              showDialog(
                  context: context,
                  builder: (BuildContext context) => Dialog(
                      elevation: 0.0,
                      backgroundColor: Theme.of(context).backgroundColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Record(model)));
            },
          ),
          CupertinoDialogAction(
              child: Text('Mp3'),
              onPressed: () async {
                _path = await FilePicker.getFilePath(type: _pickingType);

                _fileName = _path != null ? _path.split('/').last : '';
                print("check" + _fileName);
                NoteItem tmp = NoteItem("Audio");
                tmp.type = "Audio";
                tmp.setContent(_path);
                model.addNoteItem(tmp);
                Navigator.of(context).pop();
              })
        ]);
  }

  List<UnicornButton> _getProfileMenu(NoteViewModel model) {
    List<UnicornButton> children = [];
    children.add(_profileOption(
        iconData: Icons.create,
        onPressed: () {
          final NoteItem noteItem = NoteItem("Text");
          model.addNoteItem(noteItem);
        },
        hero: "txt"));
    children.add(_profileOption(
        iconData: Icons.camera_alt,
        onPressed: () {
//          final NoteItem noteItem = NoteItem("Image");
//          model.addNoteItem(noteItem);
          showDialog(context: context, child: dialogImg(context, model));
        },
        hero: "img"));
    children.add(_profileOption(
        iconData: Icons.audiotrack,
        onPressed: () {
          showDialog(child: dialogSound(context, model), context: context);
        },
        hero: "sound"));

    return children;
  }

  Widget _profileOption({IconData iconData, Function onPressed, String hero}) {
    return UnicornButton(
        currentButton: FloatingActionButton(
      elevation: 0.0,
      heroTag: hero,
      backgroundColor: Theme.of(context).backgroundColor,
      mini: true,
      child: Icon(iconData, color: Theme.of(context).iconTheme.color),
      onPressed: onPressed,
    ));
  }

  Future<void> _handleClickMe() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Save your changes to this note ?'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Don\'t save'),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
            ),
            CupertinoDialogAction(
              child: Text('Continue'),
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
    double w = MediaQuery.of(context).size.width / 100; //giờ đếm đi
    double h = MediaQuery.of(context).size.height / 100;
    Load();
    return BaseView<NoteViewModel>(
        onModelReady: (noteViewModel) => noteViewModel.Set(cur),
        builder: (context, noteViewModel, child) => Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            resizeToAvoidBottomPadding: false,
            floatingActionButton: UnicornDialer(
              parentButtonBackground: Colors.blue,
              orientation: UnicornOrientation.VERTICAL,
              parentButton:
                  Icon(Icons.add, color: Theme.of(context).primaryColor),
              childButtons: _getProfileMenu(noteViewModel),
            ),
            appBar: AppBar(
                title: Text('View Note',
                    style: TextStyle(color: Theme.of(context).iconTheme.color)),
                leading: BackButton(
                  color: Theme.of(context).iconTheme.color,
                  onPressed: () {
                    _handleClickMe();
                  },
                )),
            body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: h * 2),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(
                            flex: 6,
                            child: InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) => Dialog(
                                          elevation: 0.0,
                                          backgroundColor:
                                              Theme.of(context).backgroundColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: ChooseTitle(noteViewModel)));
                                },
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(width: w * 4),
                                      Text(
                                        cur.title, //uhm
                                        style: Theme.of(context)
                                            .textTheme
                                            .subhead
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .iconTheme
                                                    .color,
                                                fontWeight: Font.Regular),
                                      ),
                                      SizedBox(width: w * 2),
                                      Icon(Icons.edit,
                                          size: 20,
                                          color:
                                              Theme.of(context).iconTheme.color)
                                    ],
                                  ),
                                ))),
                        Expanded(
                            child: GestureDetector(
                          onTap: () async {
                            //note.setListNoteItems(noteViewModel.contents);
                            //note.setTitle(noteViewModel.title);
                            //note.setTag(noteViewModel.tags);
                            final NoteBUS noteBus = NoteBUS();
                            //await noteBus.addNote(note);

                            final ThumbnailBUS thumbBus = ThumbnailBUS();
                            print("|Load FTS|");
                            var thumbs = await thumbBus
                                .getThumbnailsByKeyWordAll("abcd");
                            for (var thumb in thumbs) {
                              print(thumb.toString());
//                              //noteCreatedModel.addToList(thumb);
                            }
                            print("|Load FTS|");

                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return HomeScreen();
                            }));
                          },
                          child: Text(
                            "Save",
                            style: Theme.of(context).textTheme.title.copyWith(
                                color: Colors.blue, fontWeight: Font.Regular),
                          ),
                        ))
                      ]),
                  TagBarOfNote(noteViewModel, heroTag: "TagNote"),
                  (noteViewModel.contents.length != null)
                      ? Expanded(
                          child: Container(child: ListNoteItems(noteViewModel)))
                      : Text("")
                ])));
  }
}

class ListNoteItems extends StatelessWidget {
  final NoteViewModel model; //có đâu
  ListNoteItems(this.model);

  ScrollController _controller = new ScrollController();
  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: _controller,
      children: getChildrenNotes(),
    );
  }

  List<Widget> getChildrenNotes() {
    if (model.contents.length == 0) {
      return List<Container>();
    }
    return model.contents.map((todo) => NoteItemWidget(todo)).toList();
  }
}

class EditText extends StatefulWidget {
  NoteItem item;

  EditText(NoteItem _item) : item = _item;

  EditTextState createState() => EditTextState();
}

class EditTextState extends State<EditText> {
  TextEditingController txtController = TextEditingController();
  var noteColor;
  var _editableNote;

  void initState() {
    _editableNote = widget.item;
    noteColor = _editableNote.noteColor;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtController.dispose();
    super.dispose();
  }

  void _changeColor(Color newColorSelected) {
    print("note color changed");
    setState(() {
      noteColor = newColorSelected;
      _editableNote.noteColor = newColorSelected;
    });
  }

  void bottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext ctx) {
          return MoreOptionsSheet(
            color: noteColor,
            callBackColorTapped: _changeColor,
          );
        });
  }

  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width / 100;
    double h = MediaQuery.of(context).size.height / 100;
    widget.item.setContent(txtController.text);
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: InkWell(
            onLongPress: () {
              bottomSheet(context);
            },
            child: Padding(
                padding: EdgeInsets.fromLTRB(w * 4, h / 2, w * 2, h),
                child: Wrap(children: <Widget>[
                  TextFormField(
                      initialValue: widget.item.content,
                      autocorrect: false,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(w, h, w, h),
                        fillColor: noteColor,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Theme.of(context).backgroundColor,
                                width: 1)),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                      ),
                      maxLength: null,
                      maxLines: null,
                      controller: txtController,
                      style: TextStyle(
                          fontSize: 17,
                          fontStyle: FontStyle.normal,
                          color: Theme.of(context).iconTheme.color),
                      onSaved: (value) {
                        widget.item.setContent(txtController.text);
                        widget.item.setBgColor(noteColor);
                        print(widget.item.content);
                      })
                ]))));
  }
}

class NoteItemWidget extends StatelessWidget {
  final NoteItem item;
  AudioPlayer advancedPlayer = AudioPlayer();
  NoteItemWidget(NoteItem _item) : item = _item;
  Uint8List bytes;
  void enCodeImg() {
    final picker = ImagePicker();
    File imgFile = File(item.content);
    print(item.content);
    ImagePicker.pickImage(source: ImageSource.gallery);
    bytes = imgFile.readAsBytesSync();
  }

  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width / 100;
    double h = MediaQuery.of(context).size.height / 100;
    if (item.type == "Text") {
      return EditText(item);
    } else if (item.type == "Image") {
      enCodeImg();
      print("Bytes:" + bytes.toString());
      return Container(
          width: w * 100,
          height: w * 100,
          margin: EdgeInsets.fromLTRB(w * 2, h, w * 2, h),
          padding: EdgeInsets.fromLTRB(w, h, w, h),
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.white),
          child: Image.memory(bytes));
    }
    advancedPlayer.startHeadlessService();
    print(item.content);
    return HandleAudio(url: item.content);
  }
}