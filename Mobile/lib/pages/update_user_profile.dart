import 'package:flutter/material.dart';
import 'package:mobile/Components/ChangePasswordDialog.dart';
import 'package:mobile/Components/FormInputField.dart';
import 'package:mobile/config/app_pages.dart';
import 'package:mobile/services/api.dart';
import 'package:mobile/services/app_state.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class UpdateUserProfilePage extends StatefulWidget {
  @override
  _UpdateUserProfilePageState createState() => _UpdateUserProfilePageState();
}

class _UpdateUserProfilePageState extends State<UpdateUserProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  late RootAppState _appState;

  @override
  void initState() {
    super.initState();
  }

  void _updateUserProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String? _auth_token = await _appState.storage.read(key: 'auth_token');

      if (_auth_token == null) {
        _appState.switchPage(AppPages.login);
        Navigator.pop(context);
        return;
      }

      var result = await _appState.updateUser(
        auth_token: _auth_token,
        name: _name,
        email: _email,
        username: _email,
      );

      if (result['statusCode'] == 200) {
        Navigator.pop(context);
      }
    }
  }

  void _updateProfilePicture(XFile file) async {
    final Api api = new Api();
    String? _auth_token = await _appState.storage.read(key: 'auth_token');

    if (_auth_token == null) {
      _appState.switchPage(AppPages.login);
      Navigator.pop(context);
      return;
    }

    api.updateUserProfilePicture(auth_token: _auth_token, file: file);
  }

  @override
  Widget build(BuildContext context) {
    _appState = context.watch<RootAppState>();
    final currentUser = _appState.user;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit profile'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              width: 300,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
              ),
              child: Text(
                "User profile",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              width: 300,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(15),
                ),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Name Field
                    FormInputField(
                      fieldLabel: 'Name',
                      placeholder: 'Fullname',
                      initialValue: currentUser?.name,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Name is required and cannot be empty';
                        }
                        return null;
                      },
                      onSave: (value) {
                        _name = value!;
                      },
                    ),
                    SizedBox(height: 20),

                    // Email Field
                    FormInputField(
                      fieldLabel: 'Email',
                      placeholder: 'example@example.com',
                      initialValue: currentUser?.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required and cannot be empty';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'The entered email is not a valid email';
                        }
                        return null;
                      },
                      onSave: (value) {
                        _email = value!;
                      },
                    ),
                    SizedBox(height: 20),

                    // Change Password Button
                    ElevatedButton(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => ChangePasswordDialog(),
                      ),
                      child: Text('Change Password'),
                    ),
                    SizedBox(height: 10),

                    // Change Photo Button
                    ElevatedButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        var file = await picker.pickImage(
                          source: ImageSource.gallery,
                        );
                        if (file != null) {
                          _updateProfilePicture(file);
                        }
                      },
                      child: Text('Change Photo'),
                    ),
                    SizedBox(height: 20),

                    // Cancel and Save Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            // _appState.switchPage(AppPages.userProfile);
                          },
                          child: Text(
                            'Cancel',
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: Color(0xFFF06E51),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _updateUserProfile,
                          child: Text('Save'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF89D56B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
