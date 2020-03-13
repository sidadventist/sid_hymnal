import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:sid_hymnal/common/shared_methods.dart';
import 'package:sid_hymnal/common/shared_prefs.dart';
import 'package:sid_hymnal/models/hymn.dart';
import 'package:sid_hymnal/screens/android/favorites_page.dart';
import 'package:sid_hymnal/screens/android/search_page.dart';
import 'package:sid_hymnal/screens/core/hymn_search.dart';
import 'package:sid_hymnal/screens/core/my_settings.dart';
import '../main.dart';
import 'android/languages_page.dart';
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
  Hymn _currentHymn;
  Map<int, Hymn> _pages = {};
  PageController _controller;
  int currentIndex = 0;
  AudioPlayer audioPlayerInstance;

  static final scaffoldKey = new GlobalKey<ScaffoldState>();
  static final GlobalKey<NavigatorState> firstTabNavKey = new GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> secondTabNavKey = new GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> thirdTabNavKey = new GlobalKey<NavigatorState>();
  List<String> choices = <String>["Play Audio", "Add to Favorites", "Dark Mode", "Share"];

  selfInit() async {
    hymnList = await getHymnList();
    cIStoAH = await getCIStoAH();
    //get last viewed hymn
    _currentHymnNumber = globalUserSettings.getLastHymnNumber();

    _currentHymn = await Hymn.create(_currentHymnNumber, globalUserSettings.getLanguage());

    _pages.putIfAbsent(_currentHymnNumber - 1, () => _currentHymn);

    if (_currentHymn.getNumber() < hymnList.length) {
      Hymn nextHymn = await Hymn.create(_currentHymn.getNumber() + 1, globalUserSettings.getLanguage());

      _pages.putIfAbsent(nextHymn.getNumber() - 1, () => nextHymn);
    }

    if (_currentHymn.getNumber() > 1) {
      Hymn prevHymn = await Hymn.create(_currentHymn.getNumber() - 1, globalUserSettings.getLanguage());

      _pages.putIfAbsent(prevHymn.getNumber() - 1, () => prevHymn);
    }
    bool favoriteState = await checkIfFavorite(_currentHymnNumber);

    _controller = PageController(
      initialPage: _currentHymnNumber - 1,
    );

    setState(() {
      _isFavorite = favoriteState;
      _currentHymnData = _currentHymn;
      _isLoading = false;
    });

    renderHymn();
  }

  @override
  void initState() {
    super.initState();
    selfInit();
  }

  @override
  void dispose() {
    if (audioPlayerInstance != null) {
      audioPlayerInstance.stop();
      audioPlayer.clearCache();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      platformBrightness = MediaQuery.of(context).platformBrightness;
    });

    void _selectPopupMenuItem(String choice) {
      switch (choice) {
        case "Share":
          {
            shareSong(_currentHymnData.toString());
          }
          break;
        case "Add to Favorites":
          {
            callMarkAsFavorite(_currentHymnNumber);
          }
          break;
        case "Remove Favorite":
          {
            callUnmarkAsFavorite(_currentHymnNumber);
          }
          break;
        case "Dark Mode":
          {
            toggleNightMode();
          }
          break;
        case "Play Audio":
          {
            if (this._isPlayingAudio) {
              audioPlayerInstance.stop();
              setState(() {
                this._isPlayingAudio = false;
              });
              audioPlayer.clearCache();
            } else {
              audioPlayer.play(this._currentHymnData.getAudioPath()).then((player) {
                setState(() {
                  this._isPlayingAudio = true;
                });
                audioPlayerInstance = player;
              });
            }
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
                          backgroundColor: globalUserSettings.isNightMode() || platformBrightness == Brightness.dark
                              ? Colors.black
                              : Theme.of(context).scaffoldBackgroundColor,
                          navigationBar: CupertinoNavigationBar(
                            middle: Text("SID Hymnal"),
                            trailing: index == 0
                                ? CupertinoButton(
                                    padding: EdgeInsets.all(0),
                                    child: Icon(IconData(0xf4d2, fontFamily: CupertinoIcons.iconFont, fontPackage: CupertinoIcons.iconFontPackage)),
                                    onPressed: () async {
                                      await showLanguageActions(context);
                                      setState(() {
                                        _isLoading = true;
                                      });

                                      hymnList = await getHymnList();

                                      setState(() {
                                        _isLoading = false;
                                      });
                                    })
                                : null,
                          ),
                          child: _isLoading == true
                              ? Center(child: CupertinoActivityIndicator())
                              : SafeArea(
                                  child: Scaffold(
                                  body: HymnSearch(),
                                ))));
                  break;
                case 1:
                  return CupertinoTabView(
                    navigatorKey: secondTabNavKey,
                    builder: (BuildContext context) => CupertinoPageScaffold(
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
                                backgroundColor: globalUserSettings.isNightMode() || platformBrightness == Brightness.dark
                                    ? Colors.black
                                    : Theme.of(context).scaffoldBackgroundColor,
                                body: MyFavorites(),
                              ))),
                  );
                  break;
                case 2:
                  return CupertinoPageScaffold(
                      backgroundColor:
                          globalUserSettings.isNightMode() || platformBrightness == Brightness.dark ? Colors.black : Theme.of(context).scaffoldBackgroundColor,
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
            tabBar: CupertinoTabBar(
              items: [
                BottomNavigationBarItem(icon: Icon(CupertinoIcons.book), title: Text("Hymns"), activeIcon: Icon(CupertinoIcons.book_solid)),
                BottomNavigationBarItem(icon: Icon(CupertinoIcons.heart), title: Text("Favorites"), activeIcon: Icon(CupertinoIcons.heart_solid)),
                BottomNavigationBarItem(icon: Icon(CupertinoIcons.settings), title: Text("Settings"), activeIcon: Icon(CupertinoIcons.settings_solid))
              ],
              onTap: (index) {
                if (currentIndex == index) {
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
                }
                currentIndex = index;
              },
            ),
          )
        : Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text("SID Hymnal"),
              actions: <Widget>[
                /*
                IconButton(
                  icon: this._isPlayingAudio == true ? Icon(Icons.stop) : Icon(Icons.play_arrow),
                  onPressed: this._currentHymnData != null && this._currentHymnData.hasAudio()
                      ? () {
                          if (this._isPlayingAudio) {
                            audioPlayerInstance.stop();
                            setState(() {
                              this._isPlayingAudio = false;
                            });
                            audioPlayer.clearCache();
                          } else {
                            audioPlayer.play(this._currentHymnData.getAudioPath()).then((player) {
                              setState(() {
                                this._isPlayingAudio = true;
                              });
                              audioPlayerInstance = player;
                            });
                          }
                        }
                      : null,
                ),
                */
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
                IconButton(
                  icon: Icon(Icons.translate),
                  onPressed: () {
                    _displayLanguagesPage(context);
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
                              children: <Widget>[
                                Text(choice),
                                Checkbox(activeColor: Colors.green, value: globalUserSettings.isNightMode(), onChanged: (value) {})
                              ],
                            ),
                          );
                          break;
                        case "Play Audio":
                          return PopupMenuItem<String>(
                            value: choice,
                            child: Text(this._isPlayingAudio ? "Stop Audio" : "Play Audio"),
                            enabled: this._currentHymnData != null && this._currentHymnData.hasAudio() ? true : false,
                          );
                          break;
                        case "Add to Favorites":
                          return _isFavorite
                              ? PopupMenuItem<String>(
                                  value: "Remove Favorite",
                                  child: Text("Remove Favorite"),
                                )
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
            backgroundColor:
                globalUserSettings.isNightMode() || platformBrightness == Brightness.dark ? Colors.black : Theme.of(context).scaffoldBackgroundColor,
            drawer: Drawer(
                child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(color: Colors.white, image: DecorationImage(image: AssetImage("assets/header.jpg"), fit: BoxFit.cover)),
                  child: Container(),
                ),
                ListTile(
                    title: Text("Home"),
                    leading: Icon(Icons.home),
                    onTap: () {
                      Navigator.pop(context);
                    }),
                ListTile(
                  title: Text("Favorites"),
                  leading: Icon(Icons.favorite),
                  onTap: () {
                    Navigator.pop(context);
                    _displayFavoritesPage(context);
                  },
                ),
                ListTile(
                    title: Text("Languages"),
                    leading: Icon(Icons.language),
                    onTap: () {
                      Navigator.pop(context);
                      _displayLanguagesPage(context);
                    }),
                ListTile(
                  title: Text("Settings"),
                  leading: Icon(Icons.settings),
                  onTap: () {
                    Navigator.pop(context);
                    _displaySettingsPage(context);
                  },
                ),
              ],
            )),
            body: _isLoading == true
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : PageView.builder(
                    controller: _controller,
                    onPageChanged: (int index) async {
                      this._currentHymnNumber = index + 1;
                      renderHymn();
                      lazyLoad(index);
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return generatePage(_pages[index]);
                    },
                    itemCount: hymnList.length,
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

  _displayFavoritesPage(context) async {
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

  _displaySettingsPage(context) async {
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

  _displayLanguagesPage(context) async {
    await displayLanguagesPage(context);
    hymnList = await getHymnList();
    _pages.clear();
    renderHymn();
    lazyLoad(this._currentHymnNumber - 1);
  }

  callMarkAsFavorite(int hymnNumber) async {
    await markAsFavorite(hymnNumber);
    bool favoriteState = await checkIfFavorite(hymnNumber);
    setState(() {
      _isFavorite = favoriteState;
    });
  }

  callUnmarkAsFavorite(int hymnNumber) async {
    await unmarkAsFavorite(hymnNumber);
    bool favoriteState = await checkIfFavorite(hymnNumber);
    setState(() {
      _isFavorite = favoriteState;
    });
  }

  Markdown generatePage(Hymn hymn) {
    return Markdown(
      data: hymn.outputMarkdown(),
      styleSheet: MarkdownStyleSheet(
        h2: TextStyle(
            color: globalUserSettings.isNightMode() || platformBrightness == Brightness.dark ? Colors.white : Colors.black,
            fontSize: (globalUserSettings.getFontSize() + 7).toDouble()),
        p: TextStyle(
            color: globalUserSettings.isNightMode() || platformBrightness == Brightness.dark ? Colors.white : Colors.black,
            fontSize: (globalUserSettings.getFontSize()).toDouble()),
        blockSpacing: globalUserSettings.getFontSize().toDouble(),
      ),
    );
  }

  renderHymn() async {
    saveLastHymn(this._currentHymnNumber);
    bool favoriteState = await checkIfFavorite(this._currentHymnNumber);

    if (audioPlayerInstance != null) {
      audioPlayerInstance.stop();
      audioPlayer.clearCache();
    }
    if (!_pages.containsKey(this._currentHymnNumber - 1) && this._currentHymnNumber <= hymnList.length) {
      Hymn hymn = await Hymn.create((this._currentHymnNumber), globalUserSettings.getLanguage());
      _pages.putIfAbsent((this._currentHymnNumber - 1), () => hymn);
    }
    setState(() {
      this._currentHymnData = this._pages[_currentHymnNumber - 1];
      this._isPlayingAudio = false;
      this._isFavorite = favoriteState;
    });
    if (_controller.hasClients) {
      _controller.jumpToPage(this._currentHymnNumber - 1);
    }
  }

  Future<void> lazyLoad(int hymnNumber) async {
    bool pageAdded = false;

    // next page
    if (!_pages.containsKey(hymnNumber + 1) && (hymnNumber + 1) < hymnList.length) {
      Hymn hymn = await Hymn.create((hymnNumber + 2), globalUserSettings.getLanguage());

      _pages.putIfAbsent((hymnNumber + 1), () => hymn);
      pageAdded = true;
    }
    //prev page
    if (!_pages.containsKey(hymnNumber - 1) && hymnNumber > 0) {
      Hymn hymn = await Hymn.create((hymnNumber), globalUserSettings.getLanguage());
      _pages.putIfAbsent((hymnNumber - 1), () => hymn);
      pageAdded = true;
    }

    if (pageAdded) {
      setState(() {});
    }
  }

  toggleNightMode() {
    setState(() {
      globalUserSettings.setNightMode(!globalUserSettings.isNightMode());
    });
    saveNightModeState(globalUserSettings.isNightMode());
  }
}
