import 'package:camera/camera.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/application/constants.dart';
import 'package:note_app/application/router.dart';
import 'package:note_app/presentations/UI/page/base_view.dart';

import 'package:note_app/presentations/UI/page/home_screen.dart';
import 'package:note_app/utils/bus/thumbnail_bus.dart';

import 'package:note_app/utils/database/database.dart';
import 'package:note_app/utils/model/note.dart';
import 'package:note_app/utils/model/thumbnailNote.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
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
//      builder: (context) => ChangeNotifierProvider<AppStateNotifier>(
//          create: (context) => AppStateNotifier(), child: MyApp()),
//    ),
//  );
}

class MyApp extends StatelessWidget {
  DatabaseApp db = new DatabaseApp();

  @override
  Widget build(BuildContext context) {
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
            initialRoute: RoutePaths.Home,
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
    appBarTheme: AppBarTheme(
      color: Color.fromRGBO(255, 209, 16, 1.0),
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
    ),
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

    floatingActionButtonTheme:
        FloatingActionButtonThemeData(backgroundColor: Colors.black),

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
  bool isDarkMode = false;
  void updateTheme(bool isDarkMode) {
    this.isDarkMode = isDarkMode;
    notifyListeners();
  }
}
