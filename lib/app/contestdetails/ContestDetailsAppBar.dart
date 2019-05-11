import 'package:flutter/material.dart';

class ContestDetailsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final Function onSendResultsPress;
  final Function onExitContestPress;

  const ContestDetailsAppBar(
      this.title, this.onSendResultsPress, this.onExitContestPress);

  @override
  Widget build(BuildContext context) {
    return AppBar(title: Text(title), actions: <Widget>[
      PopupMenuButton(
        onSelected: _handleMenuItemPressed,
        itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: MenuButton.send_results,
                child: Text("Saada tulemused"),
              ),
              const PopupMenuItem(
                value: MenuButton.exit,
                child: Text("Lõpeta"),
              ),
            ],
        tooltip: "Menüü",
      )
    ]);
  }

  void _handleMenuItemPressed(MenuButton selected) {
    if (selected == MenuButton.send_results) {
      this.onSendResultsPress();
    } else if (selected == MenuButton.exit) {
      this.onExitContestPress();
    }
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

enum MenuButton { send_results, exit }
