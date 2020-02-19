import 'package:flutter/material.dart';

class HymnKeypad extends StatefulWidget {
  @override
  _HymnKeypadState createState() => _HymnKeypadState();
}

class _HymnKeypadState extends State<HymnKeypad> {
  String numberSelection = "";

  addNum(String number) {
    String newSelection;
    print(int.parse("$numberSelection$number"));
    if (int.parse("$numberSelection$number") > 300) {
      newSelection = "300";
    } else {
      newSelection = "$numberSelection$number";
    }

    setState(() {
      numberSelection = newSelection;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(width: 32),
            Expanded(
              child: Text(
                numberSelection == "0" ? "" : numberSelection,
                style: TextStyle(fontSize: 28),
                textAlign: TextAlign.center,
              ),
            ),
            FlatButton(
              padding: EdgeInsets.all(12),
              child: Icon(Icons.backspace),
              onPressed: () {
                if (numberSelection.length > 0) {
                  setState(() {
                    numberSelection = numberSelection.substring(0, numberSelection.length - 1);
                  });
                }
              },
            )
          ],
        ),
        Divider(
          thickness: 3,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
                onPressed: () {
                  addNum("1");
                },
                child: Text(
                  "1",
                  style: TextStyle(fontSize: 28),
                  textAlign: TextAlign.center,
                )),
            FlatButton(
                onPressed: () {
                  addNum("2");
                },
                child: Text(
                  "2",
                  style: TextStyle(fontSize: 28),
                  textAlign: TextAlign.center,
                )),
            FlatButton(
                onPressed: () {
                  addNum("3");
                },
                child: Text(
                  "3",
                  style: TextStyle(fontSize: 28),
                  textAlign: TextAlign.center,
                )),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
                onPressed: () {
                  addNum("4");
                },
                child: Text(
                  "4",
                  style: TextStyle(fontSize: 28),
                  textAlign: TextAlign.center,
                )),
            FlatButton(
                onPressed: () {
                  addNum("5");
                },
                child: Text(
                  "5",
                  style: TextStyle(fontSize: 28),
                  textAlign: TextAlign.center,
                )),
            FlatButton(
                onPressed: () {
                  addNum("6");
                },
                child: Text(
                  "6",
                  style: TextStyle(fontSize: 28),
                  textAlign: TextAlign.center,
                )),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
                onPressed: () {
                  addNum("7");
                },
                child: Text(
                  "7",
                  style: TextStyle(fontSize: 28),
                  textAlign: TextAlign.center,
                )),
            FlatButton(
                onPressed: () {
                  addNum("8");
                },
                child: Text(
                  "8",
                  style: TextStyle(fontSize: 28),
                  textAlign: TextAlign.center,
                )),
            FlatButton(
                onPressed: () {
                  addNum("9");
                },
                child: Text(
                  "9",
                  style: TextStyle(fontSize: 28),
                  textAlign: TextAlign.center,
                )),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
                onPressed: null,
                child: Text(
                  "",
                  style: TextStyle(fontSize: 28),
                  textAlign: TextAlign.center,
                )),
            FlatButton(
                onPressed: () {
                  addNum("0");
                },
                child: Text(
                  "0",
                  style: TextStyle(fontSize: 28),
                  textAlign: TextAlign.center,
                )),
            FlatButton(
                onPressed: null,
                child: Text(
                  "",
                  style: TextStyle(fontSize: 28),
                  textAlign: TextAlign.center,
                )),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "CANCEL",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).accentColor),
                )),
            MaterialButton(
                onPressed: () {
                  Navigator.pop(context, numberSelection == "" ? "0" : numberSelection);
                },
                child: Text(
                  "GO",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).accentColor),
                )),
          ],
        ),
      ],
    ));
  }
}

Future<int> displayHymnKeypad(BuildContext context) async {
  /*
  var res = await Navigator.of(context).push(new PageRouteBuilder(
      opaque: false,
      pageBuilder: (BuildContext context, _, __) {
        return new HymnKeypad();
      }));
  if (res != null && int.parse(res) > 0) {
    return int.parse(res);
  }
  return 0;
  */
  var res = await showGeneralDialog(
    context: context,
    pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
      return Center(child: Padding(padding: EdgeInsets.all(16), child: HymnKeypad()));
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

closeHymnKeypad(BuildContext context) {
  Navigator.of(context).pop();
}
