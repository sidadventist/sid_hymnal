import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:sid_hymnal/common/shared_prefs.dart';
import 'package:sid_hymnal/models/user_settings.dart';

Future<UserSettings> getUserSettings() async {
  UserSettings userSettings = new UserSettings();

  int currentHymnNumber = await getIntDataLocally(key: "lastViewed");
  if (currentHymnNumber == null) {
    currentHymnNumber = 1;
  }
  bool isNightMode = await getBoolDataLocally(key: "isNightMode");

  if (isNightMode == null) {
    isNightMode = false;
  }

  //get currentFontSize
  int currentFontSize = await getIntDataLocally(key: "fontSize");

  if (currentFontSize == null) {
    currentFontSize = 18;
  }

  userSettings.setFontSize(currentFontSize);
  userSettings.setLanguage("en");
  userSettings.setNightMode(isNightMode);
  userSettings.setLastHymnNumber(currentHymnNumber);


  return userSettings;
}

String padHymnNumber(int hymnNumber) {
  return hymnNumber.toString().padLeft(3, '0');
}

saveLastHymn(int hymnNumber) {
  writeIntDataLocally(key: "lastViewed", value: hymnNumber);
}

saveNightModeState(bool isNightMode) {
  writeBoolDataLocally(key: "isNightMode", value: isNightMode);
}

shareSong(String song) {
  Share.share(song);
}

showSnackBar(String message, GlobalKey<ScaffoldState> scaffoldKey) {
  scaffoldKey.currentState.showSnackBar(new SnackBar(
    content: new Text(message),
  ));
}

markAsFavorite(int hymnNumber) async {
  List currentFavorites = new List();
  try {
    String rawList = await getStringDataLocally(key: "favorites");
    currentFavorites = json.decode(rawList);
    if (!currentFavorites.contains(hymnNumber)) {
      currentFavorites.add(hymnNumber);
    }
  } catch (e) {
    currentFavorites.add(hymnNumber);
  }
  writeStringDataLocally(key: "favorites", value: json.encode(currentFavorites));
}

unmarkAsFavorite(int hymnNumber) async {
  List currentFavorites = new List();
  try {
    String rawList = await getStringDataLocally(key: "favorites");
    currentFavorites = json.decode(rawList);
    currentFavorites.remove(hymnNumber);
  } catch (e) {}
  writeStringDataLocally(key: "favorites", value: json.encode(currentFavorites));
}

Future<bool> checkIfFavorite(int hymnNumber) async {
  List currentFavorites = new List();
  try {
    String rawList = await getStringDataLocally(key: "favorites");
    currentFavorites = json.decode(rawList);
    if (currentFavorites.contains(hymnNumber)) {
      return true;
    }
  } catch (e) {}
  return false;
}

Future<List<dynamic>> getFavoriteHymns() async {
  List currentFavorites = new List();
  try {
    String rawList = await getStringDataLocally(key: "favorites");
    currentFavorites = json.decode(rawList);
  } catch (e) {}
  return currentFavorites.reversed.toList();
}
