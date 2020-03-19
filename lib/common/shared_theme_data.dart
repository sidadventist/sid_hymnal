import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:sid_hymnal/main.dart';

final CupertinoThemeData iosCustomDarkTheme = CupertinoThemeData(
    primaryColor: CupertinoColors.systemBlue, //Color(0Xff2f557f)
    textTheme: CupertinoTextThemeData(textStyle: TextStyle(color: Colors.white)),
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Color(0Xff212121));

final CupertinoThemeData iosCustomLightTheme = CupertinoThemeData(
  primaryColor: Color(0Xff2f557f), // ALPS
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
);

final androidCustomDarkTheme = ThemeData(
  primarySwatch: Colors.indigo,
  primaryColor: appLayoutMode == "ios" ? CupertinoColors.systemBlue : Color(0Xff2f557f),
  scaffoldBackgroundColor: Color(0Xff212121),
  accentColor: appLayoutMode == "ios" ? CupertinoColors.systemBlue : Colors.blueAccent,
  brightness: Brightness.dark,
);

final androidCustomLightTheme = ThemeData(
  primarySwatch: Colors.indigo,
  primaryColor: Color(0Xff2f557f),
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
);

MarkdownStyleSheet sharedMarkdownStyleSheet(Color textColor) {
  return MarkdownStyleSheet(
    h2: TextStyle(color: textColor, fontSize: (globalUserSettings.getFontSize() * 1.4).toDouble()),
    p: TextStyle(color: textColor, fontSize: (globalUserSettings.getFontSize()).toDouble()),
    code: TextStyle(
        color: textColor,
        backgroundColor: textColor == Colors.white ? Colors.grey[700] : Colors.grey[200],
        fontSize: globalUserSettings.getFontSize() * 0.8,
        fontWeight: FontWeight.bold,
        fontFamily: "Courier New"),
    blockSpacing: globalUserSettings.getFontSize().toDouble(),
  );
}
