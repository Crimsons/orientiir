import 'package:flutter/cupertino.dart';

class NoContentText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Center(
          child: Text(
        "Võistluse lisamiseks vajuta \"+\" nupule",
        style: TextStyle(fontSize: 18),
        textAlign: TextAlign.center,
      )),
    );
  }
}
