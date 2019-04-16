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
                child: _buildIcon()),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  _titleString,
                  style: TextStyle(fontSize: 22),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 32.0),
                        child: Text(
                          _dateString,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      _buildLapTimeText(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  Icon _buildIcon() {
    switch (checkPoint.type) {
      case CheckPointType.start:
        return Icon(
          Icons.trip_origin,
          color: Colors.green,
          size: 30,
        );
      case CheckPointType.finish:
        return Icon(
          Icons.flag,
          color: Colors.green,
          size: 30,
        );
      case CheckPointType.checkpoint:
        return Icon(
          Icons.location_on,
          color: Colors.green,
          size: 30,
        );
      case CheckPointType.extra:
        return Icon(
          Icons.stars,
          color: Colors.green,
          size: 30,
        );
      case CheckPointType.auxiliary:
        return Icon(
          Icons.location_on,
          color: Colors.green,
          size: 30,
        );
      case CheckPointType.unknown:
      default:
        return Icon(
          Icons.error_outline,
          color: Colors.red,
          size: 30,
        );
    }
  }

  String get _titleString {
    switch (checkPoint.type) {
      case CheckPointType.start:
        return "START";
      case CheckPointType.finish:
        return "FINIŠ";
      case CheckPointType.checkpoint:
        return "KP " + checkPoint.humanReadableCode;
      case CheckPointType.extra:
        return "LK " + checkPoint.humanReadableCode;
      case CheckPointType.auxiliary:
        return "RESERVEERITUD";
      case CheckPointType.unknown:
      default:
        return "TUNDMATU";
    }
  }

  String get _dateString {
    var formatter = DateFormat("kk:mm:ss");
    return "${formatter.format(checkPoint.dateTime)}";
  }

  Widget _buildLapTimeText() {
    if (previousCheckPoint != null) {
      return Text(
        _lapTimeString,
        style: TextStyle(fontSize: 16),
      );
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
    return "+$durationString";
  }
}
