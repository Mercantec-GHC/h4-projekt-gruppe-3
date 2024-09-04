import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:mobile/config/general_config.dart';
import 'package:mobile/models/family.dart';
import 'package:mobile/models/task.dart';
import 'package:mobile/models/user.dart';
import 'package:mobile/services/app_state.dart';

class Api {
  Future<http.Response> CreateParentUser(String name, String email,
      String password, String password_confirmation) async {
    return await http.post(
      Uri.parse(baseUrl + '/api/register'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json'
      },
      body: json.encode({
        'name': name,
        'is_parent': true,
        'username': email,
        'email': email,
        'password': password,
        'password_confirmation': password_confirmation,
      }),
    );
  }

  Future<http.Response> Login(String username, String password) async {
    return await http.post(
      Uri.parse(baseUrl + '/api/login'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json'
      },
      body: json.encode({
        'username': username,
        'password': password,
      }),
    );
  }

  Future<void> Logout() async {
    await http.post(Uri.parse(baseUrl + '/logout'));
  }

  Future<http.Response> GetFamilies() async {
    return await http.post(Uri.parse(baseUrl + '/api/family/all/'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json'
        });
  }

  Future<http.Response> GetFamily(Family family) async {
    return await http.post(Uri.parse(baseUrl + '/api/family/${family}'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json'
        });
  }

  Future<http.Response> createFamily(Family family, RootAppState appState) async {
    final jwt = await appState.storage.read(key: 'auth_token');
    return await http.post(
      Uri.parse(baseUrl + '/api/family/create'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + jwt.toString(),
      },
      body: json.encode({
        'title': family.name,
      }),
    );
  }

  void Get() {}

  Future<http.Response> updateUserProfile({
    required String auth_token,
    String? name,
    String? email,
    String? username,
  }) async {
    return await http.put(
      Uri.parse(baseUrl + '/api/user/profile'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + auth_token
      },
      body: json.encode({
        'name': name,
        'email': email,
        'username': username,
      }),
    );
  }

  Future<http.Response> updateUserPassword({
    required String auth_token,
    String? current_password,
    String? new_password,
    String? new_password_confirmation,
  }) async {
    return await http.put(
      Uri.parse(baseUrl + '/api/user/password'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + auth_token
      },
      body: json.encode({
        'current_password': current_password,
        'new_password': new_password,
        'new_password_confirmation': new_password_confirmation,
      }),
    );
  }

  Future<http.Response> DeleteUser(int? id, RootAppState appState) async {
    final jwt = await appState.storage.read(key: 'auth_token');
    return await http.delete(
      Uri.parse(baseUrl + '/api/user/' + id.toString()),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + jwt.toString(),
      },
    );
  }

  Future<http.Response> updateUserProfilePicture({
    required String auth_token,
    required XFile file,
  }) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(baseUrl + '/api/user/profile/picture'),
    );
    request.headers['Authorization'] = 'Bearer ' + auth_token;
    request.headers['Accept'] = 'application/json';
    request.headers['Content-Type'] = 'multipart/form-data';
    request.files.add(
      await http.MultipartFile.fromPath(
        'profile_photo',
        file.path,
      ),
    );
    var response = await request.send();
    return http.Response.fromStream(response);
  }

  Future<http.Response> getUsersAssignToTask(int taskId, RootAppState appState) async {
    final jwt = await appState.storage.read(key: 'auth_token');
    return await http.get(
      Uri.parse(baseUrl + "/api/task/users/${taskId}"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + jwt.toString(),
      },
    );
  }

  Future<http.Response> createTask(Task task, RootAppState appState) async {
    final jwt = await appState.storage.read(key: 'auth_token');
    return await http.post(
      Uri.parse(baseUrl + '/api/task/create'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + jwt.toString(),
      },
      body: json.encode({
        'title': task.title,
        'description': task.description,
        'reward': task.reward,
        'end_date': task.endDate.toString(),
        'start_date': DateTime.now().toString(),
        'recurring': task.recurring,
        'recurring_interval': task.recurringInterval,
        'modified_by': appState.user?.id,
        'family_id': 1,
        'single_completion': task.singleCompletion,
      }),
    );
  }

  Future<http.Response> getTasks(String path, RootAppState appState) async {
    final jwt = await appState.storage.read(key: 'auth_token');
    return await http.get(
      Uri.parse(baseUrl + path),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + jwt.toString(),
      },
    );
  }

  Future<http.Response> updateTask(Task task, RootAppState appState) async {
    final jwt = await appState.storage.read(key: 'auth_token');
    return await http.put(
      Uri.parse(baseUrl + '/api/task/${task.id}'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + jwt.toString(),
      },
      body: json.encode({
        'title': task.title,
        'description': task.description,
        'reward': task.reward,
        'end_date': task.endDate.toString(),
        'start_date': DateTime.now().toString(),
        'recurring': task.recurring,
        'recurring_interval': task.recurringInterval,
        'single_completion': task.singleCompletion,
      }),
    );
  }

  Future<http.Response> deleteTask(int id, RootAppState appState) async {
    final jwt = await appState.storage.read(key: 'auth_token');
    return await http.delete(
      Uri.parse(baseUrl + '/api/task/${id}'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + jwt.toString(),
      },
    );
  }

  Future<http.Response> uploadTaskCompletionInfo({
    required String auth_token,
    required XFile file,
    required Position location,
    required int task_id,
  }) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
        baseUrl + '/api/task/' + task_id.toString() + '/add/completion-info',
      ),
    );
    request.headers['Authorization'] = 'Bearer ' + auth_token;
    request.headers['Accept'] = 'application/json';
    request.headers['Content-Type'] = 'multipart/form-data';
    request.files.add(
      await http.MultipartFile.fromPath(
        'photo',
        file.path,
      ),
    );
    request.fields['latitude'] = location.latitude.toString();
    request.fields['longitude'] = location.longitude.toString();
    var response = await request.send();
    return await http.Response.fromStream(response);
  }

  Future<http.Response> getLeaderboard(
      int familyId, RootAppState appState) async {
    final jwt = await appState.storage.read(key: 'auth_token');
    return await http.get(
      Uri.parse(baseUrl + '/api/user/family/${familyId}/profiles'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + jwt.toString(),
      },
    );
  }
}
