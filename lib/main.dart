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
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:note_app/application/app_localizations.dart';
import 'package:note_app/application/constants.dart';
import 'package:note_app/application/router.dart';

import 'package:note_app/presentations/UI/page/home_screen.dart';

import 'package:note_app/utils/database/database.dart';



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
    DatabaseApp db = new DatabaseApp();
    return MaterialApp(
      title: "Note App",
      debugShowCheckedModeBanner: false,
      supportedLocales: [
        const Locale('en'), // English
        const Locale('vi'), // VietNamese
      ],
      // These delegates make sure that the localization data for the proper language is loaded
      localizationsDelegates: [
        // THIS CLASS WILL BE ADDED LATER
        // A class which loads the translations from JSON files
        AppLocalizations.delegate,
        // Built-in localization of basic text for Material widgets
        GlobalMaterialLocalizations.delegate,
        // Built-in localization for text direction LTR/RTL
        GlobalWidgetsLocalizations.delegate,
      ],
      // Returns a locale which will be used by the app
      localeResolutionCallback: (locale, supportedLocales) {
        // Check if the current device locale is supported
        print("Locale:");
        print(locale);
        if (locale == null) {
          return supportedLocales.first;
        }

        print("Supported Locale list:");
        for (var supportedLocale in supportedLocales) {
          print(supportedLocale);
          if (supportedLocale.languageCode == locale.languageCode) {
            return supportedLocale;
          }
        }
        // If the locale of the device is not supported, use the first one
        // from the list (English, in this case).
        return supportedLocales.first;
      },

      theme: ThemeData(),
//      initialRoute: RoutePaths.Pick_image,
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

