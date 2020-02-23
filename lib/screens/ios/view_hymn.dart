import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:sid_hymnal/common/shared_methods.dart';
import 'package:sid_hymnal/models/hymn.dart';
import '../../main.dart';
import 'bottom_picker.dart';

class ViewHymn extends StatefulWidget {
  final int _hymnNumber;
  ViewHymn(this._hymnNumber);

  @override
  _ViewHymnState createState() => _ViewHymnState();
}

class _ViewHymnState extends State<ViewHymn> {
  bool _isFavorite = false;
  bool _isPlayingAudio = false;
  bool _isLoading = true;
  Hymn _currentHymn;
  Map<int, Hymn> _pages = {};
  AudioPlayer audioPlayerInstance;

  selfInit() async {
    _currentHymn = await Hymn.create(widget._hymnNumber, globalUserSettings.getLanguage());

    bool favoriteState = await checkIfFavorite(_currentHymn.getNumber());

    _pages.putIfAbsent(widget._hymnNumber - 1, () => _currentHymn);

    if (_currentHymn.getNumber() < hymnList.length) {
      Hymn nextHymn = await Hymn.create(_currentHymn.getNumber() + 1, globalUserSettings.getLanguage());

      _pages.putIfAbsent(nextHymn.getNumber() - 1, () => nextHymn);
    }

    if (_currentHymn.getNumber() > 1) {
      Hymn prevHymn = await Hymn.create(_currentHymn.getNumber() - 1, globalUserSettings.getLanguage());

      _pages.putIfAbsent(prevHymn.getNumber() - 1, () => prevHymn);
    }

    setState(() {
      _isFavorite = favoriteState;
      _isLoading = false;
    });
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
    return CupertinoPageScaffold(
      backgroundColor: globalUserSettings.isNightMode() ? Colors.black87 : Theme.of(context).scaffoldBackgroundColor,
      navigationBar: CupertinoNavigationBar(
          middle: Text("SID Hymnal"),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CupertinoButton(
                padding: EdgeInsets.all(0),
                child: this._isPlayingAudio == true ? Icon(CupertinoIcons.pause_solid) : Icon(CupertinoIcons.play_arrow_solid),
                onPressed: _currentHymn != null && _currentHymn.hasAudio()
                    ? () {
                        if (this._isPlayingAudio) {
                          audioPlayerInstance.stop();
                          setState(() {
                            this._isPlayingAudio = false;
                          });
                          audioPlayer.clearCache();
                        } else {
                          audioPlayer.play(_currentHymn.getAudioPath()).then((player) {
                            setState(() {
                              this._isPlayingAudio = true;
                            });
                            audioPlayerInstance = player;
                          });
                        }
                      }
                    : null,
              ),
              CupertinoButton(
                padding: EdgeInsets.all(0),
                child: Icon(_isFavorite ? CupertinoIcons.heart_solid : CupertinoIcons.heart),
                onPressed: () async {
                  if (_isFavorite) {
                    await unmarkAsFavorite(_currentHymn.getNumber());
                  } else {
                    await markAsFavorite(_currentHymn.getNumber());
                  }
                  bool favoriteState = await checkIfFavorite(_currentHymn.getNumber());
                  setState(() {
                    _isFavorite = favoriteState;
                  });
                },
              ),
              /*
              CupertinoButton(
                padding: EdgeInsets.all(0),
                child: Icon(globalUserSettings.isNightMode() ? CupertinoIcons.brightness_solid : CupertinoIcons.brightness),
                onPressed: () {
                  toggleNightMode();
                },
              ),
              */
              CupertinoButton(
                  padding: EdgeInsets.all(0),
                  child: Icon(IconData(0xf4d2, fontFamily: CupertinoIcons.iconFont, fontPackage: CupertinoIcons.iconFontPackage)),
                  onPressed: () async {
                    int currentLanguage = globalLanguageList.keys.toList().indexOf(globalUserSettings.getLanguage());
                    final FixedExtentScrollController scrollController = FixedExtentScrollController(initialItem: currentLanguage);

                    await showCupertinoModalPopup<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return BottomPicker(
                          child: CupertinoPicker(
                            scrollController: scrollController,
                            itemExtent: kPickerItemHeight,
                            backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
                            onSelectedItemChanged: (int index) {
                              globalUserSettings.setLanguage(globalLanguageList[globalLanguageList.keys.toList()[index]].languageCode);
                            },
                            children: List<Widget>.generate(globalLanguageList.length, (int index) {
                              return Center(
                                child: Text(globalLanguageList[globalLanguageList.keys.toList()[index]].language),
                              );
                            }),
                          ),
                        );
                      },
                    );

                    int currentHymnNumber = this._currentHymn.getNumber();
                    _pages.clear();
                    setState(() {
                      lazyLoad(currentHymnNumber);
                    });
                  }),
            ],
          )),
      child: _isLoading == true
          ? Center(child: CupertinoActivityIndicator())
          : SafeArea(
              child: PageView.builder(
                controller: PageController(
                  initialPage: this._currentHymn.getNumber() - 1,
                ),
                onPageChanged: (int index) async {
                  print(index);
                  renderHymn(index + 1);
                },
                itemBuilder: (BuildContext context, int index) {
                  return generatePage(_pages[index]);
                },
              ),
            ),
    );
  }

  Future<void> lazyLoad(int hymnNumber) async {
    bool pageAdded = false;

    _currentHymn = await Hymn.create(hymnNumber, globalUserSettings.getLanguage());

    _pages.putIfAbsent(hymnNumber - 1, () => _currentHymn);

    if (_currentHymn.getNumber() < hymnList.length) {
      Hymn nextHymn = await Hymn.create(_currentHymn.getNumber() + 1, globalUserSettings.getLanguage());

      _pages.putIfAbsent(nextHymn.getNumber() - 1, () => nextHymn);
    }

    if (_currentHymn.getNumber() > 1) {
      Hymn prevHymn = await Hymn.create(_currentHymn.getNumber() - 1, globalUserSettings.getLanguage());

      _pages.putIfAbsent(prevHymn.getNumber() - 1, () => prevHymn);
    }

    if (pageAdded) {
      setState(() {});
    }
  }

  Markdown generatePage(Hymn hymn) {
    return Markdown(
      data: hymn.outputMarkdown(),
      styleSheet: MarkdownStyleSheet(
        h2: TextStyle(color: globalUserSettings.isNightMode() ? Colors.white : Colors.black, fontSize: (globalUserSettings.getFontSize() + 7).toDouble()),
        p: TextStyle(color: globalUserSettings.isNightMode() ? Colors.white : Colors.black, fontSize: (globalUserSettings.getFontSize()).toDouble()),
        blockSpacing: globalUserSettings.getFontSize().toDouble(),
      ),
    );
  }

  renderHymn(int hymnNumber) async {
    await lazyLoad(hymnNumber);
    if (this._isPlayingAudio) {
      audioPlayerInstance.stop();
      setState(() {
        this._isPlayingAudio = false;
      });
    }
    bool favoriteStatus = await checkIfFavorite(hymnNumber);
    setState(() {
      _isFavorite = favoriteStatus;
      this._currentHymn = _pages[hymnNumber - 1];
    });
  }

  toggleNightMode() {
    setState(() {
      globalUserSettings.setNightMode(!globalUserSettings.isNightMode());
    });
    saveNightModeState(globalUserSettings.isNightMode());
  }
}
