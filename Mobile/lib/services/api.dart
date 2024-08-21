import 'package:http/http.dart' as http;
import 'dart:convert';

class Api {
  final baseUrl = 'https://krc-coding.dk';
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
        'username': email,
        'password': password,
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

  void Delete() {}
}
