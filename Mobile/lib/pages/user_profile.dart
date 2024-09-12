import 'package:flutter/material.dart';
import 'package:mobile/Components/UserProfileCard.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import 'package:mobile/Components/GradiantMesh.dart'; // Import for MeshGradientBackground

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  Widget build(BuildContext context) {
    // Access the user from the AppState
    final user = Provider.of<RootAppState>(context).user;

    return Scaffold(
      body: Stack(
        children: [
          // Full-screen gradient background
          Positioned.fill(
            child:
                MeshGradientBackground(), // Use the custom MeshGradientBackground
          ),
          // Main content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Profile Card with gradient background
                Expanded(
                  child: Container(
                    child: Card(
                      elevation: 0,
                      margin: EdgeInsets.zero,
                      color: Colors.transparent,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8, right: 8, left: 8),
                            child: Container(
                              padding: EdgeInsets.all(16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Profile Cards',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: FractionallySizedBox(
                                  widthFactor: 1,
                                  child: Userprofilecard(
                                    userId: user!.id,
                                    email: user.email,
                                    name: user.name,
                                    page: 'user_profile',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
