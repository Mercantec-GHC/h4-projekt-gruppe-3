import 'package:flutter/material.dart';
import 'package:mobile/Components/UserProfileCard.dart';
import 'package:mobile/models/UserProfile.dart';
import 'package:mobile/Components/GradiantMesh.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  late RootAppState _appState;
  List<UserProfile> users = [];

  @override
  void initState() {
    super.initState();
    _appState = Provider.of<RootAppState>(context, listen: false);
    _getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: MeshGradientBackground(),
          ),
          // Main Content
          Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Leaderboard Header
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 8, right: 8, left: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Leaderboard',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Users List
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors
                                  .transparent, // Make the user list container transparent
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: FractionallySizedBox(
                                widthFactor: 1,
                                child: Column(
                                  children: [
                                    for (UserProfile userProfile in users)
                                      Userprofilecard(
                                        name: userProfile.name,
                                        points: userProfile.total_points,
                                        page: 'leaderboard',
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _getUsers() async {
    Map<String, dynamic> response =
        await _appState.getLeaderboard(_appState.family!.id);
    if (response['statusCode'] == 200) {
      setState(() {
        users.clear();
        users.addAll(response['users']);
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Something went wrong'),
          content: Text(response['Error']['message']),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        ),
      );
    }
  }
}
