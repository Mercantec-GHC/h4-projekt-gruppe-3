import 'package:flutter/material.dart';
import 'package:mobile/config/app_pages.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';

class UserProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<RootAppState>();
    // Access the user from the AppState
    final user = Provider.of<RootAppState>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      //color for the entire background
      backgroundColor: Colors.lightBlue[50],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Display the user's name
              Text(
                user?.name ?? 'No Name Provided',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              // Display the user's email
              Text(
                user?.email ?? 'No Email Provided',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 24),
              //edit profile button
              ElevatedButton(
                onPressed: () {
                  appState.switchPage(AppPages.updateUserProfile);
                },
                child: Text('Edit Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
