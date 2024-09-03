import 'package:flutter/material.dart';

class CustomErrorPopup {
  static void openErrorPopup(BuildContext context, String _errorText, {String title = 'Something went wrong'}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: _errorText.isNotEmpty ? Text(_errorText) : null,
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
}
