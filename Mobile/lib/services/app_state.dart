import 'package:flutter/material.dart';
import 'package:mobile/config/app_pages.dart';
import 'package:mobile/models/user.dart';

class RootAppState extends ChangeNotifier {
  User? user;
  AppPages page = AppPages.login;

  void switchPage(AppPages newPage) {
    page = newPage;
    notifyListeners();
  }

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
