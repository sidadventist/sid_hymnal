import 'package:flutter/services.dart';
import 'package:sid_hymnal/common/shared_methods.dart';
import 'package:sid_hymnal/main.dart';

class Hymn {
  int _number;
  String _title;
  List<String> _sections;
  String _rawString;
  bool _hasAudio;
  String _audioPath;
  String ahNumber;

  Hymn._(this._number, this._title, this._sections, this._rawString, this._hasAudio, this._audioPath, this.ahNumber);

  static Future<Hymn> create(int hymnNumber, String language) async {
    String sourceMD = await rootBundle.loadString('assets/hymns/$language/${padHymnNumber(hymnNumber)}.md');
    //delete all \r chars here
    sourceMD = sourceMD.replaceAll(new RegExp("\r"), "");
    List<String> parts = sourceMD.split(new RegExp("\n\n"));
    String _srcTitle;
    List<String> _srcSections = new List();
    String ahNumber;

    for (int i = 0; i < parts.length; i++) {
      if (i == 0) {
        //check for the ##
        if (parts[i].substring(0, 3) != "## ") {
          throw ("Title does not start with ## and a space");
        }
        ahNumber = cIStoAH["$hymnNumber"] != null ? cIStoAH["$hymnNumber"] : "";
        _srcTitle = "$hymnNumber ${parts[i].substring(2, parts[i].length)}";
        continue;
      }

      if (parts[i].startsWith(new RegExp("chorus\n", caseSensitive: false)) || parts[i].startsWith(new RegExp("refrain\n", caseSensitive: false))) {
        _srcSections.add(
            "*${parts[i].replaceFirst(new RegExp("chorus\n", caseSensitive: false), "refrain\n").replaceFirst(new RegExp("refrain", caseSensitive: false), "CHORUS").trim()}*\n\n");
      } else {
        _srcSections.add("${parts[i]}\n\n");
      }
    }
    String audioPath = "audio/${padHymnNumber(hymnNumber)}.midi";
    bool hasAudio = await _assetExists("assets/$audioPath");

    return Hymn._(hymnNumber, _srcTitle, _srcSections, sourceMD.substring(3), hasAudio, hasAudio ? audioPath : "", ahNumber);
  }

  String getAudioPath() {
    return this._audioPath;
  }

  int getNumber() {
    return this._number;
  }

  String getTitle() {
    return this._title;
  }

  bool hasAudio() {
    return this._hasAudio;
  }

  @override
  String toString() {
    return this._rawString;
  }

  String outputMarkdown() {
    // returns a standardized, sanitized markdown
    String markdown = "";

    markdown += "## ${this._title}";
    if(this.ahNumber != ""){
    markdown += "\n\` AH " + this.ahNumber + " \`";
    }
    markdown += "\n\n";
    this._sections.forEach((section) {
      markdown += "$section\n";
    });

    return markdown;
  }

  static Future<bool> _assetExists(String path) async {
    try {
      await rootBundle.load(path);
      return true;
    } catch (_) {
      return false;
    }
  }
}
