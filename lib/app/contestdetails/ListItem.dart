import 'package:flutter/material.dart';
import 'package:hybrid_app/data/model/checkpoint/CheckPoint.dart';
import 'package:hybrid_app/data/model/checkpoint/CheckPointType.dart';
import 'package:intl/intl.dart';

class ListItem extends StatelessWidget {
  final CheckPoint checkPoint;

  ListItem({this.checkPoint});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Icon(Icons.beenhere),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(_titleString(checkPoint)),
                Text(_typeString(checkPoint)),
                Text(_dateString(checkPoint)),
              ],
            ),
          ],
        ));
  }

  String _titleString(CheckPoint checkPoint) {
    String title = "Kood: ${checkPoint.code}";
    return title;
  }

  String _typeString(CheckPoint checkPoint) {
    String type = "Tüüp: ";
    switch (checkPoint.type) {
      case CheckPointType.checkpoint:
        type += "Kontrollpunkt";
        break;
      case CheckPointType.start:
        type += "Start";
        break;
      case CheckPointType.finish:
        type += "Finish";
        break;
      case CheckPointType.extra:
        type += "Lisakatse";
        break;
      case CheckPointType.auxiliary:
        type += "Reserveeritud";
        break;
      case CheckPointType.unknown:
        type += "Tundmatu";
        break;
    }
    return type;
  }

  String _dateString(CheckPoint checkPoint) {
    var formatter = DateFormat("kk:mm:ss");
    String dateTime = "Kellaaeg: ${formatter.format(checkPoint.dateTime)}";
    return dateTime;
  }
}
