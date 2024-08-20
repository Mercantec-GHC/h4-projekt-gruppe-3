import 'package:flutter/material.dart';
import 'package:mobile/models/user.dart';

class RootAppState extends ChangeNotifier {
  User? user;

  void UpdateUser() {
    notifyListeners();
  }

  void CreateUser(String name, String password, String email) {
    user = new User(name, password, email);
    notifyListeners();
  }
}
