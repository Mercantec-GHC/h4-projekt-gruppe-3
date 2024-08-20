import 'package:flutter/material.dart';
import 'package:mobile/config/app_pages.dart';
import 'package:mobile/models/user.dart';
import 'package:mobile/pages/login.dart';
import 'package:mobile/services/app_state.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  Color _backgroundColor = Colors.greenAccent;
  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordRepeatController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    RootAppState rootAppState = Provider.of<RootAppState>(context);
    
    return Card(
      color: _backgroundColor == Colors.greenAccent ? theme.colorScheme.primary : _backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoginInputField(text: 'Name', controller: nameController, obscureText: false),
            SizedBox(height: 5),
            LoginInputField(text: 'Username', controller: usernameController, obscureText: false),
            SizedBox(height: 5),
            LoginInputField(text: 'Password', controller: passwordController, obscureText: true),
            SizedBox(height: 5),
            LoginInputField(text: 'Repeat password', controller: passwordRepeatController, obscureText: true),
            SizedBox(height: 10),

            ElevatedButton(
              onPressed: () { TryRegister(rootAppState); },
              child: Text('Register'),
            )
          ],
        ),
      ),
    );
  }

  void TryRegister(RootAppState rootAppState) {
    Color fail = Colors.red.shade900;

    String password = passwordController.value.text;
    if (password != passwordRepeatController.value.text) {
      setState(() {
        _backgroundColor = fail;
      });
      return;
    }

    String name = nameController.value.text;
    String email = usernameController.value.text;

    rootAppState.user = new User(name, password, email);
    rootAppState.switchPage(AppPages.generatorPage);
  }
}