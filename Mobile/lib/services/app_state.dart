import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:mobile/config/app_pages.dart';
import 'package:mobile/config/task_list_types.dart';
import 'package:mobile/models/UserProfile.dart';
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
        _getBool(jsonData['user']['is_parent']),
      );
      await storage.write(key: 'auth_token', value: jsonData['token']);
      notifyListeners();
      await GetFamilies();
    }

    return {'statusCode': response.statusCode, 'body': jsonData};
  }

  Future<Map<String, dynamic>> GetFamilies() async {
    final response = await api.GetFamilies(this);

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

  Future<Map<String, dynamic>> GetFamily(Family family) async {
    final response = await api.GetFamily(family, this);

    var jsonData = json.decode(response.body);
    if (response.statusCode == 200) {
      family = new Family(
        jsonData['id'],
        jsonData['name'],
        jsonData['owner_id'],
      );
      notifyListeners();
      return {'statusCode': response.statusCode, 'body': family};
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
    int familyId = 1; // still don't know where i can get it
    final response = await api.GetUserPoints(user?.id ?? 0, familyId, this);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      points = jsonData[
          'points']; // you get the whole user?? and more users the more families you have
      notifyListeners();
    }
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

  Future<Map<String, dynamic>> getTasks(String path) async {
    final response = await api.getTasks('/api/task' + path, this);

    var jsonData = json.decode(response.body);
    if (response.statusCode == 200) {
      List<Task> newTasks = [];
      if (jsonData.isEmpty) {
        return {'statusCode': response.statusCode, 'tasks': newTasks};
      }

      for (var task in jsonData) {
        newTasks.add(
          new Task(
            task['id'],
            task['title'],
            task['description'],
            task['reward'],
            DateTime.parse(task['start_date']),
            DateTime.parse(task['end_date']),
            _getBool(task['recurring']),
            task['recurring_interval'],
            _getBool(task['single_completion']),
          ),
        );
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
    final response = await api.getUserProfiles(familyId, this);

    var jsonData = json.decode(response.body);
    if (response.statusCode == 200) {
      List<UserProfile> newUsers = [];
      for (var user in jsonData) {
        newUsers.add(
          new UserProfile(
            user['id'],
            user['name'],
            user['Email'],
            user['username'],
            user['is_parrent'] ?? false,
            user['points'],
            user['total_points'],
          ),
        );
      }
      newUsers.sort((a, b) => b.total_points.compareTo(a.total_points));

      return {'statusCode': response.statusCode, 'users': newUsers};
    } else {
      return {'statusCode': response.statusCode, 'Error': jsonData};
    }
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
            _getBool(
              user['is_parent'],
            )));
      }
      return {'statusCode': response.statusCode, 'tasks': newUsers};
    } else {
      return {'statusCode': response.statusCode, 'Error': jsonData['message']};
    }
  }

  Future<Map<String, dynamic>> getUsers(int familyId) async {
    final response = await api.getUserProfiles(familyId, this);

    var jsonData = json.decode(response.body);
    if (response.statusCode == 200) {
      List<User> newUsers = [];
      for (var user in jsonData) {
        newUsers.add(
          new User(
            user['id'],
            user['name'],
            user['email'],
            user['is_parrent'] ?? false,
          ),
        );
      }

      return {'statusCode': response.statusCode, 'users': newUsers};
    } else {
      return {'statusCode': response.statusCode, 'Error': jsonData};
    }
  }

  Future<Map<String, dynamic>> switchFamilyOwner({
    required String auth_token,
    int? owner_id,
  }) async {
    if (owner_id != null) {
      family?.ownerId = owner_id;
    }
    var response = await api.switchFamiyOwner(
      auth_token: auth_token,
      new_owner_id: owner_id,
      family_id: this.family?.id,
    );
    notifyListeners();

    if (response.statusCode == 200) {
      return {
        'statusCode': response.statusCode,
      };
    }

    return {
      'statusCode': response.statusCode,
      'body': json.decode(response.body),
    };
  }

  Future<Map<String, dynamic>> updateFamilyName({
    required String auth_token,
    String? name,
  }) async {
    if (name != null) {
      family?.name = name;
    }
    var response = await api.updateFamilyName(
      auth_token: auth_token,
      name: name,
      family_id: this.family?.id,
    );
    notifyListeners();

    if (response.statusCode == 200) {
      return {
        'statusCode': response.statusCode,
      };
    }

    return {
      'statusCode': response.statusCode,
      'body': json.decode(response.body),
    };
  }
}
