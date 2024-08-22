import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:mobile/config/app_pages.dart';
import 'package:mobile/models/user.dart';
import 'package:mobile/services/api.dart';

class RootAppState extends ChangeNotifier {
  final storage = new FlutterSecureStorage();
  User? user;
  Api api = new Api();
  AppPages page = AppPages.login;

  void switchPage(AppPages newPage) {
    page = newPage;
    notifyListeners();
  }

  Future<void> updateUser({
    required String auth_token,
    String? name,
    String? email,
    String? username,
  }) async {
    if (name != null) {
      user?.name = name;
    }
    if (email != null) {
      user?.email = email;
    }
    await api.updateUserProfile(
      auth_token: auth_token,
      name: name,
      email: email,
      username: username,
    );
    notifyListeners();
  }

  Future<Map<String, dynamic>> CreateUser(String name, String password,
      String email, String password_confirmation) async {
    final response = await api.CreateParentUser(
        name, email, password, password_confirmation);

    var jsonData = json.decode(response.body);
    if (response.statusCode == 201) {
      user = new User(jsonData['user']['id'], jsonData['user']['name'],
          jsonData['user']['email']);
      storage.write(key: 'auth_token', value: jsonData['token']);
      notifyListeners();
    }

    return {'statusCode': response.statusCode, 'body': jsonData};
  }

  Future<Map<String, dynamic>> Login(String username, String password) async {
    final response = await api.Login(username, password);

    var jsonData = json.decode(response.body);
    if (response.statusCode == 200) {
      user = new User(jsonData['user']['id'], jsonData['user']['name'],
          jsonData['user']['email']);
      storage.write(key: 'auth_token', value: jsonData['token']);
      notifyListeners();
    }

    return {'statusCode': response.statusCode, 'body': jsonData};
  }

  void deleteUser() {
    user = null;
    notifyListeners();
  }
}
