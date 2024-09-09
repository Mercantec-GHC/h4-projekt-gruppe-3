import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mobile/Components/CustomPopup.dart';
import 'package:mobile/config/app_pages.dart';
import 'package:mobile/pages/Register.dart';
import 'package:mobile/services/app_state.dart';
import 'package:provider/provider.dart';
import 'package:mobile/Components/GradiantMesh.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';
  late RootAppState _appState;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    _appState = Provider.of<RootAppState>(context);

    return Scaffold(
      backgroundColor: _theme.colorScheme.primaryContainer,
      body: Stack(
        children: [
          MeshGradientBackground(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Logo
                Image.file(
                  File('assets\\Logo.png'),
                  height: 150,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 20),

                // Form
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          decoration:
                              InputDecoration(labelText: 'username / email'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Username is required and cannot be empty';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _username = value!;
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'password'),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password is required and cannot be empty';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _password = value!;
                          },
                        ),
                        SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: tryLogin,
                          child: Text('Login'),
                        ),
                        Container(
                          height: 2,
                          width: 150,
                          color: Colors.grey,
                          margin: EdgeInsets.symmetric(vertical: 8),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Register(),
                              ),
                            );
                          },
                          child: Text('Register'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void tryLogin() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _appState.Login(_username, _password).then((value) => {
            if (value['statusCode'] == 200)
              {
                if (!(_appState.user?.isParent ?? true))
                  {
                    _appState.GetUserPoints(),
                  },
                _appState.switchPage(AppPages.home),
              }
            else
              {
                CustomPopup.openErrorPopup(
                  context,
                  title: 'Couldn\'t login to user',
                  errorText: value['body']['error_message'].toString(),
                ),
              }
          });
    }
  }
}
