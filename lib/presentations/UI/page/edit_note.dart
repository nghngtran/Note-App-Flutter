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
  EditNote(ThumbnailNote pass) : current = pass;
  EditNoteState createState() => EditNoteState();
}

class EditNoteState extends State<EditNote> {
  ScrollController mainController = ScrollController();
  TagCreatedModel tagCreatedModel;
  String _fileName = "";
  String _path;
  NoteCreatedModel noteCreatedModel;
  FileType _pickingType = FileType.audio;

  Notes cur = Notes();

  Future<void> loadNoteItems() async {
    var notebus = new NoteBUS();
    cur = await notebus.getNoteById(widget.current.noteId);
    print("OPEN NOTE!");
    print("ID: " + cur.id);
    print("Title: " + cur.title);
    for (var i in cur.tags) {
      print("TAG: " + i.title);
    }
    for (var i in cur.contents) {
      print("CONTENT: " + i.content);
    }
  }

  void initState() {
    super.initState();
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
              return CameraScreen(model);
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

  Widget _form; // Save the form

  @override
  Widget build(BuildContext context) {
    if (_form == null) { // Create the form if it does not exist
      _form = _createForm(context); // Build the form
    }
    return _form; // Show the form in the application
  }

  Widget _createForm(BuildContext context) {
    double w = MediaQuery.of(context).size.width / 100; //giờ đếm đi
    double h = MediaQuery.of(context).size.height / 100;

    return FutureBuilder(
        future: loadNoteItems(),
        builder: (context, state) {
          if (state.connectionState == ConnectionState.done)
            return BaseView<NoteViewModel>(
                onModelReady: (noteViewModel) => noteViewModel.Set(cur),
                builder: (context, noteViewModel, child) =>GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      FocusScopeNode currentFocusScope = FocusScope.of(context);

                      if (!currentFocusScope.hasPrimaryFocus) {
                        currentFocusScope.unfocus();
                      }
                    },
                    child: Scaffold(
                    backgroundColor: Theme.of(context).backgroundColor,
                    resizeToAvoidBottomPadding: false,
                    floatingActionButton: UnicornDialer(
                      parentButtonBackground: Theme.of(context).cursorColor,
                      orientation: UnicornOrientation.VERTICAL,
                      parentButton: Icon(Icons.add,
                          color: Theme.of(context).primaryColor),
                      childButtons: _getProfileMenu(noteViewModel),
                    ),
                    appBar: AppBar(
                        title: Text('View Note',
                            style: TextStyle(
                                color: Theme.of(context).iconTheme.color)),
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
                                              builder: (BuildContext context) =>
                                                  Dialog(
                                                      elevation: 0.0,
                                                      backgroundColor:
                                                          Theme.of(context)
                                                              .backgroundColor,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)),
                                                      child: ChooseTitle(noteViewModel)));
                                        },
                                        child: Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              SizedBox(width: w * 4),
                                              Text(
                                                noteViewModel.title, //uhm
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subhead
                                                    .copyWith(
                                                        color: Theme.of(context)
                                                            .iconTheme
                                                            .color,
                                                        fontWeight:
                                                            Font.Regular),
                                              ),
                                              SizedBox(width: w * 2),
                                              Icon(Icons.edit,
                                                  size: 20,
                                                  color: Theme.of(context)
                                                      .iconTheme
                                                      .color)
                                            ],
                                          ),
                                        ))),
                                Expanded(
                                    child: GestureDetector(
                                  onTap: () async {
                                    Notes tem = Notes();
                                    tem.setListNoteItems(noteViewModel.contents);
                                    tem.setTitle(noteViewModel.title);
                                    tem.setTag(noteViewModel.tags);
                                    tem.id = cur.id;
                                    tem.history = cur.history;
                                    tem.modified_time = DateTime.now();
                                    tem.created_time = cur.created_time;

                                    print("SAVE NOTE!");
                                    print("ID " + tem.id);
                                    print("Title: " + noteViewModel.title);
                                    for (var i in noteViewModel.tags) {
                                      print("TAG: " + i.title + " Color: " + i.color.toString() + " ID: " + i.id);
                                    }
                                    for (var i in noteViewModel.contents) {
                                      print("CONTENT: " + i.content);
                                    }

                                    final NoteBUS noteBus = NoteBUS();
                                    bool temp = await noteBus.updateNote(tem);
                                    print("WORK? :" + temp.toString());

                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                      return HomeScreen();
                                    }
                                    ))

                                    ;
                                  },
                                  child: Text(
                                    "Save",
                                    style: Theme.of(context)
                                        .textTheme
                                        .title
                                        .copyWith(
                                            color: Theme.of(context).highlightColor,
                                            fontWeight: Font.Regular),
                                  ),
                                ))
                              ]),
                          TagBarOfNote(noteViewModel, heroTag: "TagNote"),
                          (noteViewModel.contents.length != null)
                              ? Expanded(
                                  child: Container(
                                      child: ListNoteItems(noteViewModel)))
                              : Text("")
                        ]))));
          return Container();
        });
  }
}

class ListNoteItems extends StatefulWidget {
  final NoteViewModel model;

  ListNoteItems(this.model);
  ListNoteItemsState createState() => ListNoteItemsState();
}

class ListNoteItemsState extends State<ListNoteItems> {
  void initState() {
    super.initState();
  }

  ScrollController _controller = new ScrollController();

  @override
  Widget build(BuildContext context) {
//    return ListView(
//      controller: _controller,
//      children: getChildrenNotes(),
//    );

    return (widget.model.contents.length > 0)
        ? ListView.builder(
        controller: _controller,
        itemCount: widget.model.contents.length,
        itemBuilder: (context, index) {
          final item = getChildrenNotes()[index];
          final Key noteItem = Key(item.toString());
          return Dismissible(
              direction: DismissDirection.endToStart,
              resizeDuration: Duration(milliseconds: 200),
              background: Container(
                  color: Colors.red,
                  alignment: AlignmentDirectional.centerEnd,
                  child: Icon(Icons.delete,
                      color: Theme.of(context).iconTheme.color)),
              onDismissed: (direction) {
                widget.model.contents.removeAt(index);
                print(widget.model.contents);
              },
              key: noteItem,
              child: item);
        })
        : Text("");
  }

  List<Widget> getChildrenNotes() {
//    print("note" + widget.model.contents.length.toString());
    if (widget.model.contents.length == 0) {
      return List<Container>();
    }
    return widget.model.contents.map((todo) => NoteItemWidget(todo)).toList();
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
    if(widget.item.content == null)
      widget.item.content = "";

    txtController = TextEditingController.fromValue(TextEditingValue(
      text: widget.item.content,
      selection: TextSelection.collapsed(offset: widget.item.content.length),
    ));

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
//    widget.item.setContent(widget.item.content);

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
                      onChanged: (text) {
                        widget.item.setContent(text);
                        widget.item.setBgColor(noteColor);
                        print("CHANGE:" + text);
                      },
                      onSaved: (value) {
                        widget.item.setContent(value);
                        widget.item.setBgColor(noteColor);
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
    //final picker = ImagePicker();
    File imgFile = File(item.content);
    print(item.content);
    //ImagePicker.pickImage(source: ImageSource.gallery);
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
      return GestureDetector(
          onTap: () {
            //showDialog(context: context, child: dialogImg(context, model)); //thằng này có note item
          },
          child: Container(
          width: w * 100,
          height: w * 100,
          margin: EdgeInsets.fromLTRB(w * 2, h, w * 2, h),
          padding: EdgeInsets.fromLTRB(w, h, w, h),
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.white),
          child: Image.memory(bytes))
      );
    }
    advancedPlayer.startHeadlessService();
    print(item.content);
    return HandleAudio(url: item.content);
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
                  return CameraScreen(model);
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
}
