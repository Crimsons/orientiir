import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hybrid_app/data/model/checkpoint/Contest.dart';
import 'package:intl/intl.dart';

class ContestList extends StatelessWidget {
  final _contestList;
  final Function _onItemPress;

  const ContestList(this._contestList, this._onItemPress);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        Contest contest = _contestList[index];
        return ListTile(
            title: Text(
              contest.name,
              style: TextStyle(fontSize: 22),
            ),
            subtitle: Text(
              _getDateString(contest),
              style: TextStyle(fontSize: 16),
            ),
            onTap: () => _onItemPress(contest));
      },
      itemCount: _contestList.length,
      separatorBuilder: (context, index) => Divider(
            color: Colors.grey,
            height: 1,
          ),
      padding: EdgeInsets.only(bottom: 70),
    );
  }
}

String _getDateString(Contest contest) {
  var formatter = DateFormat("dd.MM.yyyy kk:mm");
  return "${formatter.format(contest.date)}";
}
