import 'package:flutter/material.dart';
import 'package:hybrid_app/data/model/checkpoint/CheckPoint.dart';
import 'package:hybrid_app/data/model/checkpoint/CheckPointType.dart';
import 'package:intl/intl.dart';

class ListItem extends StatelessWidget {
  final CheckPoint checkPoint;
  final CheckPoint previousCheckPoint;

  ListItem({this.checkPoint, this.previousCheckPoint});

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
                Text(_titleString),
                Text(_typeString),
                Text(_dateString),
                _buildLapTimeText(),
              ],
            ),
          ],
        ));
  }

  String get _titleString {
    return "Kood: ${checkPoint.code}";
  }

  String get _typeString {
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

  String get _dateString {
    var formatter = DateFormat("kk:mm:ss");
    return "Kellaaeg: ${formatter.format(checkPoint.dateTime)}";
  }

  Widget _buildLapTimeText() {
    if (previousCheckPoint != null) {
      return Text(_lapTimeString);
    } else {
      return SizedBox.shrink();
    }
  }

  String get _lapTimeString {
    final duration =
    checkPoint.dateTime.difference(previousCheckPoint.dateTime);
    final durationString = duration
        .toString()
        .split(".")
        .first;
    return "Etapiaeg: $durationString";
  }
}
