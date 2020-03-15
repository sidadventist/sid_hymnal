import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_version/get_version.dart';
import 'package:sid_hymnal/common/shared_prefs.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sid_hymnal/common/shared_methods.dart';

import '../../main.dart';

class MySettings extends StatefulWidget {
  final scaffoldKey;
  MySettings(this.scaffoldKey);
  @override
  _MySettingsState createState() => _MySettingsState();
}

class _MySettingsState extends State<MySettings> {
  String _version = "";

  @override
  void initState() {
    super.initState();
    getAppVersion();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 16, top: 16),
            child: Text(
              "General",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
            ),
          ),
          appLayoutMode == "ios" ? Divider() : Container(),
          ListTile(
            leading: appLayoutMode == "ios" ? Icon(CupertinoIcons.gear) : Icon(Icons.font_download),
            title: Text("Font Size: ${globalUserSettings.getFontSize()}"),
            //subtitle: Text("Set the font size in hymn view"),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 20, left: 20, right: 20),
            child: Row(
              children: <Widget>[
                Text(
                  "A",
                  style: TextStyle(fontSize: 14),
                ),
                Expanded(
                  child: appLayoutMode == "ios"
                      ? CupertinoSlider(
                          value: globalUserSettings.getFontSize().toDouble(),
                          min: 14,
                          max: 30,
                          divisions: 6,
                          onChanged: (value) {
                            writeIntDataLocally(key: "fontSize", value: value.toInt());
                            setState(() {
                              globalUserSettings.setFontSize(value.toInt());
                            });
                          },
                        )
                      : Slider(
                          value: globalUserSettings.getFontSize().toDouble(),
                          min: 14,
                          max: 30,
                          divisions: 6,
                          onChanged: (value) {
                            writeIntDataLocally(key: "fontSize", value: value.toInt());
                            setState(() {
                              globalUserSettings.setFontSize(value.toInt());
                            });
                          },
                        ),
                ),
                Text(
                  "A",
                  style: TextStyle(fontSize: 20),
                )
              ],
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(appLayoutMode == "ios" ? CupertinoIcons.brightness : Icons.brightness_medium),
            title: Text("Dark Mode"),
            subtitle: Text(
                "${globalUserSettings.getNightMode().substring(0, 1).toUpperCase()}${globalUserSettings.getNightMode().substring(1, globalUserSettings.getNightMode().length)}"),
            onTap: () async {
              await showDarkModeOptions(context);
              setState(() {});
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(appLayoutMode == "ios" ? CupertinoIcons.book : Icons.book),
            title: Text("English Hymnal Version"),
            subtitle: Text("Christ in Song"),
            onTap: () async {},
          ),
          Divider(),
          ListTile(
            leading: appLayoutMode == "ios" ? Icon(CupertinoIcons.bell) : Icon(Icons.notifications),
            trailing: appLayoutMode == "ios"
                ? CupertinoSwitch(
                    value: true,
                    onChanged: null,
                  )
                : Checkbox(value: true, onChanged: null),
            title: Text("SID Announcements"),
            subtitle: Text("Get notified on SID events/announcements"),
          ),
          Divider(),
          Container(
            padding: EdgeInsets.only(left: 16, top: 16),
            child: Text(
              "App Info",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
            ),
          ),
          appLayoutMode == "ios" ? Divider() : Container(),
          ListTile(
            leading: appLayoutMode == "ios" ? Icon(CupertinoIcons.info) : Icon(Icons.info),
            title: Text("Version"),
            subtitle: Text(_version),
          ),
          appLayoutMode == "ios" ? Divider() : Container(),
          ListTile(
            leading: appLayoutMode == "ios" ? Icon(CupertinoIcons.circle) : Icon(Icons.copyright),
            title: Text("Copyright"),
            subtitle: Text("View copyright information"),
            onTap: () async {
              String url = "https://github.com/sidadventist/sid_hymnal/blob/master/COPYRIGHT.md";
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                showSnackBar("Failed to launch link", widget.scaffoldKey);
              }
            },
          ),
          appLayoutMode == "ios" ? Divider() : Container(),
          ListTile(
            leading: appLayoutMode == "ios" ? Icon(CupertinoIcons.news) : Icon(Icons.library_books),
            title: Text("Privacy Policy"),
            subtitle: Text("View the privacy policy"),
            onTap: () async {
              String url = "https://github.com/sidadventist/sid_hymnal/blob/master/PRIVACY.md";
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                showSnackBar("Failed to launch link", widget.scaffoldKey);
              }
            },
          ),
          Divider(),
          Container(
            padding: EdgeInsets.only(left: 16, top: 16),
            child: Text(
              "Advanced",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
            ),
          ),
          appLayoutMode == "ios" ? Divider() : Container(),
          ListTile(
            leading: appLayoutMode == "ios" ? Icon(CupertinoIcons.flag) : Icon(Icons.report),
            title: Text("Feedback"),
            subtitle: Text("Send feedback"),
            onTap: () async {
              String url = "https://github.com/sidadventist/sid_hymnal/issues/new";
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                showSnackBar("Failed to launch link", widget.scaffoldKey);
              }
            },
          ),
          appLayoutMode == "ios" ? Divider() : Container(),
          ListTile(
            leading: appLayoutMode == "ios" ? Icon(CupertinoIcons.heart_solid, color: Colors.redAccent) : Icon(Icons.favorite, color: Colors.redAccent),
            title: Text("Contribute"),
            subtitle: Text("Join the SID Hymnal development"),
            onTap: () async {
              String url = "https://github.com/sidadventist/sid_hymnal/blob/master/CONTRIBUTING.md";
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                showSnackBar("Failed to launch link", widget.scaffoldKey);
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> getAppVersion() async {
    try {
      String vers = await GetVersion.projectVersion;
      setState(() {
        _version = vers;
      });
    } catch (e) {
      _version = 'Unknown';
    }
  }
}
