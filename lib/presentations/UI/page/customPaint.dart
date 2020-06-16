import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:note_app/presentations/UI/page/create_note.dart';
import 'package:note_app/utils/model/noteItem.dart';
import 'package:note_app/view_model/note_view_model.dart';
import 'package:note_app/utils/model/note.dart';
import 'package:painter2/painter2.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class CustomPaintPage extends StatefulWidget {
  final NoteViewModel model;
  File img;
  CustomPaintPage(File _img, NoteViewModel _model)
      : img = _img,
        model = _model;
  @override
  _CustomPaintPageState createState() => new _CustomPaintPageState();
}

class _CustomPaintPageState extends State<CustomPaintPage> {
  bool _finished;
  PainterController _controller;
  String fileName;
  @override
  void initState() {
    super.initState();
    _finished = false;
    _controller = _newController();
  }

  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  PainterController _newController() {
    PainterController controller = new PainterController();
    controller.thickness = 5.0;
    controller.backgroundImage = Image.file(widget.img);
    super.initState();
    return controller;
  }

  int i = 0;

  void _saveImage(Uint8List uint8List, Directory dir, String fileName,
      {Function success, Function fail}) async {
    bool isDirExist = await Directory(dir.path).exists();
    if (!isDirExist) Directory(dir.path).create();
    String tempPath = '${dir.path}$fileName';
    File image = File(tempPath);
    bool isExist = await image.exists();
    if (isExist) await image.delete();
    File(tempPath).writeAsBytes(uint8List).then((_) {
      print("succéess");
      if (success != null) success();
    });
  }

  Widget build(BuildContext context) {
    List<Widget> actions;
    if (_finished) {
      actions = <Widget>[
        IconButton(
          icon: Icon(Icons.content_copy),
          tooltip: 'New Painting',
          onPressed: () => setState(() {
            _finished = false;
            _controller = _newController();
          }),
        ),
      ];
    } else {
      actions = <Widget>[
        IconButton(
          icon: Icon(Icons.undo),
          tooltip: 'Undo',
          onPressed: () {
            if (_controller.canUndo) _controller.undo();
          },
        ),
        IconButton(
          icon: Icon(Icons.redo),
          tooltip: 'Redo',
          onPressed: () {
            if (_controller.canRedo) _controller.redo();
          },
        ),
        IconButton(
          icon: Icon(Icons.delete),
          tooltip: 'Clear',
          onPressed: () => _controller.clear(),
        ),
        IconButton(
            icon: Icon(Icons.check),
            onPressed: () async {
              setState(() {
                _finished = true;
              });
              Uint8List bytes = await _controller.exportAsPNGBytes();
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return Scaffold(
                  backgroundColor: Theme.of(context).backgroundColor,
                  appBar: AppBar(
                    backgroundColor: Color.fromRGBO(255, 209, 16, 1.0),
                    actions: <Widget>[
                      IconButton(
                          icon: Icon(Icons.check),
                          onPressed: () async {
//                            print("save " + widget.img.path);
//                            await GallerySaver.saveImage(widget.img.path,
//                                albumName: "NoteApp");

                            NoteItem tmp = NoteItem("Image");
                            var pathImg = '/storage/emulated/0/NoteApp/' +
                                widget.img.path.split("/").last;
//                            Image paint = Image.memory(bytes);
//                            String pathTemp = pathImg + "-paint";
//                            await GallerySaver.saveImage(pathTemp,
//                                albumName: "NoteApp");
                            await _saveImage(
                                bytes,
                                Directory('/storage/emulated/0/NoteApp/'),
                                widget.img.path.split("/").last);
//                            Uint8List bytes;
//                            File imgFile = File(pathImg);
//                            bytes = imgFile.readAsBytesSync();
                            tmp.content = pathImg;
//                            widget.model.enCodeImg(tmp);
                            widget.model.addNoteItem(tmp);
//                            Navigator.of(context).pop(
                            MaterialPageRoute(builder: (BuildContext context) {
                              return CreateNote();
                            });
//                            );
                          })
                    ],
                    elevation: 0.0,
                    title: Text('View your image',
                        style: TextStyle(
                            color: Theme.of(context).iconTheme.color)),
                  ),
                  body: Container(
                    child: Image.memory(bytes),
                  ),
                );
              }));
            }),
      ];
    }
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
          elevation: 0.0,
          title: Text('Edit image',
              style: TextStyle(color: Theme.of(context).iconTheme.color)),
          actions: actions,
          bottom: PreferredSize(
            child: DrawBar(_controller),
            preferredSize: Size(MediaQuery.of(context).size.width, 30),
          )),
      body: Center(
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 100 * 80,
              decoration: BoxDecoration(
                  color: Colors.yellow.withAlpha(20),
                  border: Border.all(width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child:
                  AspectRatio(aspectRatio: 1.0, child: Painter(_controller)))),
    );
  }
}

class DrawBar extends StatelessWidget {
  final PainterController _controller;

  DrawBar(this._controller);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Flexible(child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
              child: Slider(
            value: _controller.thickness,
            onChanged: (value) => setState(() {
              _controller.thickness = value;
            }),
            min: 1.0,
            max: 20.0,
            activeColor: Colors.white,
          ));
        })),
        ColorPickerButton(_controller),
//        ColorPickerButton(_controller, true),
      ],
    );
  }
}

class ColorPickerButton extends StatefulWidget {
  final PainterController _controller;

  ColorPickerButton(this._controller);

  @override
  _ColorPickerButtonState createState() => new _ColorPickerButtonState();
}

class _ColorPickerButtonState extends State<ColorPickerButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(_iconData, color: _color),
      tooltip: 'Change draw color',
      onPressed: () => _pickColor(),
    );
  }

  void _pickColor() {
    Color pickerColor = _color;
    Navigator.of(context)
        .push(MaterialPageRoute(
            fullscreenDialog: true,
            builder: (BuildContext context) {
              return Scaffold(
                  backgroundColor: Theme.of(context).backgroundColor,
                  appBar: AppBar(
                    leading:
                        BackButton(color: Theme.of(context).iconTheme.color),
                    elevation: 0.0,
                    title: Text('Pick color',
                        style: TextStyle(
                            color: Theme.of(context).iconTheme.color)),
                  ),
                  body: Container(
                      alignment: Alignment.center,
                      child: ColorPicker(
                        pickerColor: pickerColor,
                        onColorChanged: (Color c) => pickerColor = c,
                      )));
            }))
        .then((_) {
      setState(() {
        _color = pickerColor;
      });
    });
  }

  Color get _color => widget._controller.drawColor;

  IconData get _iconData => Icons.brush;

  set _color(Color color) {
    widget._controller.drawColor = color;
  }
}
