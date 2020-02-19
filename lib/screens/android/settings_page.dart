import 'package:flutter/material.dart';
import 'package:sid_hymnal/screens/core/my_settings.dart';

class SettingsPage extends StatelessWidget {
  static final scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text("Settings"),
        ),
        body: MySettings(scaffoldKey));
  }
}

Future<int> displaySettingsPage(BuildContext context) async {
  var res = await Navigator.of(context).push(new PageRouteBuilder(pageBuilder: (BuildContext context, _, __) {
    return new SettingsPage();
  }));
  if (res != null && res > 0) {
    return res;
  }
  return 0;
}
