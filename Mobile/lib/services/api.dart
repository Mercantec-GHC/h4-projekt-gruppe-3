import 'package:http/http.dart' as http;
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

  void Get() {}

  void Update() {}

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
}
