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

import 'package:camera/camera.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/application/constants.dart';
import 'package:note_app/application/router.dart';
import 'package:note_app/presentations/UI/page/base_view.dart';

import 'package:note_app/presentations/UI/page/home_screen.dart';
import 'package:note_app/presentations/UI/page/test.dart';

import 'package:note_app/utils/database/database.dart';
import 'package:note_app/utils/database/model/note.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

// Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

// Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;
  final originalCheck = Provider.debugCheckInvalidValueType;
  Provider.debugCheckInvalidValueType = <T>(T value) {
    if (value is Object) return;
    originalCheck<T>(value);
  };
  setupDependencyAssembler();
  runApp(ChangeNotifierProvider<AppStateNotifier>(
      create: (context) => AppStateNotifier(), child: MyApp()));

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
    DatabaseApp db = new DatabaseApp();
    return ChangeNotifierProvider(
        create: (context) => Notes(),
        child: Consumer<AppStateNotifier>(builder: (context, appState, child) {
          return MaterialApp(
            title: "Note App",
            debugShowCheckedModeBanner: false,
            theme:
                AppTheme.lightTheme, // ThemeData(primarySwatch: Colors.blue),
            darkTheme:
                AppTheme.darkTheme, // ThemeData(primarySwatch: Colors.blue),
//            ThemeData(),
//      initialRoute: RoutePaths.Pick_image,
            onGenerateRoute: Router.generateRoute,
            home: TestWidget(),
            themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          );
        }));
  }
}

class TestWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomeScreen();
  }
}

class AppTheme {
  AppTheme._();
  static final ThemeData lightTheme = ThemeData.light().copyWith(
    dialogBackgroundColor: Colors.white70,
    backgroundColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.white,
    appBarTheme: AppBarTheme(
      color: Color.fromRGBO(255, 209, 16, 1.0),
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
    ),
//    colorScheme: ColorScheme.light(
//      primary: Colors.black,
//      onPrimary: Colors.white,
//      primaryVariant: Colors.white38,
//      secondary: Colors.black,
//    ),
    floatingActionButtonTheme:
        FloatingActionButtonThemeData(backgroundColor: Colors.blue),
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
    textTheme: TextTheme(
        title: TextStyle(
          color: Colors.black,
          fontSize: 17,
          fontFamily: Font.Name,
          fontWeight: Font.Medium,
        ),
        subtitle: TextStyle(
          color: Colors.black,
          fontSize: 13,
          fontFamily: Font.Name,
          fontWeight: Font.Regular,
        ),
        caption: TextStyle(color: Colors.black, fontSize: 12)),
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    dialogBackgroundColor: Colors.transparent,
    backgroundColor: Color.fromRGBO(34, 34, 34, 1.0),
    scaffoldBackgroundColor: Color.fromRGBO(34, 34, 34, 1.0),
    appBarTheme: AppBarTheme(
      color: Colors.black54,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    primaryColor: Colors.white,
    floatingActionButtonTheme:
        FloatingActionButtonThemeData(backgroundColor: Colors.black),
//    colorScheme: ColorScheme.dark(
//      primary: Colors.white,
//      onPrimary: Colors.black,
//      primaryVariant: Colors.black,
//      secondary: Colors.red,
//    ),

    cardTheme: CardTheme(
      color: Colors.black,
    ),
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
//    focusColor: Colors.black54,
    focusColor: Colors.black12.withOpacity(0.3),
    textTheme: TextTheme(
        title: TextStyle(
          color: Colors.white,
          fontSize: 17.0,
        ),
        subtitle: TextStyle(
          color: Colors.white,
          fontSize: 13.0,
        ),
        caption: TextStyle(color: Colors.white, fontSize: 12)),
  );
}

class AppStateNotifier extends ChangeNotifier {
  //
  bool isDarkMode = false;

  void updateTheme(bool isDarkMode) {
    this.isDarkMode = isDarkMode;
    notifyListeners();
  }
}
