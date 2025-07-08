import 'package:flutter/material.dart';

Future<void> endGameDialog(String title, String message, BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // dismiss the dialog
              // optionally reset the game here or call `resetGame()`
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
