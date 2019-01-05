import 'package:flutter/material.dart';

class LastCompetitionButton extends StatelessWidget {
  LastCompetitionButton({this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: RaisedButton(
        child: Text("Vaata viimast"),
        onPressed: onPressed,
        color: Theme.of(context).accentColor,
        textColor: Colors.white,
      ),
    );
  }
}
