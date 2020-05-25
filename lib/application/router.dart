import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/application/constants.dart';
import 'package:note_app/presentations/UI/page/camera_access.dart';
import 'package:note_app/presentations/UI/page/create_note.dart';
import 'package:note_app/presentations/UI/page/create_tag.dart';
import 'package:note_app/presentations/UI/page/customPaint.dart';
import 'package:note_app/presentations/UI/page/home_screen.dart';
import 'package:note_app/presentations/UI/page/image_pick.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePaths.Home:
        return MaterialPageRoute(
            builder: (BuildContext context) => HomeScreen());
//      case RoutePaths.Create_tag:
//        return MaterialPageRoute(
//            builder: (BuildContext context) => CreateTag());
      case RoutePaths.Pick_image:
        return MaterialPageRoute(
            builder: (BuildContext context) => PickImage());
//      case RoutePaths.Camera:
//        return MaterialPageRoute(builder: (BuildContext context) => TakePictureScreen());
//      case RoutePaths.Paint:
//        return MaterialPageRoute(builder: (BuildContext context) => CustomPaintPage());
      case RoutePaths.Create_note:
        return MaterialPageRoute(
            builder: (BuildContext context) => CreateNote());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}
