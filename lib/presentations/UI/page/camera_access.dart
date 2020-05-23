//import 'package:camera/camera.dart';
//import 'package:camera/new/src/camera_controller.dart';
//import 'package:flutter/cupertino.dart';
//import 'dart:io';
//import 'dart:typed_data';
//import 'package:esys_flutter_share/esys_flutter_share.dart';
//import 'package:flutter/material.dart';
//import 'package:path/path.dart';
//
//class CameraScreen extends StatefulWidget {
//  @override
//  _CameraScreenState createState() {
//    return _CameraScreenState();
//  }
//}
//
//class _CameraScreenState extends State<CameraScreen> {
//  CameraController controller;
//  List cameras;
//  int selectedCameraIdx;
//  String imagePath;
//
//  @override
//  void initState() {
//    super.initState();
//    availableCameras().then((availableCameras) {
//      cameras = availableCameras;
//
//      if (cameras.length > 0) {
//        setState(() {
//          selectedCameraIdx = 0;
//        });
//
//        _initCameraController(cameras[selectedCameraIdx]).then((void v) {});
//      } else {
//        print("No camera available");
//      }
//    }).catchError((err) {
//      print('Error: $err.code\nError Message: $err.message');
//    });
//  }
//
//  Future _initCameraController(CameraDescription cameraDescription) async {
//    if (controller != null) {
//      await controller.dispose();
//    }
//
//    controller = CameraController(cameraDescription, ResolutionPreset.high);
//
//    // If the controller is updated then update the UI.
//    controller.addListener(() {
//      if (mounted) {
//        setState(() {});
//      }
//
//      if (controller.value.hasError) {
//        print('Camera error ${controller.value.errorDescription}');
//      }
//    });
//
//    try {
//      await controller.initialize();
//    } on CameraException catch (e) {
//      _showCameraException(e);
//    }
//
//    if (mounted) {
//      setState(() {});
//    }
//  }
//}
//
//class PreviewImageScreen extends StatefulWidget {
//  final String imagePath;
//
//  PreviewImageScreen({this.imagePath});
//
//  @override
//  _PreviewImageScreenState createState() => _PreviewImageScreenState();
//}
//
//class _PreviewImageScreenState extends State<PreviewImageScreen> {
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('Preview'),
//        backgroundColor: Colors.blueGrey,
//      ),
//      body: Container(
//        child: Column(
//          crossAxisAlignment: CrossAxisAlignment.stretch,
//          children: <Widget>[
//            Expanded(
//                flex: 2,
//                child: Image.file(File(widget.imagePath), fit: BoxFit.cover)),
//            SizedBox(height: 10.0),
//            Flexible(
//              flex: 1,
//              child: Container(
//                padding: EdgeInsets.all(60.0),
//                child: RaisedButton(
//                  onPressed: () {
//                    getBytesFromFile().then((bytes) {
//                      Share.file('Share via:', basename(widget.imagePath),
//                          bytes.buffer.asUint8List(), 'image/png');
//                    });
//                  },
//                  child: Text('Share'),
//                ),
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//
//  Future<ByteData> getBytesFromFile() async {
//    Uint8List bytes = File(widget.imagePath).readAsBytesSync() as Uint8List;
//    return ByteData.view(bytes.buffer);
//  }
//}
