import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:mobile/Components/TaskList.dart';
import 'package:mobile/config/app_pages.dart';
import 'package:mobile/models/task.dart';
import 'package:mobile/models/user.dart';
import 'package:mobile/models/family.dart';
import 'package:mobile/services/api.dart';

class RootAppState extends ChangeNotifier {
  final storage = new FlutterSecureStorage();
  User? user;
  Family? family;
  int points = 0;
  Map<TasklistType, List<Task>> taskList = new Map<TasklistType, List<Task>>();
  Api api = new Api();
  AppPages page = AppPages.login;

  void switchPage(AppPages newPage) {
    page = newPage;
    notifyListeners();
  }

  void AddTask(Task task, TasklistType type) {
    if (taskList.containsKey(type)) {
      taskList[type]!.add(task);
    } else {
      taskList[type]!.add(task);
    }
    notifyListeners();
  }

  void addListOfTasks(List<Task> newTasks, TasklistType type) {
    if (taskList.containsKey(type)) {
      taskList[type]!.clear();
      taskList[type]!.addAll(newTasks);
    } else {
      taskList[type] = newTasks;
    }
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

  Future<Map<String, dynamic>> CreateUser(
      String name,
      String password,
      String emailOrUsername,
      String password_confirmation,
      bool is_parent) async {
    final response;
    if (is_parent) {
      response = await api.CreateParentUser(
          name, emailOrUsername, password, password_confirmation);
    } else {
      final jwt = await storage.read(key: 'auth_token');
      response = await api.CreateChildUser(name, emailOrUsername, password,
          password_confirmation, user?.id ?? 0, jwt);
    }

    var jsonData = json.decode(response.body);
    if (response.statusCode == 201 && is_parent) {
      user = new User(
        jsonData['user']['id'],
        jsonData['user']['name'],
        jsonData['user']['email'],
      );
      await storage.write(key: 'auth_token', value: jsonData['token']);
      notifyListeners();
      await GetFamilies();
    }

    return {'statusCode': response.statusCode, 'body': jsonData};
  }

  Future<Map<String, dynamic>> Login(String username, String password) async {
    final response = await api.Login(username, password);

    var jsonData = json.decode(response.body);
    if (response.statusCode == 200) {
      user = new User(
        jsonData['user']['id'],
        jsonData['user']['name'],
        jsonData['user']['email'] ?? "",
        getBool(jsonData['user']['is_parent']),
      );
      await storage.write(key: 'auth_token', value: jsonData['token']);
      notifyListeners();
      await GetFamilies();
      if (!(user?.isParent ?? true))
      {
        GetUserPoints();
      }
    }

    return {'statusCode': response.statusCode, 'body': jsonData};
  }

  Future<Map<String, dynamic>> GetFamilies() async {
    String? jwt = await storage.read(key: 'auth_token').toString();
    final response = await api.GetFamilies(jwt);

    var jsonData = json.decode(response.body);
    if (response.statusCode == 200) {
      List<Family> newFamilies = [];
      for (var returnedFamily in jsonData) {
        newFamilies.add(new Family(
          returnedFamily['family_id'],
          returnedFamily['name'],
          returnedFamily['owner_id'],
        ));
      }
      if (family == null) {
        family = newFamilies[0];
      }
      notifyListeners();
      return {'statusCode': response.statusCode, 'family': newFamilies};
    } else {
      return {'statusCode': response.statusCode, 'error': jsonData};
    }
  }

  Future<void> logout() async {
    await api.Logout();
    storage.delete(key: 'auth_token');
    user = null;
    points = 0;
    notifyListeners();
  }

  void GetUserPoints() async {
    String? jwt = await storage.read(key: 'auth_token').toString();
    final response = await api.GetUserPoints(user?.id ?? 0, family?.id ?? 0, jwt);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      points = jsonData[
          'points'];
      notifyListeners();
    }
  }

  bool isLoggedInSync() {
    return user != null;
  }

  bool getBool(int value) {
    return value == 1;
  }
}
