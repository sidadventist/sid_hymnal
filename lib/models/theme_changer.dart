import 'package:flutter/material.dart';
import 'package:sid_hymnal/common/shared_theme_data.dart';

class ThemeChanger with ChangeNotifier {
  ThemeData _themeData;

  ThemeChanger(this._themeData);

  ThemeData getTheme() => _themeData;
  setTheme(String nightMode) {
    if (nightMode == "on") {
      _themeData = androidCustomDarkTheme;
    } else {
      _themeData = androidCustomLightTheme;
    }
    notifyListeners();
  }
  /*
  setTheme(ThemeData theme) {
    _themeData = theme;

    notifyListeners();
  }
  */
}
