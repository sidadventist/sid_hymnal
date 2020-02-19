import 'package:flutter/material.dart';
import 'package:sid_hymnal/screens/core/my_favorites.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Favorites"),
        ),
        body: MyFavorites(),
    );
  }
}

Future<int> displayFavoritesPage(BuildContext context) async {
  var res = await Navigator.of(context).push(new PageRouteBuilder(pageBuilder: (BuildContext context, _, __) {
    return new FavoritesPage();
  }));
  if (res != null && res > 0) {
    return res;
  }
  return 0;
}
