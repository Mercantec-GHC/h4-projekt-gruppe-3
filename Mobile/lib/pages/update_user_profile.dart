import 'package:flutter/material.dart';
import 'package:mobile/services/app_state.dart';
import 'package:provider/provider.dart';

class UpdateUserProfilePage extends StatefulWidget {
  @override
  _UpdateUserProfilePageState createState() => _UpdateUserProfilePageState();
}

class _UpdateUserProfilePageState extends State<UpdateUserProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  late RootAppState _appState;

  @override
  void initState() {
    super.initState();
  }

  void _updateUserProfile() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _appState.UpdateUser(
        _name,
        _email,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _appState = context.watch<RootAppState>();
    final currentUser = _appState.user;

    return Scaffold(
      appBar: AppBar(
        title: Text('Update profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: currentUser?.name,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name is required and cannot be empty';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: currentUser?.email,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required and cannot be empty';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'The entered email is not a valid email';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: _updateUserProfile,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
