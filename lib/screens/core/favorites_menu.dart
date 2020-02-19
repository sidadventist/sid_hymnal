import 'package:flutter/material.dart';
import 'package:sid_hymnal/common/shared_methods.dart';

class FavoritesContextMenu extends StatefulWidget {
  final int hymnNumber;
  FavoritesContextMenu(this.hymnNumber);
  @override
  _FavoritesContextMenuState createState() => _FavoritesContextMenuState();
}

class _FavoritesContextMenuState extends State<FavoritesContextMenu> {
  String numberSelection = "";

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                FlatButton(
                    onPressed: () {
                      unmarkAsFavorite(widget.hymnNumber);
                      Navigator.pop(context);
                    },
                    child: ListTile(
                      title: Text(
                        "Remove",
                        style: TextStyle(color: Colors.deepOrange),
                      ),
                      trailing: Icon(Icons.delete),
                    )),
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: ListTile(
                      title: Text(
                        "Cancel",
                      ),
                    )),
              ],
            )));
  }
}

Future<int> displayFavoritesContextMenu(BuildContext context, int hymnNumber) async {
  var res = await showGeneralDialog(
    context: context,
    pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
      return Center(child: Padding(padding: EdgeInsets.all(16), child: FavoritesContextMenu(hymnNumber)));
    },
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black45,
    transitionDuration: const Duration(milliseconds: 200),
  );

  if (res != null && int.parse(res) > 0) {
    return int.parse(res);
  }
  return 0;
}

closeFavoritesContextMenu(BuildContext context) {
  Navigator.of(context).pop();
}
