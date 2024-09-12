import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:mobile/config/general_config.dart';
import 'package:mobile/models/family.dart';
import 'package:mobile/models/task.dart';

class Api {
  Future<http.Response> CreateParentUser(String name, String email,
      String password, String password_confirmation) async {
    return await http.post(
      Uri.parse(baseUrl + '/api/register'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
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

  Future<http.Response> CreateChildUser(
      String name,
      String username,
      String password,
      String password_confirmation,
      int parentId,
      String? jwt) async {
    return await http.post(
      Uri.parse(baseUrl + '/api/register'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + jwt.toString(),
      },
      body: json.encode({
        'name': name,
        'is_parent': false,
        'username': username,
        'password': password,
        'password_confirmation': password_confirmation,
        'parentId': parentId,
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

  Future<http.Response> GetFamilies(String? jwt) async {
    return await http.get(Uri.parse(baseUrl + '/api/family/all/'), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + jwt.toString(),
    });
  }

  Future<http.Response> GetFamily(Family family, String? jwt) async {
    return await http
        .get(Uri.parse(baseUrl + '/api/family/${family.id}'), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + jwt.toString(),
    });
  }

  Future<http.Response> createFamily(Family family, String? jwt) async {
    return await http.post(
      Uri.parse(baseUrl + '/api/family/create'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + jwt.toString(),
      },
      body: json.encode({
        'family_name': family.name,
      }),
    );
  }

  Future<http.Response> GetUserPoints(
      int userId, int familyId, String? jwt) async {
    return await http.get(
      Uri.parse(baseUrl + '/api/user/${familyId}/${userId}/points'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + jwt.toString(),
      },
    );
  }

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

  Future<http.Response> DeleteUser(int? id, String? jwt) async {
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

  Future<http.Response> getUsersAssignToTask(int taskId, String? jwt) async {
    return await http.get(
      Uri.parse(baseUrl + "/api/task/users/${taskId}"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + jwt.toString(),
      },
    );
  }

  Future<http.Response> createTask(
      Task task, int modifiedBy, String? jwt) async {
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
        'modified_by': modifiedBy,
        'family_id': 1,
        'single_completion': task.singleCompletion,
      }),
    );
  }

  Future<http.Response> getTasks(String path, String? jwt) async {
    return await http.get(
      Uri.parse(baseUrl + '/api/task/' + path),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + jwt.toString(),
      },
    );
  }

  Future<http.Response> updateTask(Task task, String? jwt) async {
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

  Future<http.Response> deleteTask(int id, String? jwt) async {
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

  Future<http.Response> getUserProfiles(int familyId, String? jwt) async {
    return await http.get(
      Uri.parse(baseUrl + '/api/user/family/${familyId}/profiles'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + jwt.toString(),
      },
    );
  }

  Future<http.Response> updateFamilyName({
    required String auth_token,
    String? name,
    int? family_id,
  }) async {
    return await http.put(
      Uri.parse(baseUrl + '/api/family/edit/${family_id}'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + auth_token
      },
      body: json.encode({
        'family_name': name,
      }),
    );
  }

  Future<http.Response> switchFamiyOwner({
    required String auth_token,
    int? new_owner_id,
    int? family_id,
  }) async {
    return await http.put(
      Uri.parse(baseUrl + '/api/family/switchOwner/${family_id}'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + auth_token
      },
      body: json.encode({
        'user_id': new_owner_id,
      }),
    );
  }
}
