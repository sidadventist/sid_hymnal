import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:sid_hymnal/common/shared_methods.dart';
import 'package:sid_hymnal/common/shared_prefs.dart';
import 'package:sid_hymnal/models/hymn.dart';
import 'package:sid_hymnal/models/user_settings.dart';
import 'package:sid_hymnal/screens/android/favorites_page.dart';
import 'package:sid_hymnal/screens/android/search_page.dart';
import 'package:sid_hymnal/screens/core/hymn_search.dart';
import 'package:sid_hymnal/screens/core/my_settings.dart';
import '../main.dart';
import 'android/settings_page.dart';
import 'core/hymn_keypad.dart';
import 'core/my_favorites.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BuildContext context;
  bool _isLoading = true;
  bool _isFavorite = false;
  bool _isPlayingAudio = false;
  int _currentHymnNumber = 1;
  Hymn _currentHymnData;
  int currentIndex = 0;

  StreamSubscription<bool> playerStatusListener;
  static final scaffoldKey = new GlobalKey<ScaffoldState>();

  static final GlobalKey<NavigatorState> firstTabNavKey = new GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> secondTabNavKey = new GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> thirdTabNavKey = new GlobalKey<NavigatorState>();

  List<String> choices = <String>["Share", "Mark as Favorite", "Favorites", "Dark Mode", "Settings"];

  selfInit() async {
    //get last viewed hymn

    bool favoriteState = await checkIfFavorite(_currentHymnNumber);
    Hymn hymnData = await Hymn.create(_currentHymnNumber, globalUserSettings.getLanguage());
    setState(() {
      _isFavorite = favoriteState;
      _currentHymnData = hymnData;
      _isLoading = false;
    });
    playerStatusListener = assetsAudioPlayer.isPlaying.listen((isPlaying) {
      if (isPlaying) {
        setState(() {
          this._isPlayingAudio = true;
        });
      } else {
        setState(() {
          this._isPlayingAudio = false;
        });
      }
    });
    loadHymnList();
  }

  @override
  void initState() {
    super.initState();
    selfInit();
  }

  @override
  void dispose() {
    assetsAudioPlayer.stop();
    playerStatusListener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void _selectPopupMenuItem(String choice) {
      switch (choice) {
        case "Share":
          {
            shareSong(_currentHymnData.toString());
          }
          break;
        case "Mark as Favorite":
          {
            callMarkAsFavorite(_currentHymnNumber);
          }
          break;
        case "Favorites":
          {
            callDisplayFavoritesPage(context);
          }
          break;
        case "Settings":
          {
            callDisplaySettingsPage(context);
          }
          break;
        case "Dark Mode":
          {
            toggleNightMode();
          }
          break;
        default:
          {
            print("Invalid choice");
          }
          break;
      }
    }

    return appLayoutMode == "ios"
        ? CupertinoTabScaffold(
            tabBuilder: (BuildContext context, int index) {
              switch (index) {
                case 0:
                  return CupertinoTabView(
                      navigatorKey: firstTabNavKey,
                      builder: (BuildContext context) => CupertinoPageScaffold(
                          backgroundColor: globalUserSettings.isNightMode() ? Colors.black87 : Theme.of(context).scaffoldBackgroundColor,
                          navigationBar: CupertinoNavigationBar(
                            middle: Text("SID Hymnal [${globalUserSettings.getLanguage()}]"),
                            trailing: index == 0
                                ? CupertinoButton(
                                    padding: EdgeInsets.all(0),
                                    child: Icon(IconData(0xf4d2, fontFamily: CupertinoIcons.iconFont, fontPackage: CupertinoIcons.iconFontPackage)),
                                    onPressed: () {
                                      // shareSong(widget._hymn.toString());
                                    },
                                  )
                                : null,
                          ),
                          child: _isLoading == true
                              ? Center(child: CupertinoActivityIndicator())
                              : SafeArea(
                                  child: Scaffold(
                                  body: HymnSearch(globalUserSettings.getLanguage()),
                                ))));
                  break;
                case 1:
                  return CupertinoTabView(
                    navigatorKey: secondTabNavKey,
                    builder: (BuildContext context) => CupertinoPageScaffold(
                        backgroundColor: globalUserSettings.isNightMode() ? Colors.black87 : Theme.of(context).scaffoldBackgroundColor,
                        navigationBar: CupertinoNavigationBar(
                          middle: Text("Favorites"),
                          trailing: index == 0
                              ? CupertinoButton(
                                  padding: EdgeInsets.all(0),
                                  child: Icon(IconData(0xf4d2, fontFamily: CupertinoIcons.iconFont, fontPackage: CupertinoIcons.iconFontPackage)),
                                  onPressed: () {
                                    // shareSong(widget._hymn.toString());
                                  },
                                )
                              : null,
                        ),
                        child: _isLoading == true
                            ? Center(child: CupertinoActivityIndicator())
                            : SafeArea(
                                child: Scaffold(
                                body: MyFavorites(),
                              ))),
                  );
                  break;
                case 2:
                  return CupertinoPageScaffold(
                      backgroundColor: globalUserSettings.isNightMode() ? Colors.black87 : Theme.of(context).scaffoldBackgroundColor,
                      navigationBar: CupertinoNavigationBar(
                        middle: Text("Settings"),
                        trailing: index == 0
                            ? CupertinoButton(
                                padding: EdgeInsets.all(0),
                                child: Icon(IconData(0xf4d2, fontFamily: CupertinoIcons.iconFont, fontPackage: CupertinoIcons.iconFontPackage)),
                                onPressed: () {
                                  // shareSong(widget._hymn.toString());
                                },
                              )
                            : null,
                      ),
                      child: _isLoading == true
                          ? Center(child: CupertinoActivityIndicator())
                          : SafeArea(
                              child: Scaffold(
                              body: MySettings(thirdTabNavKey),
                            )));
                  break;
              }
              return null;
            },
            /*
            tabBuilder: (BuildContext context, int index) {
              return CupertinoTabView(
                
                builder: (BuildContext context) {
                  return CupertinoPageScaffold(
                      backgroundColor: globalUserSettings.isNightMode() ? Colors.black87 : Theme.of(context).scaffoldBackgroundColor,
                      navigationBar: CupertinoNavigationBar(
                        middle: Text(index == 0 ? "SID Hymnal" : index == 1 ? "Favorites" : "Settings"),
                        trailing: index == 0
                            ? CupertinoButton(
                                padding: EdgeInsets.all(0),
                                child: Icon(IconData(0xf4d2, fontFamily: CupertinoIcons.iconFont, fontPackage: CupertinoIcons.iconFontPackage)),
                                onPressed: () {
                                  // shareSong(widget._hymn.toString());
                                },
                              )
                            : null,
                      ),
                      child: _isLoading == true
                          ? Center(child: CupertinoActivityIndicator())
                          : SafeArea(
                              child: Scaffold(
                                  body: index == 0 ? HymnSearch(globalUserSettings.getLanguage()) : index == 1 ? MyFavorites() : MySettings(scaffoldKey)),
                            ));
                },
              );
            },
            
            */
            tabBar: CupertinoTabBar(
              items: [
                BottomNavigationBarItem(icon: Icon(CupertinoIcons.book), title: Text("Hymns"), activeIcon: Icon(CupertinoIcons.book_solid)),
                BottomNavigationBarItem(icon: Icon(CupertinoIcons.heart), title: Text("Favorites"), activeIcon: Icon(CupertinoIcons.heart_solid)),
                BottomNavigationBarItem(icon: Icon(CupertinoIcons.settings), title: Text("Settings"), activeIcon: Icon(CupertinoIcons.settings_solid))
              ],
              onTap: (index) {
                /* if (currentIndex == index) { */
                switch (index) {
                  case 0:
                    if (firstTabNavKey.currentState != null) {
                      firstTabNavKey.currentState.popUntil((r) => r.isFirst);
                    }
                    break;
                  case 1:
                    if (secondTabNavKey.currentState != null) {
                      secondTabNavKey.currentState.popUntil((r) => r.isFirst);
                    }
                    break;
                  case 2:
                    if (thirdTabNavKey.currentState != null) {
                      thirdTabNavKey.currentState.popUntil((r) => r.isFirst);
                    }
                    break;
                }
                /*}
                currentIndex = index;*/
              },
            ),
          )
        : Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text("SID Hymnal"),
              actions: <Widget>[
                IconButton(
                  icon: this._isPlayingAudio == true ? Icon(Icons.stop) : Icon(Icons.play_arrow),
                  onPressed: this._currentHymnData != null && this._currentHymnData.hasAudio()
                      ? () {
                          if (this._isPlayingAudio) {
                            assetsAudioPlayer.stop();
                          } else {
                            assetsAudioPlayer.stop();
                            assetsAudioPlayer.open(this._currentHymnData.getAudioPath());
                          }
                        }
                      : null,
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: hymnList.length < 1
                      ? null
                      : () async {
                          int newNumber = await displaySearchPage(context, globalUserSettings.getLanguage());
                          if (newNumber < 1) {
                            return;
                          }
                          _currentHymnNumber = newNumber;
                          renderHymn();
                        },
                ),
                PopupMenuButton<String>(
                  onCanceled: () {
                    print('No selection!');
                  },
                  onSelected: _selectPopupMenuItem,
                  itemBuilder: (BuildContext context) {
                    return choices.map((String choice) {
                      switch (choice) {
                        case "Dark Mode":
                          return PopupMenuItem<String>(
                            value: choice,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[Text(choice), Checkbox(activeColor: Colors.green, value: globalUserSettings.isNightMode(), onChanged: null)],
                            ),
                          );
                          break;
                        case "Mark as Favorite":
                          return _isFavorite
                              ? null
                              : PopupMenuItem<String>(
                                  value: choice,
                                  child: Text(choice),
                                );
                          break;
                        default:
                          return PopupMenuItem<String>(
                            value: choice,
                            child: Text(choice),
                          );
                      }
                    }).toList();
                  },
                )
              ],
            ),
            backgroundColor: globalUserSettings.isNightMode() ? Colors.black87 : Theme.of(context).scaffoldBackgroundColor,
            drawer: Drawer(
                child: new ListView(children: <Widget>[
              ListTile(
                title: Text("SID Hymnal", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                subtitle: Text("English", style: TextStyle(color: Color(0Xff2f557f))),
              ),
            ])),
            body: _isLoading == true
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Markdown(
                    data: this._currentHymnData.outputMarkdown(),
                    styleSheet: MarkdownStyleSheet(
                      h2: TextStyle(
                          color: globalUserSettings.isNightMode() ? Colors.white : Colors.black, fontSize: (globalUserSettings.getFontSize() + 7).toDouble()),
                      p: TextStyle(
                          color: globalUserSettings.isNightMode() ? Colors.white : Colors.black, fontSize: (globalUserSettings.getFontSize()).toDouble()),
                      blockSpacing: globalUserSettings.getFontSize().toDouble(),
                    ),
                  ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Color(0Xff2f557f),
              child: Icon(Icons.dialpad),
              onPressed: () async {
                int newNumber = await displayHymnKeypad(context);
                if (newNumber < 1) {
                  return;
                }
                _currentHymnNumber = newNumber;
                renderHymn();
              },
            ),
          );
  }

  callDisplayFavoritesPage(context) async {
    int newNumber = await displayFavoritesPage(context);
    bool favoriteState = await checkIfFavorite(_currentHymnNumber);
    if (newNumber < 1) {
      setState(() {
        _isFavorite = favoriteState;
      });
      return;
    }
    _currentHymnNumber = newNumber;
    renderHymn();
  }

  callDisplaySettingsPage(context) async {
    await displaySettingsPage(context);
    //update current font size. At the moment its the only setting that is mutable, so we can just refresh it here
    int currentFontSize = await getIntDataLocally(key: "fontSize");
    if (currentFontSize == null) {
      currentFontSize = 18;
    }
    setState(() {
      globalUserSettings.setFontSize(currentFontSize);
    });
    renderHymn();
  }

  callMarkAsFavorite(int hymnNumber) async {
    await markAsFavorite(_currentHymnNumber);
    bool favoriteState = await checkIfFavorite(_currentHymnNumber);
    setState(() {
      _isFavorite = favoriteState;
    });
  }

  renderHymn() async {
    saveLastHymn(this._currentHymnNumber);
    bool favoriteState = await checkIfFavorite(this._currentHymnNumber);
    Hymn hymnData = await Hymn.create(this._currentHymnNumber, globalUserSettings.getLanguage());
    assetsAudioPlayer.stop();
    setState(() {
      this._isPlayingAudio = false;
      this._isFavorite = favoriteState;
      this._currentHymnData = hymnData;
    });
  }

  toggleNightMode() {
    setState(() {
      globalUserSettings.setNightMode(!globalUserSettings.isNightMode());
    });
    saveNightModeState(globalUserSettings.isNightMode());
  }

  loadHymnList() async {
    String rawMeta = await rootBundle.loadString('assets/hymns/${globalUserSettings.getLanguage()}/meta.json');
    List tmpList = new List();

    Map<dynamic, dynamic> songList = json.decode(rawMeta)['songs'];
    for (int i = 1; i < (songList.keys.length + 1); i++) {
      if (songList["$i"] == null) {
        throw ("Missing hymn $i from meta file");
      }
      tmpList.add("$i" + ". " + songList["$i"]);
    }
    setState(() {
      hymnList = tmpList;
    });
  }
}
