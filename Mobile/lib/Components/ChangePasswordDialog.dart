import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/config/app_pages.dart';
import 'package:mobile/services/app_state.dart';

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  late RootAppState _appState;
  final _formKey = GlobalKey<FormState>();
  String _current_password = '';
  String _new_password = '';
  String _new_password_confirmation = '';

  void _updateUserPassword() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String? _auth_token = await _appState.storage.read(key: 'auth_token');

      if (_auth_token == null) {
        _appState.switchPage(AppPages.login);
        return;
      }

      var result = await _appState.updateUserPassword(
        auth_token: _auth_token,
        current_password: _current_password,
        new_password: _new_password,
        new_password_confirmation: _new_password_confirmation,
      );

      if (result['statusCode'] == 204) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        _appState.logout();
        _appState.switchPage(AppPages.login);
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _appState = context.watch<RootAppState>();
    return AlertDialog(
      title: Text('Change password'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Close'),
        ),
        TextButton(
          onPressed: _updateUserPassword,
          child: Text('Change password'),
        ),
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Current password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Field is required and cannot be empty';
                    }
                    return null;
                  },
                  initialValue: _current_password,
                  onSaved: (value) {
                    _current_password = value!;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  initialValue: _new_password,
                  decoration: InputDecoration(labelText: 'New password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Field is required and cannot be empty';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _new_password = value;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  initialValue: _new_password_confirmation,
                  decoration:
                      InputDecoration(labelText: 'Password Confirmation'),
                  obscureText: true,
                  validator: (value) {
                    if (_new_password != value) {
                      return 'Password does not match';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _new_password_confirmation = value!;
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
