import 'package:flutter/material.dart';
import 'package:mobile/models/user.dart';

class RootAppState extends ChangeNotifier {
  User? user;

  void UpdateUser(String name, String email) {
    if (user == null) {
      user = new User(name, "Password1!", email);
    }

    user?.name = name;
    user?.email = email;
    notifyListeners();
  }

  void CreateUser(String name, String password, String email) {
    user = new User(name, password, email);
    notifyListeners();
  }

  void deleteUser() {
    user = null;
    notifyListeners();
  }
}
