import 'package:flutter/material.dart';

class CustomPopup {
  static void openErrorPopup(BuildContext context,
      {String errorText = "", String title = 'Something went wrong'}) {
    _openRealPopup(context, title, errorText);
  }

  static void openDeleteTaskConfirmation(
      BuildContext context, Function _deleteTask) {
    _openRealPopup(
      context,
      'Delete task',
      'Are you sure you want to delete this task?',
      extraButton: TextButton(
        onPressed: () => {
          Navigator.of(context).pop(),
          _deleteTask(),
        },
        child: Text('Confirm'),
      ),
    );
  }

  static void _openRealPopup(BuildContext context, String title, String text,
      {TextButton? extraButton}) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(title),
              content: text.isNotEmpty ? Text(text) : null,
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
                ),
                if (extraButton != null) extraButton
              ],
            ));
  }
}
