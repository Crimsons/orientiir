import 'package:flutter/material.dart';

class NoCheckPointsMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Center(
          child: Text(
        "Võistluse alustamiseks pildista stardi QR-koodi",
        style: TextStyle(fontSize: 18),
        textAlign: TextAlign.center,
      )),
    );
  }
}
