import 'package:flutter/material.dart';
import 'package:sid_hymnal/common/shared_methods.dart';
import 'package:sid_hymnal/models/hymnal.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';

class MyLanguages extends StatefulWidget {
  final scaffoldKey;
  MyLanguages(this.scaffoldKey);
  @override
  _MyLanguagesState createState() => _MyLanguagesState();
}

class _MyLanguagesState extends State<MyLanguages> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: globalLanguageList.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == globalLanguageList.length) {
            return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Divider(),
              FlatButton(
                  child: Text("Can't find your language? Request translation here"),
                  onPressed: () async {
                    String url = "https://github.com/sidadventist/sid_hymnal/issues/new";
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      showSnackBar("Failed to launch link", widget.scaffoldKey);
                    }
                  })
            ]);
          }
          Hymnal hymnal = globalLanguageList[globalLanguageList.keys.toList()[index]];
          return RadioListTile(
            value: hymnal.languageCode,
            groupValue: globalUserSettings.getLanguage(),
            title: Text(hymnal.language, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            subtitle: Text(hymnal.title),
            onChanged: (language) async {
              await globalUserSettings.setLanguage(language);
              Navigator.pop(context);
            },
          );
        });
  }
}
