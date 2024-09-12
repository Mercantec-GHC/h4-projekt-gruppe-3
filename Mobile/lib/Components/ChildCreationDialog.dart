import 'package:flutter/material.dart';
import 'package:mobile/Components/CustomPopup.dart';
import 'package:mobile/models/UserProfile.dart';
import 'package:mobile/services/app_state.dart';
import 'package:provider/provider.dart';

class Childcreation extends StatefulWidget {
  const Childcreation({
    super.key,
    required this.onCreation,
  });

  final Function(UserProfile) onCreation;

  @override
  State<Childcreation> createState() => _ChildcreationState();
}

class _ChildcreationState extends State<Childcreation> {
  final _formKey = GlobalKey<FormState>();
  late RootAppState appState;
  String _name = '';
  String _username = '';
  String _password = '';
  String _password_confirmation = '';

  void _createChild() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      appState.CreateUser(
              _name, _password, _username, _password_confirmation, false)
          .then((value) => {
                if (value['statusCode'] == 201)
                  {
                    widget.onCreation(
                        UserProfile(0, _name, null, _username, false, 0, 0)),
                    Navigator.of(context).pop(),
                  }
                else
                  {
                    CustomPopup.openErrorPopup(
                      context,
                      title: 'Couldn\'t create user',
                      errorText: value['body']['errors'].toString(),
                    ),
                  }
              });
    }
  }

  @override
  Widget build(BuildContext context) {
    appState = Provider.of<RootAppState>(context);
    return AlertDialog(
      scrollable: true,
      title: Text('Create child'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: _createChild,
          child: Text('Create'),
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
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _name = value!;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Username'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Username is required';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _username = value!;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _password = value;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration:
                      InputDecoration(labelText: 'Password Confirmation'),
                  obscureText: true,
                  validator: (value) {
                    if (_password != value || value == null || value.isEmpty) {
                      return 'Password does not match';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _password_confirmation = value!;
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
