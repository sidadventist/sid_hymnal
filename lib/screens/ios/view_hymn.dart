import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:sid_hymnal/common/shared_methods.dart';
import 'package:sid_hymnal/models/hymn.dart';
import '../../main.dart';

class ViewHymn extends StatefulWidget {
  final Hymn _hymn;
  ViewHymn(this._hymn);

  @override
  _ViewHymnState createState() => _ViewHymnState();
}

class _ViewHymnState extends State<ViewHymn> {
  bool _isFavorite = false;
  bool _isPlayingAudio = false;
  bool _isLoading = true;
  AudioPlayer audioPlayerInstance;

  selfInit() async {
    bool favoriteState = await checkIfFavorite(widget._hymn.getNumber());
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
                child: this._isPlayingAudio == true ? Icon(CupertinoIcons.pause) : Icon(CupertinoIcons.play_arrow),
                onPressed: widget._hymn != null && widget._hymn.hasAudio()
                    ? () {
                          if (this._isPlayingAudio) {
                            audioPlayerInstance.stop();
                            setState(() {
                              this._isPlayingAudio = false;
                            });
                            audioPlayer.clearCache();
                          } else {
                            audioPlayer.play(widget._hymn.getAudioPath()).then((player) {
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
                    await unmarkAsFavorite(widget._hymn.getNumber());
                  } else {
                    await markAsFavorite(widget._hymn.getNumber());
                  }
                  bool favoriteState = await checkIfFavorite(widget._hymn.getNumber());
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
                onPressed: () {
                  // shareSong(widget._hymn.toString());
                },
              ),
            ],
          )),
      child: _isLoading == true
          ? Center(child: CupertinoActivityIndicator())
          : SafeArea(
              child: Markdown(
                data: this.widget._hymn.outputMarkdown(),
                styleSheet: MarkdownStyleSheet(
                  h2: TextStyle(
                      color: globalUserSettings.isNightMode() ? Colors.white : Colors.black, fontSize: (globalUserSettings.getFontSize() + 7).toDouble()),
                  p: TextStyle(color: globalUserSettings.isNightMode() ? Colors.white : Colors.black, fontSize: (globalUserSettings.getFontSize()).toDouble()),
                  blockSpacing: globalUserSettings.getFontSize().toDouble(),
                ),
              ),
            ),
    );
  }

  toggleNightMode() {
    setState(() {
      globalUserSettings.setNightMode(!globalUserSettings.isNightMode());
    });
    saveNightModeState(globalUserSettings.isNightMode());
  }
}
