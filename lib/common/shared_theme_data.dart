import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final CupertinoThemeData iosCustomDarkTheme = CupertinoThemeData(
    primaryColor: Color(0Xff34a0ff), //Color(0Xff2f557f)
    scaffoldBackgroundColor: Colors.black,
    textTheme: CupertinoTextThemeData(textStyle: TextStyle(color: Colors.white)));

final CupertinoThemeData iosCustomLightTheme = CupertinoThemeData(
  primaryColor: Color(0Xff2f557f),
);

final androidCustomDarkTheme = ThemeData(
  primarySwatch: Colors.indigo,
  primaryColor: Color(0Xff2f557f),
  brightness: Brightness.dark,
);

final androidCustomLightTheme = ThemeData(
  primarySwatch: Colors.indigo,
  primaryColor: Color(0Xff2f557f),
  brightness: Brightness.light,
);
