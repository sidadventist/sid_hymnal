import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sid_hymnal/common/shared_methods.dart';
import 'package:sid_hymnal/common/shared_theme_data.dart';
import 'package:sid_hymnal/models/user_settings.dart';
import 'package:sid_hymnal/screens/homepage.dart';
import 'dart:io' show Platform;
import 'package:audioplayers/audio_cache.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'models/hymnal.dart';
import 'models/theme_changer.dart';

List<String> hymnList = new List();
Map<String, dynamic> cIStoAH = {};
Map<String, Hymnal> globalLanguageList = {};
String appLayoutMode = "android";
UserSettings globalUserSettings;
Brightness platformBrightness = Brightness.light;
final audioPlayer = AudioCache();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.verbose);
  OneSignal.shared.init("cc96c7d7-2a82-4378-a13f-376eacd31540", iOSSettings: {OSiOSSettings.autoPrompt: true, OSiOSSettings.inAppLaunchUrl: true});
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
  @override
  Widget build(BuildContext context) {
    print(globalUserSettings.toString());

    return ChangeNotifierProvider<ThemeChanger>(
      builder: (_) => ThemeChanger(globalUserSettings.getNightMode() == "on" ? androidCustomDarkTheme : androidCustomLightTheme),
      child: new AppWithTheme(),
    );
  }
}

class AppWithTheme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);

    return Platform.isIOS
        ? CupertinoApp(
            title: 'SID Hymnal',
            debugShowCheckedModeBanner: false,
            // theme: theme.getTheme(),
            home: HomePage(),
          )
        : MaterialApp(
            title: 'SID Hymnal',
            debugShowCheckedModeBanner: false,
            theme: theme.getTheme(),
            home: HomePage(),
          );
  }
}
