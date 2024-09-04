import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mobile/config/app_pages.dart';
import 'package:mobile/models/UserProfile.dart';
import 'package:mobile/models/task.dart';
import 'package:mobile/models/user.dart';
import 'package:mobile/models/family.dart';
import 'package:mobile/services/api.dart';

class RootAppState extends ChangeNotifier {
  final storage = new FlutterSecureStorage();
  User? user;
  Family? family;
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
          jsonData['user']['email'], jsonData['user']['is_parent']);
      await storage.write(key: 'auth_token', value: jsonData['token']);
      notifyListeners();
    }

    return {'statusCode': response.statusCode, 'body': jsonData};
  }

  Future<Map<String, dynamic>> Login(String username, String password) async {
    final response = await api.Login(username, password);

    var jsonData = json.decode(response.body);
    if (response.statusCode == 200) {
      user = new User(jsonData['user']['id'], jsonData['user']['name'],
          jsonData['user']['email'], _getBool(jsonData['user']['is_parent']));
      await storage.write(key: 'auth_token', value: jsonData['token']);
      notifyListeners();
    }

    return {'statusCode': response.statusCode, 'body': jsonData};
  }
  
  Future<Map<String, dynamic>> GetFamilies() async {
    final response = await api.GetFamilies();

    var jsonData = json.decode(response.body);
    if (response.statusCode == 200) {
      List<Family> newFamilies = [];
      for (var returnedFamily in jsonData) {
        newFamilies.add(new Family(
            returnedFamily['id'],
            returnedFamily['name'],
            ));
      }
      //return {'statusCode': response.statusCode, 'users': newFamilies};
      //thise 2 lines below need to be removed and the line above need to be instated when we have a page to choose family
      family = newFamilies[1];
      notifyListeners();
    }

    return {'statusCode': response.statusCode, 'body': jsonData};
  }
  
  Future<Map<String, dynamic>> GetFamily(Family family) async {
    final response = await api.GetFamily(family);

    var jsonData = json.decode(response.body);
    if (response.statusCode == 200) {
      family = new Family(jsonData['family']['id'], jsonData['family']['name']);
      notifyListeners();
    }

    return {'statusCode': response.statusCode, 'body': jsonData};
  }

  Future<void> logout() async {
    await api.Logout();
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

  Future<int> createTask(Task task) async {
    return (await api.createTask(task, this)).statusCode;
  }

  Future<Map<String, dynamic>> getuserAssignedToTask(int taskId) async {
    final response = await api.getUsersAssignToTask(taskId, this);

    var jsonData = json.decode(response.body);
    if (response.statusCode == 200) {
      List<User> newUsers = [];
      if (jsonData.isEmpty) {
        return {'statusCode': response.statusCode, 'tasks': newUsers};
      }
      for (var user in jsonData) {
        newUsers.add(new User(
            user['id'],
            user['name'],
            user['email'],
            _getBool(user['is_parent'])
          ));
      }
      return {'statusCode': response.statusCode, 'tasks': newUsers};
    } else {
      return {'statusCode': response.statusCode, 'Error': jsonData['message']};
    }
  }

  Future<Map<String, dynamic>> getTasks(String path) async {
    final response = await api.getTasks('/api/task' + path, this);

    var jsonData = json.decode(response.body);
    if (response.statusCode == 200) {
      List<Task> newTasks = [];
      if (jsonData.isEmpty) {
        return {'statusCode': response.statusCode, 'tasks': newTasks};
      }

      for (var task in jsonData) {
        newTasks.add(new Task(
          task['id'],
          task['title'],
          task['description'],
          task['reward'],
          DateTime.parse(task['start_date']),
          DateTime.parse(task['end_date']),
          _getBool(task['recurring']),
          task['recurring_interval'],
          _getBool(task['single_completion'])
        ));
      }

      return {'statusCode': response.statusCode, 'tasks': newTasks};
    } else {
      return {'statusCode': response.statusCode, 'Error': jsonData['message']};
    }
  }

  Future<int> updateTask(Task task) async {
    return (await api.updateTask(task, this)).statusCode;
  }

  Future<int> deleteTask(int id) async {
    return (await api.deleteTask(id, this)).statusCode;
  }

  bool isLoggedInSync() {
    return user != null;
  }

  bool _getBool(int value) {
    return value == 1;
  }

  Future<Map<String, dynamic>> getLeaderboard(int familyId) async {
    final response = await api.getLeaderboard(familyId, this);

    var jsonData = json.decode(response.body);
    if (response.statusCode == 200) {
      List<UserProfile> newUsers = [];
      for (var user in jsonData) {
        newUsers.add(new UserProfile(
            user['name'],
            user['Email'],
            user['username'],
            user['is_parrent'] ?? false,
            user['points'],
            user['total_points']));
      }
      newUsers.sort((a, b) => b.total_points.compareTo(a.total_points));

      return {'statusCode': response.statusCode, 'users': newUsers};
    } else {
      return {'statusCode': response.statusCode, 'Error': jsonData};
    }
  }
}
