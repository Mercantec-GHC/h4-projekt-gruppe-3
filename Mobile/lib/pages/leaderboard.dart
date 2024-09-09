import 'package:flutter/material.dart';
import 'package:mobile/Components/UserProfileCard.dart';
import 'package:mobile/models/UserProfile.dart';
import 'package:mobile/Components/GradiantMesh.dart';
import 'package:mobile/models/user.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../services/api.dart';

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
    final appState = context.watch<RootAppState>();
    final _theme = Theme.of(context);
    // Access the user from the AppState
    final user = Provider.of<RootAppState>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard'),
        backgroundColor: _theme.colorScheme.primaryContainer,
      ),
      backgroundColor: _theme.colorScheme.primaryContainer,
      body: Column(
        children: [
          Expanded(
            child: Card(
              elevation: 4,
              margin: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  MeshGradientBackground(),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: _theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Leaderboard', //maybe type the family name here
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
                      child: Container(
                        decoration: BoxDecoration(
                          color: _theme.colorScheme.primaryContainer,
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
    );
  }

  Future<void> _getUsers() async {
    Map<String, dynamic> response = await _appState.getLeaderboard(1);
    if (response['statusCode'] == 200) {
      setState(() {
        users.clear();
        users.addAll(response['users']);
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Something went wrong'),
          content: Text(response['Error']['message']),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        ),
      );
    }
  }
}
