import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sid_hymnal/common/shared_methods.dart';
import 'package:sid_hymnal/models/user_settings.dart';
import 'package:sid_hymnal/screens/homepage.dart';
import 'dart:io' show Platform;

List hymnList = new List();
final assetsAudioPlayer = AssetsAudioPlayer();
String appLayoutMode = "android";
UserSettings globalUserSettings;

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
  globalUserSettings = await getUserSettings();
  //appLayoutMode = "ios";
  if (Platform.isIOS) {
    appLayoutMode = "ios";
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoApp(
            title: 'SID Hymnal',
            debugShowCheckedModeBanner: false,
            theme: CupertinoThemeData(
              primaryColor: Colors.indigo,
            ),
            home: HomePage(),
          )
        : MaterialApp(
            title: 'SID Hymnal',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.indigo,
              primaryColor: Color(0Xff2f557f),
            ),
            home: HomePage(),
          );
  }
}
