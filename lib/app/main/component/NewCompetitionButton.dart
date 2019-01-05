import 'package:flutter/material.dart';

class NewCompetitionButton extends StatelessWidget {
  NewCompetitionButton({this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: RaisedButton(
        child: Text("Uus võistlus"),
        onPressed: onPressed,
        color: Theme.of(context).accentColor,
        textColor: Colors.white,
      ),
    );
  }
}
