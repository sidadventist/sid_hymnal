class UserSettings {
  int _lastHymn = 1;
  int _fontSize = 16;
  bool _nightMode = false;
  String _language = "en";
  UserSettings();

  int getFontSize() {
    return this._fontSize;
  }

  bool isNightMode() {
    return this._nightMode;
  }

  int getLastHymnNumber() {
    return this._lastHymn;
  }

  String getLanguage() {
    return this._language;
  }

  setLanguage(String lang) {
    this._language = lang;
  }

  setLastHymnNumber(int hymnNumber) {
    this._lastHymn = hymnNumber;
  }

  setFontSize(int size) {
    this._fontSize = size;
  }
  
  setNightMode(bool setting) {
    this._nightMode = setting;
  }

  @override
  String toString() {
    return {
      "lastHymn":this._lastHymn,
      "language":this._language,
      "fontSize":this._fontSize,
      "nightMode":this._nightMode
    }.toString();
  }
}
