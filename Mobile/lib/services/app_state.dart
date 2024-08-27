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

  Future<Map<String, dynamic>> updateUser({
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
    var response = await api.updateUserProfile(
      auth_token: auth_token,
      name: name,
      email: email,
      username: username,
    );
    notifyListeners();

    if (response.statusCode == 204) {
      return {
        'statusCode': response.statusCode,
      };
    }

    return {
      'statusCode': response.statusCode,
      'body': json.decode(response.body),
    };
  }

  Future<Map<String, dynamic>> updateUserPassword({
    required String auth_token,
    String? current_password,
    String? new_password,
    String? new_password_confirmation,
  }) async {
    var response = await api.updateUserPassword(
      auth_token: auth_token,
      current_password: current_password,
      new_password: new_password,
      new_password_confirmation: new_password_confirmation,
    );
    notifyListeners();

    if (response.statusCode == 204) {
      return {
        'statusCode': response.statusCode,
      };
    }

    return {
      'statusCode': response.statusCode,
      'body': json.decode(response.body),
    };
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

  void logout() async {
    api.Logout();
    storage.delete(key: 'auth_token');
    user = null;
    notifyListeners();
  }

  Future<Map<String, dynamic>> deleteUser() async {
    final response = await api.DeleteUser(user?.id, this);

    if (response.statusCode == 204) {
      user = null;
      notifyListeners();
    }

    return {'statusCode': response.statusCode, 'body': 'Something went wrong.'};
  }

  bool isLoggedInSync() {
    return user != null;
  }

  Future<Map<String, dynamic>> createTask(String title, String description, int reward, 
    DateTime? endDate, bool recurring, int recurringInterval, bool singleCompletion) async {
    final response = await api.createTask(title, description, reward, endDate, recurring, recurringInterval, singleCompletion, this);
    return {'statusCode': response.statusCode, 'body': 'Something went wrong.'};
  }
}
