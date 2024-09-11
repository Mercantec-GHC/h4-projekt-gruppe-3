import 'package:flutter/material.dart';
import 'package:mobile/Components/ChildCreationDialog.dart';
import 'package:mobile/Components/CustomPopup.dart';
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

  void childCreation(UserProfile profile) {
    setState(() {
      users.add(profile);
    });
  }

  @override
  Widget build(BuildContext context) {
    _appState = context.watch<RootAppState>();
    final _theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard'),
        backgroundColor: _theme.colorScheme.primaryContainer,
      ),
      backgroundColor: _theme.colorScheme.primaryContainer,
      body: Stack(
        children: [
          Positioned.fill(
            child: MeshGradientBackground(),
          ),
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        'Leaderboard',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (_appState.user?.isParent ?? false)
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) =>
                                Childcreation(onCreation: childCreation),
                          );
                        },
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (UserProfile userProfile in users)
                          Userprofilecard(
                            userId: userProfile.id,
                            name: userProfile.name,
                            points: userProfile.total_points,
                            page: 'leaderboard',
                          ),
                      ],
                    ),
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
      CustomPopup.openErrorPopup(context,
          errorText: response['Error']['message']);
    }
  }
}
