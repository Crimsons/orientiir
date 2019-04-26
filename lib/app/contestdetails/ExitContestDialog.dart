import 'package:flutter/material.dart';

class ExitContestDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Lõpeta võistlus?"),
      content:
          Text("Enne lõpetamist veendu, et tulemused on edukalt saadetud!"),
      actions: <Widget>[
        FlatButton(
          child: Text('TAGASI'),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        FlatButton(
            child: Text('LÕPETA'),
            onPressed: () => Navigator.of(context).pop(true)),
      ],
    );
  }
}
