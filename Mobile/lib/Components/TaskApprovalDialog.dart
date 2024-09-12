import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mobile/Components/ColorScheme.dart';
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
  final Api _api = Api();
  late RootAppState _appState;
  late List<User> _assignedUsers;
  late User _selectedUser;
  late String _auth_token;
  bool _loaded = false;

  void _approveTask() async {
    Response response = await _api.approveTaskForUser(
      auth_token: _auth_token,
      task_id: widget.task.id,
      user_id: _selectedUser.id,
    );

    if (response.statusCode == 204) {
      Navigator.of(context).pop();
      return;
    }
  }

  void _getPendingTaskUsers() async {
    final jwt = await _appState.storage.read(key: 'auth_token');
    if (jwt == null) {
      return;
    }

    Response response = await _api.getPendingTaskUsers(
      auth_token: jwt,
      task_id: widget.task.id,
    );
    var jsonData = json.decode(response.body);
    List<User> users = [];
    if (response.statusCode == 200) {
      for (var user in jsonData) {
        users.add(
          new User(
            user['id'],
            user['name'],
            '', // The email isn't required in this case as, this is only used to get name and id of the user
          ),
        );
      }
    } else {
      CustomPopup.openErrorPopup(context, errorText: jsonData);
      return;
    }

    setState(() {
      _assignedUsers = users;
      _selectedUser = users.first;
      _auth_token = jwt;
      _loaded = true;
    });
  }

  void _changeSelectedUser(User? user) {
    if (user == null) {
      return;
    }

    setState(() {
      _selectedUser = user;
    });
  }

  @override
  void initState() {
    super.initState();
    _appState = Provider.of<RootAppState>(context, listen: false);
    _getPendingTaskUsers();
  }

  @override
  Widget build(BuildContext context) {
    _appState = context.watch<RootAppState>();
    return AlertDialog(
      backgroundColor: CustomColorScheme.primary,
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
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Select child:'),
          if (_loaded)
            DropdownButton(
              value: _selectedUser,
              items: _assignedUsers
                  .map((user) => DropdownMenuItem(
                        value: user,
                        child: Text(user.name),
                      ))
                  .toList(),
              onChanged: _changeSelectedUser,
            ),
          SizedBox(
            height: 15,
          ),
          if (_loaded)
            Image.network(
              baseUrl +
                  '/api/task/${widget.task.id}/user/${_selectedUser.id}/completion-photo',
              headers: {
                HttpHeaders.authorizationHeader: 'Bearer ${_auth_token}'
              },
            ),
        ],
      ),
    );
  }
}
