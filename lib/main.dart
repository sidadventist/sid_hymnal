import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sid_hymnal/common/shared_methods.dart';
import 'package:sid_hymnal/models/user_settings.dart';
import 'package:sid_hymnal/screens/homepage.dart';
import 'dart:io' show Platform;
import 'package:audioplayers/audio_cache.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'models/hymnal.dart';

List<String> hymnList = new List();
Map<String, dynamic> cIStoAH = {};
Map<String, Hymnal> globalLanguageList = {};
String appLayoutMode = "android";
UserSettings globalUserSettings;
final audioPlayer = AudioCache();
const kPickerItemHeight = 32.0;



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.verbose);
  OneSignal.shared.init(
    "cc96c7d7-2a82-4378-a13f-376eacd31540",
    iOSSettings: {
      OSiOSSettings.autoPrompt: true,
      OSiOSSettings.inAppLaunchUrl: true
    }
  );
  OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);
  globalUserSettings = await getUserSettings();
  globalLanguageList = await getAvailableLanguages();
  // appLayoutMode = "ios";
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
              primaryColor: Color(0Xff2f557f),
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
