//import 'package:flutter/material.dart';
//import 'package:note_app/presentations/UI/page/home_screen.dart';
//
//void main() => runApp(MyApp());
//
//class MyApp extends StatelessWidget {
//  // This widget is the root of your application.
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      title: 'Flutter Demo',
//      theme: ThemeData(
//        // This is the theme of your application.
//        //
//        // Try running your application with "flutter run". You'll see the
//        // application has a blue toolbar. Then, without quitting the app, try
//        // changing the primarySwatch below to Colors.green and then invoke
//        // "hot reload" (press "r" in the console where you ran "flutter run",
//        // or simply save your changes to "hot reload" in a Flutter IDE).
//        // Notice that the counter didn't reset back to zero; the application
//        // is not restarted.
//        primarySwatch: Colors.blue,
//      ),
//      home: HomeScreen(),
//    );
//  }
//}

import 'package:device_preview/device_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/application/constants.dart';
import 'package:note_app/application/router.dart';
import 'package:note_app/presentations/UI/page/home_screen.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
//  runApp(
//    DevicePreview(
//      builder: (context) => MyApp(),
//    ),
//  );

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Note App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      initialRoute: RoutePaths.Home,
      onGenerateRoute: Router.generateRoute,
      home: TestWidget(),
    );
  }
}

class TestWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return HomeScreen();
  }
}

