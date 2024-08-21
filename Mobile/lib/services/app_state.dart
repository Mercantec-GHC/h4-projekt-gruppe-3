import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mobile/config/app_pages.dart';
import 'package:mobile/models/user.dart';
import 'package:mobile/services/api.dart';


class RootAppState extends ChangeNotifier {
  User? user;
  Api api = new Api();
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

  Future<Map<String, dynamic>> CreateUser(String name, String password, String email, String password_confirmation) async {
    final response = await api.CreateParentUser(name, email, password, password_confirmation);

    var jsonData = json.decode(response.body);
    if (response.statusCode == 201) {
      user = new User(jsonData['user']['name'], password, jsonData['user']['email']);
      notifyListeners();
    }

    return {
      'statusCode' : response.statusCode,
      'body': jsonData
    };
  }

  void deleteUser() {
    user = null;
    notifyListeners();
  }
}
