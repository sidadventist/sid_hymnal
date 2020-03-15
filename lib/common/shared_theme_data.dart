import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sid_hymnal/main.dart';

final CupertinoThemeData iosCustomDarkTheme = CupertinoThemeData(
    primaryColor: CupertinoColors.systemBlue, //Color(0Xff2f557f)
    textTheme: CupertinoTextThemeData(textStyle: TextStyle(color: Colors.white)),
    brightness: Brightness.dark);

final CupertinoThemeData iosCustomLightTheme = CupertinoThemeData(
    primaryColor: Color(0Xff2f557f), // ALPS
    brightness: Brightness.light);

final androidCustomDarkTheme = ThemeData(
  primarySwatch: Colors.indigo,
  primaryColor: appLayoutMode == "ios" ? Color(0Xff34a0ff) : Color(0Xff2f557f),
  scaffoldBackgroundColor: Color(0Xff212121),
  brightness: Brightness.dark,
);

final androidCustomLightTheme = ThemeData(
  primarySwatch: Colors.indigo,
  primaryColor: Color(0Xff2f557f),
  brightness: Brightness.light,
);
