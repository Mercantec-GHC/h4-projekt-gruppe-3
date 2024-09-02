import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/models/task.dart';
import 'package:mobile/services/api.dart';
import 'package:mobile/services/geolocation_service.dart';
import 'package:provider/provider.dart';
import 'package:mobile/services/app_state.dart';

class TaskCompletionDialog extends StatefulWidget {
  final Task task;

  const TaskCompletionDialog({
    super.key,
    required Task this.task,
  });

  @override
  State<TaskCompletionDialog> createState() => _TaskCompletionDialogState();
}

class _TaskCompletionDialogState extends State<TaskCompletionDialog> {
  late RootAppState _appState;
  final Api _api = Api();
  final GeolocationService _geoLocationService = GeolocationService();
  Position? _currentLocation;
  XFile? confirmationPhoto;

  void _uploadTaskCompletionInfo() async {
    String? _auth_token = await _appState.storage.read(key: 'auth_token');

    _currentLocation = await _geoLocationService.getCurrentLocation();

    var result = await _api.uploadTaskCompletionInfo(
      auth_token: _auth_token!,
      file: confirmationPhoto!,
      location: _currentLocation!,
      task_id: widget.task.id,
    );

    if (result.statusCode == 204) {
      Navigator.of(context).pop();
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    _appState = context.watch<RootAppState>();
    return AlertDialog(
      title: Text('Mark task as completed'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: _uploadTaskCompletionInfo,
          child: Text('Confirm'),
        ),
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (confirmationPhoto != null)
            Image.file(File(confirmationPhoto!.path)),
          // select completion photo
          ElevatedButton(
            onPressed: () async {
              final ImagePicker picker = ImagePicker();
              var file = await picker.pickImage(
                source: ImageSource.gallery,
              );
              if (file != null) {
                setState(() {
                  confirmationPhoto = file;
                });
                // confirmationPhoto = file;
              }
            },
            child: Text('Select completion photo'),
          ),
        ],
      ),
    );
  }
}
