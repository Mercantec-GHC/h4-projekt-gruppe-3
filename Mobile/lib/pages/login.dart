import 'package:flutter/material.dart';
import 'package:mobile/config/app_pages.dart';
import 'package:mobile/models/user.dart';
import 'package:mobile/services/app_state.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Color _backgroundColor = Colors.greenAccent;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    RootAppState rootAppState = Provider.of<RootAppState>(context);
    if (rootAppState.user == null) 
    {
      rootAppState.user = new User('Test', 'Password1', 'email@gmail.com');
    }

    return Card(
      color: _backgroundColor == Colors.greenAccent ? theme.colorScheme.primary : _backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoginInputField(text: 'Username', controller: usernameController, obscureText: false),
            SizedBox(height: 5),
            LoginInputField(text: 'Password', controller: passwordController, obscureText: true),
            SizedBox(height: 7),

            ElevatedButton(
              onPressed: () { changeBackgroundColor(rootAppState); },
              child: Text('Login'),
            ),
            
            Container(
              height: 2,
              width: 150,
              color: Colors.grey,
              margin: EdgeInsets.symmetric(vertical: 8),
            ),

            ElevatedButton(
              onPressed: () { goToRegister(rootAppState); },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }

  bool TryLogin(RootAppState appState) {
    if (appState.user == null) {
      return false;
    }

    String? username = appState.user?.email;
    String? password = appState.user?.password;

    if (username == null || password == null) {
      return false;
    }

    if (usernameController.value.text == username && passwordController.value.text == password) {
      return true;
    }
    return false;
  }

  void changeBackgroundColor(RootAppState rootAppState) {
    bool succesInLoggingIn = TryLogin(rootAppState);
    setState(() {
      // Change the background color on button press
      _backgroundColor = succesInLoggingIn ? Colors.green.shade300 : Colors.red.shade900;
    });

    if (succesInLoggingIn) {
      rootAppState.switchPage(AppPages.generatorPage);
    }
  }
  void goToRegister(RootAppState rootAppState) {
    rootAppState.switchPage(AppPages.register);
  }
}

class LoginInputField extends StatelessWidget {
  const LoginInputField({
    super.key,
    required this.text,
    required this.controller,
    required this.obscureText,
  });

  final String text;
  final TextEditingController controller;
  final bool obscureText; 

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(text, style: TextStyle(color: theme.colorScheme.onSecondary)),
            ),
          ],
        ),
        TextField(
          controller: controller,
          obscureText: obscureText,
          enableSuggestions: !obscureText,
          autocorrect: !obscureText,
          style: TextStyle(color: theme.colorScheme.onSecondary),
          decoration: InputDecoration(
            enabledBorder: GetBorderStyle(theme),
            focusedBorder: GetBorderStyle(theme),
            hintText: text,
            hintStyle: TextStyle(color: theme.colorScheme.onSecondary),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder GetBorderStyle(ThemeData theme) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(22.0),
      borderSide: BorderSide(color: theme.colorScheme.onSecondary, width: 1),
    );
  }
}
