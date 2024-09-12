import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mobile/Components/CustomPopup.dart';
import 'package:mobile/config/general_config.dart';
import 'package:mobile/models/task.dart';
import 'package:mobile/models/user.dart';
import 'package:mobile/services/api.dart';
import 'package:provider/provider.dart';
import 'package:mobile/services/app_state.dart';

class TaskApprovalDialog extends StatefulWidget {
  final Task task;

  const TaskApprovalDialog({
    super.key,
    required Task this.task,
  });

  @override
  State<TaskApprovalDialog> createState() => _TaskApprovalDialogState();
}

class _TaskApprovalDialogState extends State<TaskApprovalDialog> {
  late RootAppState _appState;
  String? _auth_token;
  bool _loaded = false;
  final Api _api = Api();

  void _approveTask() async {
    // if (result.statusCode == 204) {
    //   Navigator.of(context).pop();
    //   return;
    // }
  }

  void _declineTask() async {
    // if (result.statusCode == 204) {
    //   Navigator.of(context).pop();
    //   return;
    // }
  }

  // Future<List<User>> _getuserAssignedToThisTask() async {
  //   Response response =
  //       await _api.getUsersAssignToTask(widget.task.id, _appState);
  //   var jsonData = json.decode(response.body);
  //   if (response.statusCode == 200) {
  //     List<User> newUsers = [];
  //     for (var user in jsonData) {
  //       newUsers.add(new User(user['id'], user['name'], user['email'],
  //           _getBool(user['is_parent'])));
  //     }
  //   } else {
  //     CustomPopup.openErrorPopup(context, errorText: jsonData['Error']);
  //     return [];
  //   }
  // }

  void _getAuthToken() async {
    String? _token = await _appState.storage.read(key: 'auth_token');
    setState(() {
      _auth_token = _token;
      _loaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _appState = Provider.of<RootAppState>(context, listen: false);
    _getAuthToken();
  }

  @override
  Widget build(BuildContext context) {
    _appState = context.watch<RootAppState>();
    return AlertDialog(
      backgroundColor: Color(0xFF89D56B),
      title: Text(widget.task.title),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: _approveTask,
          child: Text('Approve'),
        ),
        TextButton(
          onPressed: _declineTask,
          child: Text('Decline'),
        ),
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 15,
          ),
          if (_loaded)
            Image.network(
              baseUrl + '/api/task/${widget.task.id}/completion-photo',
              headers: {
                HttpHeaders.authorizationHeader: 'Bearer ${_auth_token}'
              },
            ),
        ],
      ),
    );
  }
}
