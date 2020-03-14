import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:sid_hymnal/common/shared_prefs.dart';
import 'package:sid_hymnal/models/hymnal.dart';
import 'package:sid_hymnal/models/theme_changer.dart';
import 'package:sid_hymnal/models/user_settings.dart';
import '../main.dart';

Future<Map<String, Hymnal>> getAvailableLanguages() async {
  Map<String, Hymnal> hymnals = {};

  hymnals.putIfAbsent("en", () => Hymnal("SID Hymnal", "English", "en"));
  String rawList = await rootBundle.loadString('assets/translations.json');
  List translations = json.decode(rawList);

  String rawSupportedLanguages = await rootBundle.loadString('assets/iso_639_1.json');
  Map supportedLanguages = json.decode(rawSupportedLanguages);

  translations.forEach((translation) async {
    if (supportedLanguages.containsKey(translation)) {
      String rawHymnalMetadata = await rootBundle.loadString('assets/hymns/$translation/meta.json');
      Map hymnalMetadata = json.decode(rawHymnalMetadata);
      hymnals.putIfAbsent(translation, () => new Hymnal(hymnalMetadata['title'], supportedLanguages[translation], translation));
    }
  });

  return hymnals;
}

Future<UserSettings> getUserSettings() async {
  UserSettings userSettings = new UserSettings();

  int currentHymnNumber = await getIntDataLocally(key: "lastViewed");
  if (currentHymnNumber == null) {
    currentHymnNumber = 1;
  }
  String nightMode = await getDataLocally(key: "nightMode");

  if (nightMode == null) {
    nightMode = "auto";
  }

  //get currentFontSize
  int currentFontSize = await getIntDataLocally(key: "fontSize");

  if (currentFontSize == null) {
    currentFontSize = 18;
  }
  //get language
  String currentLanguage = await getStringDataLocally(key: "language");

  if (currentLanguage == null) {
    currentLanguage = "en";
  }

  userSettings.setFontSize(currentFontSize);
  userSettings.setLanguage(currentLanguage);
  userSettings.setNightMode(nightMode);
  userSettings.setLastHymnNumber(currentHymnNumber);

  return userSettings;
}

String padHymnNumber(int hymnNumber) {
  return hymnNumber.toString().padLeft(3, '0');
}

saveLastHymn(int hymnNumber) {
  writeIntDataLocally(key: "lastViewed", value: hymnNumber);
}

saveLastLanguage(String languageCode) {
  writeStringDataLocally(key: "language", value: languageCode);
}

saveNightModeState(String nightModeSetting) {
  writeDataLocally(key: "nightMode", value: nightModeSetting);
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

Future<List> getHymnList() async {
  String rawMeta = await rootBundle.loadString('assets/hymns/${globalUserSettings.getLanguage()}/meta.json');
  List<String> tmpList = new List();

  Map<dynamic, dynamic> songList = json.decode(rawMeta)['songs'];
  for (int i = 1; i < (songList.keys.length + 1); i++) {
    if (songList["$i"] == null) {
      throw ("Missing hymn $i from meta file");
    }
    tmpList.add("$i" + ". " + songList["$i"]);
  }

  return tmpList;
}

Future<Map<dynamic, dynamic>> getCIStoAH() async {
  String rawMeta = await rootBundle.loadString('assets/cis-ah.json');

  Map<dynamic, dynamic> songList = json.decode(rawMeta);

  return songList;
}

Future<void> showDarkModeOptions(BuildContext context) async {
  final theme = Provider.of<ThemeChanger>(context);
  List<String> darkModeOptions = ["auto", "on", "off"];
  if (appLayoutMode == "ios") {
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Text("Dark Mode"),
          actions: List<Widget>.generate(darkModeOptions.length, (int index) {
            return CupertinoActionSheetAction(
              child: Text("${darkModeOptions[index].substring(0, 1).toUpperCase()}${darkModeOptions[index].substring(1, darkModeOptions[index].length)}"),
              isDefaultAction: globalUserSettings.getNightMode() == darkModeOptions[index] ? true : false,
              onPressed: () {
                globalUserSettings.setNightMode(darkModeOptions[index]);
                theme.setTheme(darkModeOptions[index]);
                Navigator.of(context).pop(true);
              },
            );
          }),
        );
      },
    );
  } else {
    await showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
        return Center(
            child: Padding(
                padding: EdgeInsets.all(16),
                child: Material(
                  child: Container(
                      child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new ListView.builder(
                        shrinkWrap: true,
                        itemCount: darkModeOptions.length,
                        itemBuilder: (BuildContext context, int index) {
                          return RadioListTile(
                              title: Text(
                                  "${darkModeOptions[index].substring(0, 1).toUpperCase()}${darkModeOptions[index].substring(1, darkModeOptions[index].length)}"),
                              groupValue: globalUserSettings.getNightMode(),
                              value: darkModeOptions[index],
                              onChanged: (value) async {
                                globalUserSettings.setNightMode(darkModeOptions[index]);
                                theme.setTheme(darkModeOptions[index]);
                                Navigator.of(context).pop(true);
                              });
                        },
                      ),
                    ],
                  )),
                )));
      },
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 200),
    );
  }
}

Future<void> showLanguageActions(BuildContext context) async {
  await showCupertinoModalPopup<void>(
    context: context,
    builder: (BuildContext context) {
      return CupertinoActionSheet(
        title: Text("Switch Language"),
        actions: List<Widget>.generate(globalLanguageList.length, (int index) {
          return CupertinoActionSheetAction(
            child: Text(globalLanguageList[globalLanguageList.keys.toList()[index]].language),
            isDefaultAction: globalUserSettings.getLanguage() == globalLanguageList[globalLanguageList.keys.toList()[index]].languageCode ? true : false,
            onPressed: () {
              globalUserSettings.setLanguage(globalLanguageList[globalLanguageList.keys.toList()[index]].languageCode);
              Navigator.of(context).pop(true);
            },
          );
        }),
      );
    },
  );
}
