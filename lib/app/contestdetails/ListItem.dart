import 'package:flutter/material.dart';
import 'package:hybrid_app/data/model/checkpoint/CheckPoint.dart';
import 'package:hybrid_app/data/model/checkpoint/CheckPointType.dart';
import 'package:intl/intl.dart';

class ListItem extends StatelessWidget {
  final CheckPoint checkPoint;
  final CheckPoint nextCheckPoint;
  final Function onDeletePress;

  ListItem({this.checkPoint, this.nextCheckPoint, this.onDeletePress});

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
            Expanded(
              child: Column(
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
            ),
            buildPopupMenu()
          ],
        ));
  }

  PopupMenuButton<MenuButton> buildPopupMenu() {
    return PopupMenuButton(
      onSelected: (MenuButton selected) {
        if (selected == MenuButton.delete) {
          this.onDeletePress(checkPoint);
        }
      },
      itemBuilder: (BuildContext context) =>
      [
        const PopupMenuItem(
          value: MenuButton.delete,
          child: const ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Kustuta'),
          ),
        ),
      ],
      tooltip: "Valikud",
    );
  }

  Icon _buildIcon() {
    switch (checkPoint.type) {
      case CheckPointType.start:
        return Icon(
          Icons.play_circle_filled,
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
      case CheckPointType.extra:
      case CheckPointType.auxiliary:
      case CheckPointType.unknown:
      default:
        return checkPoint.humanReadableCode;
    }
  }

  String get _dateString {
    var formatter = DateFormat("kk:mm:ss");
    return "${formatter.format(checkPoint.dateTime)}";
  }

  Widget _buildLapTimeText() {
    if (nextCheckPoint != null) {
      return Text(
        _lapTimeString,
        style: TextStyle(fontSize: 16),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  String get _lapTimeString {
    final duration = checkPoint.dateTime.difference(nextCheckPoint.dateTime);
    final durationString = duration
        .toString()
        .split(".")
        .first;
    return "+$durationString";
  }
}

enum MenuButton { delete }
