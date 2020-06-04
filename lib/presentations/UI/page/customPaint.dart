import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'package:note_app/utils/database/model/note.dart';
import 'package:note_app/utils/database/model/noteItem.dart';
import 'package:note_app/view_model/note_view_model.dart';

import 'package:image_picker/image_picker.dart';
import 'package:note_app/application/constants.dart';
import 'package:note_app/presentations/UI/page/create_note.dart';
import 'package:note_app/utils/model/note.dart';

import 'package:painter2/painter2.dart';
import 'package:provider/provider.dart';

class CustomPaintPage extends StatefulWidget {
  final NoteViewModel model;
  Image path;
  CustomPaintPage(Image _path, NoteViewModel _model)
      : path = _path,
        model = _model;
  @override
  _CustomPaintPageState createState() => new _CustomPaintPageState();
}

class _CustomPaintPageState extends State<CustomPaintPage> {
  bool _finished;
  PainterController _controller;
  @override
  void initState() {
    super.initState();
    _finished = false;
    _controller = _newController();
  }

  @override
  PainterController _newController() {
    PainterController controller = new PainterController();
    controller.thickness = 5.0;
//    _controller.backgroundColor = Colors.transparent;
    controller.backgroundImage = widget.path;
    super.initState();
    return controller;
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
                  appBar: AppBar(
                    backgroundColor: Color.fromRGBO(255, 209, 16, 1.0),
                    actions: <Widget>[
                      IconButton(
                          icon: Icon(Icons.check),
                          onPressed: () {
                            NoteItem tmp = NoteItem("Image");
                            print(widget.model.getListItems().length);
                            tmp.content = widget.path.toString();
                            Provider.of<Notes>(context, listen: false)
                                .addNoteItem(tmp);
                            widget.model.addNoteItem(tmp);
//                            widget.model
//                                .setContentChildItem(widget.path.toString());

//                            Navigator.of(context).push(MaterialPageRoute(
//                                builder: (BuildContext context) {
//                              return CreateNote();
                            Navigator.popAndPushNamed(context, 'create_note');
//                            }));
                          })
                    ],
                    elevation: 0.0,
                    title: Text('View your image'),
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
      appBar: AppBar(
          backgroundColor: Color.fromRGBO(255, 209, 16, 1.0),
//          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text('Edit image'),
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
                  appBar: AppBar(
                    leading: BackButton(),
                    backgroundColor: Color.fromRGBO(255, 209, 16, 1.0),
//          backgroundColor: Colors.transparent,
                    elevation: 0.0,
                    title: Text('Pick color'),
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
