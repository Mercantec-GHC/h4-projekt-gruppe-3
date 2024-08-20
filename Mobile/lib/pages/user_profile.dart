import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => RootAppState(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Profile Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UserProfilePage(),
    );
  }
}

class UserProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                  // needs to be sendt to the edit page
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: builder)
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
