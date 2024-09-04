import 'package:flutter/material.dart';
import 'package:mobile/Components/TaskList.dart';
import 'package:mobile/Components/TaskSelectedList.dart';
import 'package:mobile/NavigationComponents/NavigationDrawer.dart';
import 'package:mobile/config/app_pages.dart';
import 'package:mobile/pages/Register.dart';
import 'package:mobile/pages/home.dart';
import 'package:mobile/pages/login.dart';
import 'package:mobile/pages/update_user_profile.dart';
import 'package:mobile/pages/user_profile.dart';
import 'package:mobile/services/app_state.dart';
import 'package:provider/provider.dart';
import 'package:mobile/pages/leaderboard.dart';

class NavigationComponent extends StatefulWidget {
  @override
  State<NavigationComponent> createState() => _NavigationComponentState();
}

class _NavigationComponentState extends State<NavigationComponent> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  RootAppState? appState;

  Map<AppPages, Title> _getTitles() {
    return {
      AppPages.home: Title('Home', Icons.home, Home()),
      AppPages.userProfile: Title('Profile', Icons.person, UserProfilePage()),
      AppPages.updateUserProfile:
          Title('Edit Profile', Icons.settings, UpdateUserProfilePage(), false),
      AppPages.leaderboard:
          Title('Leaderboard', Icons.leaderboard, LeaderboardPage()),
      AppPages.AssignedTasks: Title('Assigned Tasks', Icons.list,
          TaskSelectedList(type: TasklistType.Assigned)),
      AppPages.AvailableTasks: Title('Available Tasks', Icons.list,
          TaskSelectedList(type: TasklistType.Available)),
      AppPages.CompletedTasks: Title('Completed Tasks', Icons.list,
          TaskSelectedList(type: TasklistType.Completed)),
      AppPages.PendingTasks: Title('Pending Tasks', Icons.list,
          TaskSelectedList(type: TasklistType.Pending)),
      AppPages.none: Title('Logout', Icons.logout, Login(), true, _logout),
      AppPages.login: Title('Logout', Icons.logout, Login(), false),
      AppPages.register: Title('Logout', Icons.logout, Register(), false),
    };
  }

  void _logout() {
    appState?.logout();
    _onItemTapped(AppPages.login);
  }

  Color? _getSelectedColor(AppPages index) {
    return appState?.page == index ? Colors.blue : null;
  }

  void _onItemTapped(AppPages appPage) {
    setState(() {
      appState?.switchPage(appPage);
    });
    // Close the drawer after selecting an item
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (appState == null) {
      appState = context.watch<RootAppState>();
    }
    Map<AppPages, Title> titles = _getTitles();
    bool? isLoggedIn = appState?.isLoggedInSync();

    if (!(isLoggedIn ?? false)) {
      return Scaffold(
        body: Center(child: titles[appState?.page]?.page),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      // if not logged in or root app state is null don't add drawer.
      appBar: !(isLoggedIn ?? false)
          ? null
          : AppBar(
              title: Text('Title'),
              backgroundColor: Color(0xFFF5C53A),
              actions: <Widget>[
                // maybe use this for user profile -_-
                // IconButton(
                //   icon: Icon(Icons.menu),
                //   onPressed: () {
                //     _scaffoldKey.currentState?.openDrawer();
                //   },
                // ),
              ],
            ),
      drawer: NavDrawer(),
      body: Center(
        child: titles[appState?.page]?.page,
      ),
    );
  }
}

class Title {
  String title;
  IconData icon;
  bool show = true;
  StatefulWidget page;
  VoidCallback? action;

  Title(this.title, this.icon, this.page, [this.show = true, this.action]);
}
