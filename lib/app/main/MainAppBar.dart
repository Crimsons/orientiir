import 'package:flutter/material.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String _userName;
  final Function _onEditUserNamePress;

  const MainAppBar(this._userName, this._onEditUserNamePress);

  @override
  Widget build(BuildContext context) {
    var title = "Võistleja: " + _userName;
    return AppBar(title: Text(title), actions: <Widget>[
      IconButton(
        icon: Icon(Icons.edit),
        onPressed: _onEditUserNamePress,
        tooltip: "Muuda võistlejanime",
      ),
    ]);
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
