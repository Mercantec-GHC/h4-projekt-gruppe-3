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

    // appState.storage.read(key: 'auth_token').then((value) => print(value));

    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
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
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      appState.switchPage(AppPages.updateUserProfile);
                    },
                    child: Text('Edit Profile'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Confirm deletion
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Confirm Deletion'),
                          content: Text(
                              'Are you sure you want to delete this user?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                appState.deleteUser().then((value) => {
                                  if (value['statusCode'] == 204)
                                  {
                                    appState.switchPage(AppPages.login),
                                  }
                                  else
                                  {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text('Couldn\'t delete user'),
                                        content: Text(value['body'].toString()),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Close'),
                                          ),
                                        ],
                                      ),
                                    )
                                  }
                                });
                                Navigator.of(context).pop();
                              },
                              child: Text('Delete'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Text('Delete Account'),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
