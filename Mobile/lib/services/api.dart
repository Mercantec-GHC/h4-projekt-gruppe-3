import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobile/config/general_config.dart';

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

  void Delete() {}
}
