import 'package:flutter/material.dart';
import 'package:hybrid_app/data/model/checkpoint/CheckPoint.dart';

import 'ListItem.dart';

class CheckPointsList extends StatelessWidget {
  final List<CheckPoint> data;
  final Function onDeleteCheckPointPress;

  const CheckPointsList({this.data, this.onDeleteCheckPointPress});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        CheckPoint checkPoint = data[index];
        CheckPoint nextCheckPoint;
        if (index < data.length - 1) {
          nextCheckPoint = data[index + 1];
        }
        return ListItem(
            checkPoint: checkPoint,
            nextCheckPoint: nextCheckPoint,
            onDeletePress: this.onDeleteCheckPointPress);
      },
      itemCount: data.length,
      separatorBuilder: (context, index) => Divider(
            color: Colors.grey,
            height: 1,
          ),
    );
  }
}
