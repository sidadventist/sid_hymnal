import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sid_hymnal/common/shared_methods.dart';
import 'package:sid_hymnal/main.dart';
import 'package:sid_hymnal/screens/ios/view_hymn.dart';

import 'favorites_menu.dart';

class MyFavorites extends StatefulWidget {
  @override
  _MyFavoritesState createState() => _MyFavoritesState();
}

class _MyFavoritesState extends State<MyFavorites> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: FutureBuilder<List<dynamic>>(
            future: getFavoriteHymns(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print(snapshot.error);
              }
              return snapshot.hasData
                  ? snapshot.data.length < 1
                      ? Container(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            "No favorites yet",
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : new ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              title: Text(
                                hymnList[snapshot.data[index] - 1],
                              ),
                              onLongPress: () async {
                                await displayFavoritesContextMenu(context, snapshot.data[index]);
                                setState(() {});
                              },
                              onTap: () {
                                if (appLayoutMode == "ios") {
                                  launchIOSHymnView(snapshot.data[index]);
                                  return;
                                }
                                Navigator.pop(context, snapshot.data[index]);
                              },
                            );
                          },
                        )
                  : Center(
                      child: appLayoutMode == "ios" ? CupertinoActivityIndicator() : CircularProgressIndicator(),
                    );
            }));
  }

  launchIOSHymnView(int hymnNumber) async {
    // Hymn hymnData = await Hymn.create(hymnNumber, globalUserSettings.getLanguage());
    Navigator.of(context).push(
      new CupertinoPageRoute<bool>(
        builder: (BuildContext context) => new ViewHymn(hymnNumber),
      ),
    );
  }
}
