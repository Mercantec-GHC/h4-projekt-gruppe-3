import 'package:flutter/material.dart';
import 'package:mobile/Components/ColorScheme.dart';
import 'package:mobile/Components/CustomPopup.dart';
import 'package:mobile/Components/FormInputField.dart';
import 'package:mobile/config/app_pages.dart';
import 'package:mobile/models/user.dart';
import 'package:mobile/services/api.dart';
import 'package:mobile/services/app_state.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class UpdateFamilyProfilePage extends StatefulWidget {
  @override
  _UpdateFamilyProfilePageState createState() =>
      _UpdateFamilyProfilePageState();
}

class _UpdateFamilyProfilePageState extends State<UpdateFamilyProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  int _owner_id = 0;
  late RootAppState _appState;
  List<User> _users = [];
  User? _selectedUser; // Variable to store the selected user

  @override
  void initState() {
    super.initState();
    _appState = Provider.of<RootAppState>(context, listen: false);
    _getUsers();
  }

  Future<void> _getUsers() async {
    String? jwt = await _appState.storage.read(key: 'auth_token');
    final response = await Api().getUserProfiles(_appState.family!.id, jwt);

    var jsonData = json.decode(response.body);
    if (response.statusCode == 200) {
      List<User> newUsers = [];
      for (var user in jsonData) {
        if (user['is_parent'] == 0) continue;
        newUsers.add(
          new User(
            user['id'],
            user['name'],
            user['email'] ?? '',
            _appState.getBool(user['is_parent']),
          ),
        );
      }

      setState(() {
        _users.clear();
        _users.addAll(newUsers);
        if (_users.isNotEmpty) {
          _owner_id = _appState.family!.ownerId;
          int owner =
              _users.indexWhere((u) => u.id == _appState.family!.ownerId);
          _selectedUser = _users[owner];
        }
      });
    } else {
      CustomPopup.openErrorPopup(context, errorText: jsonData['message']);
    }
  }

  void _switchOwner() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String? _auth_token = await _appState.storage.read(key: 'auth_token');

      if (_auth_token == null) {
        _appState.switchPage(AppPages.login);
        Navigator.pop(context);
        return;
      }

      setState(() {
        _appState.family?.ownerId = _owner_id;
      });

      var response = await Api().switchFamiyOwner(
        auth_token: _auth_token,
        new_owner_id: _owner_id,
        family_id: _appState.family?.id,
      );

      if (response.statusCode == 200) {
        _appState.switchPage(AppPages.home);
        Navigator.pop(context);
      }
    }
  }

  void _updateFamilyName() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String? _auth_token = await _appState.storage.read(key: 'auth_token');

      if (_auth_token == null) {
        _appState.switchPage(AppPages.login);
        Navigator.pop(context);
        return;
      }

      setState(() {
        _appState.family?.name = _name;
      });

      var response = await Api().updateFamilyName(
        auth_token: _auth_token,
        name: _name,
        family_id: _appState.family?.id,
      );

      if (response.statusCode == 200) {
        _appState.switchPage(AppPages.home);
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _appState = context.watch<RootAppState>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Family'),
        backgroundColor: CustomColorScheme.primary,
      ),
      backgroundColor: CustomColorScheme.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              width: 300,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
              ),
              child: Text(
                "Family",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              width: 300,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(15),
                ),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Name Field
                    FormInputField(
                      fieldLabel: 'Name',
                      placeholder: 'Family name',
                      initialValue: _appState.family!.name,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Name is required and cannot be empty';
                        }
                        return null;
                      },
                      onSave: (value) {
                        _name = value!;
                      },
                    ),
                    SizedBox(height: 20),

                    // Dropdown to select the new owner
                    DropdownButtonFormField<User>(
                      value: _selectedUser,
                      items: _users
                          .map((user) => DropdownMenuItem(
                                value: user,
                                child: Text(user.name),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedUser = value;
                          _owner_id = value!.id;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Select Owner',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Button to switch the owner
                    ElevatedButton(
                      onPressed: _switchOwner,
                      child: Text('Switch Owner'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                      ),
                    ),
                    SizedBox(height: 20),

                    // Cancel and Save Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                          style: TextButton.styleFrom(
                            backgroundColor: Color(0xFFF06E51),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _updateFamilyName,
                          child: Text('Save'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF89D56B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
