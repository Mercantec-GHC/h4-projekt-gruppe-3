import 'package:flutter/material.dart';
import 'package:mobile/Components/CustomPopup.dart';
import 'package:mobile/config/app_pages.dart';
import 'package:mobile/services/app_state.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _password = '';
  String _password_confirmation = '';
  late RootAppState _appState;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    _appState = Provider.of<RootAppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        backgroundColor: _theme.colorScheme.primaryContainer,
      ),
      backgroundColor: _theme.colorScheme.primaryContainer,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
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
              SizedBox(height: 10),
              TextFormField(
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
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required and cannot be empty';
                  }
                  return null;
                },
                onChanged: (value) {
                  _password = value;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password Confirmation'),
                obscureText: true,
                validator: (value) {
                  if (_password != value) {
                    return 'Password does not match';
                  }
                  return null;
                },
                onSaved: (value) {
                  _password_confirmation = value!;
                },
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: tryRegister,
                child: Text('Create account'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void tryRegister() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _appState.CreateUser(_name, _password, _email, _password_confirmation, true)
          .then((value) => {
                if (value['statusCode'] == 201)
                  {
                    _appState.switchPage(AppPages.home),
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
}
