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

    if (confirmationPhoto == null) {
      return;
    }
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
          onPressed: _uploadTaskCompletionInfo,
          child: Text('Mark as complete'),
        ),
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // select completion photo
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFF5C53A),
            ),
            onPressed: () async {
              final ImagePicker picker = ImagePicker();
              var file = await picker.pickImage(
                source: ImageSource.gallery,
              );
              if (file != null) {
                setState(() {
                  confirmationPhoto = file;
                });
              }
            },
            child: Text('Select completion photo'),
          ),
          SizedBox(
            height: 15,
          ),
          if (confirmationPhoto != null)
            Image.file(File(confirmationPhoto!.path)),
        ],
      ),
    );
  }
}
