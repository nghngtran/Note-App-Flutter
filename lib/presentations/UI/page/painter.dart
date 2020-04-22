import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:async';

import 'package:flutter/services.dart';
class PainterPage extends StatefulWidget{
  PainterPage({Key key, this.title}): super(key:key);
  final String title;
  Painter createState() => Painter();
}
class Painter extends State<PainterPage>
{
  ui.Image image;
  bool isImageloaded = false;
  GlobalKey _myCanvasKey = new GlobalKey();

  void initState() {
    super.initState();
    init();
  }

  Future <Null> init() async {
    final ByteData data = await rootBundle.load('assets/img.png');
    image = await loadImage( Uint8List.view(data.buffer));
  }

  Future<ui.Image> loadImage(List<int> img) async {
    final Completer<ui.Image> completer =  Completer();
    ui.decodeImageFromList(img, (ui.Image img) {
      setState(() {
        isImageloaded = true;
      });
      return completer.complete(img);
    });
    return completer.future;
  }

  Widget _buildImage() {
    ImageEditor editor= ImageEditor(image: image);
    if (this.isImageloaded) {
      return  GestureDetector(
        onPanDown: (detailData){
          editor.update(detailData.localPosition);
          _myCanvasKey.currentContext.findRenderObject().markNeedsPaint();

        },
        onPanUpdate: (detailData){
          editor.update(detailData.localPosition);
          _myCanvasKey.currentContext.findRenderObject().markNeedsPaint();

        },
        child: CustomPaint(
          key: _myCanvasKey,
          painter:  editor,
        ),
      );
    } else {
      return  Center(child:  Text('loading'));
    }
  }
  @override
  Widget build(BuildContext context) {
    return  _buildImage();
  }
}

class ImageEditor extends CustomPainter {

  ImageEditor({
    this.image,
  });

  ui.Image image;

  List<Offset> points=List();

  final Paint painter = new Paint()
    ..color = Colors.blue
    ..style = PaintingStyle.fill
    ..strokeWidth = 2;

  void update(Offset offset){
    points.add(offset);
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImage(image,  Offset(0.0, 0.0),  Paint());
    for(Offset offset in points){
      canvas.drawCircle(offset, 5, painter);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}

