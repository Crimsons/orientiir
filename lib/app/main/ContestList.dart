import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hybrid_app/data/model/checkpoint/Contest.dart';
import 'package:intl/intl.dart';

class ContestList extends StatelessWidget {
  final _contestList;
  final Function _onItemPress;
  final Function _onItemDeletePress;

  const ContestList(this._contestList, this._onItemPress,
      this._onItemDeletePress);

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
          onTap: () => _onItemPress(contest),
          trailing: _buildPopupMenu(() => _onItemDeletePress(contest)),
        );
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

PopupMenuButton<MenuButton> _buildPopupMenu(Function onDeletePress) {
  return PopupMenuButton(
    onSelected: (MenuButton selected) {
      if (selected == MenuButton.delete) {
        onDeletePress();
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

String _getDateString(Contest contest) {
  var formatter = DateFormat("dd.MM.yyyy kk:mm");
  return "${formatter.format(contest.date)}";
}

enum MenuButton { delete }
