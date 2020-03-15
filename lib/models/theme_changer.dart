import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sid_hymnal/common/shared_theme_data.dart';

import '../main.dart';

class ThemeChanger with ChangeNotifier {
  ThemeChanger();

  ThemeData getTheme() {
    if (globalUserSettings.getNightMode() == "on") {
      return androidCustomDarkTheme;
    } else if (globalUserSettings.getNightMode() == "auto") {
      if (WidgetsBinding.instance.window.platformBrightness == Brightness.dark) {
        return androidCustomDarkTheme;
      } else {
        return androidCustomLightTheme;
      }
    } else {
      return androidCustomLightTheme;
    }
  }

  CupertinoThemeData getCupertinoTheme() {
    if (globalUserSettings.getNightMode() == "on") {
      return iosCustomDarkTheme;
    } else if (globalUserSettings.getNightMode() == "auto") {
      if (WidgetsBinding.instance.window.platformBrightness == Brightness.dark) {
        return iosCustomDarkTheme;
      } else {
        return iosCustomLightTheme;
      }
    } else {
      return iosCustomLightTheme;
    }
  }

  void setNightMode(String nightMode) {
    notifyListeners();
  }

  void notifyChange() {
    notifyListeners();
  }
}
