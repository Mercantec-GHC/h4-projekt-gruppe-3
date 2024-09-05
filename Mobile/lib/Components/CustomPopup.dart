import 'package:flutter/material.dart';

class CustomPopup {
  static void openErrorPopup(BuildContext context, { String errorText = "", String title = 'Something went wrong'}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: errorText.isNotEmpty ? Text(errorText) : null,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  static void openDeleteTaskConfirmation(BuildContext context, Function _deleteTask) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete task'),
        content: Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close'),
          ),
          TextButton(
            onPressed: () => {
              Navigator.of(context).pop(),
              _deleteTask(),
            },
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
