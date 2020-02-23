import 'package:flutter/material.dart';
import 'package:sid_hymnal/screens/core/hymn_search.dart';

class SearchPage extends StatelessWidget {
  final String language;
  SearchPage(this.language);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
              title: Text("Search"),
      ),
      body: HymnSearch(),
    );
  }
}
Future<int> displaySearchPage(BuildContext context, String language) async {
  var res = await Navigator.of(context).push(new PageRouteBuilder(
      pageBuilder: (BuildContext context, _, __) {
        return new SearchPage(language);
      }));
  if (res != null && res > 0) {
    return res;
  }
  return 0;
}