import 'package:http/http.dart' as http;
import 'dart:convert';

class Api {
  // final baseUrl = 'http://192.168.0.28:8000';
  final baseUrl = 'https://krc-coding.dk';
  Future<http.Response> CreateParentUser(String name, String email, String password, String password_confirmation) async {
    return await http.post(
      Uri.parse(baseUrl + '/api/register'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json'
      },
      body: json.encode({
        'name': name,
        'username': email,
        'is_parent': true,
        'email': email,
        'password': password,
        'password_confirmation': password_confirmation
      }),
    );
  }

  void Get() {

  }

  void Update() {

  }

  void Delete() { 

  }
}