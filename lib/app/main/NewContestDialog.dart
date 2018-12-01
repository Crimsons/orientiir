import 'package:flutter/material.dart';

class NewContestDialog extends StatefulWidget {
  @override
  State createState() => NewContestDialogState();
}

class NewContestDialogState extends State<NewContestDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Sisesta võistluse nimi"),
      content: Form(
        key: _formKey,
        child: TextFormField(
          validator: (value) {
            if (value.isEmpty) {
              return 'Sisesta korrektne võistluse nimi';
            }
          },
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.text,
          autofocus: true,
          controller: textFieldController,
          decoration: InputDecoration(
            labelText: "nimi",
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('KATKESTA'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text('OK'),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              Navigator.of(context).pop(textFieldController.text);
            }
          },
        ),
      ],
    );
  }
}
