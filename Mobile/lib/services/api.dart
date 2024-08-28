import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:mobile/config/general_config.dart';
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

  Future<http.Response> createTask(
    String title,
    String description,
    int reward,
    DateTime? endDate,
    bool recurring,
    int recurringInterval,
    bool singleCompletion,
    RootAppState appState,
  ) async {
    final jwt = await appState.storage.read(key: 'auth_token');
    return await http.post(Uri.parse(baseUrl + '/api/task/create'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + jwt.toString(),
        },
        body: json.encode({
          'title': title,
          'description': description,
          'reward': reward,
          'end_date': endDate.toString(),
          'start_date': DateTime.now().toString(),
          'recurring': recurring,
          'recurring_interval': recurringInterval,
          'modified_by': appState.user?.id,
          'family_id': 1,
          'single_completion': singleCompletion,
        }));
  }
}
