import 'package:flutter/material.dart';
import 'package:mobile/Components/ColorScheme.dart';
import 'package:mobile/Components/QuickAction.dart';
import 'package:mobile/Components/TaskList.dart';
import 'package:mobile/Components/TaskSelectedList.dart';
import 'package:mobile/NavigationComponents/DrawerItem.dart';
import 'package:mobile/NavigationComponents/NavigationAppBar.dart';
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
  late RootAppState _appState;
  String? jwt;

  Map<AppPages, DrawerItem> _titles = {};

  void _logout() {
    _appState.logout();
    _appState.switchPage(AppPages.login);
  }

  void getAuthToken() async {
    jwt = await _appState.storage.read(key: 'auth_token').toString();
  }

  @override
  void initState() {
    super.initState();

    _titles = {
      AppPages.home: DrawerItem(
        title: 'Home',
        icon: Icons.home,
        page: Home(),
      ),
      AppPages.userProfile: DrawerItem(
        title: 'Profile',
        icon: Icons.person,
        page: UserProfilePage(),
      ),
      AppPages.leaderboard: DrawerItem(
        title: 'Leaderboard',
        icon: Icons.leaderboard,
        page: LeaderboardPage(),
      ),
      AppPages.assignedTasks: DrawerItem(
        title: 'Assigned Tasks',
        icon: Icons.list,
        page: TaskSelectedList(type: TasklistType.Assigned),
      ),
      AppPages.availableTasks: DrawerItem(
        title: 'Available Tasks',
        icon: Icons.list,
        page: TaskSelectedList(type: TasklistType.Available),
      ),
      AppPages.completedTasks: DrawerItem(
        title: 'Completed Tasks',
        icon: Icons.list,
        page: TaskSelectedList(type: TasklistType.Completed),
      ),
      AppPages.pendingTasks: DrawerItem(
        title: 'Pending Tasks',
        icon: Icons.list,
        page: TaskSelectedList(type: TasklistType.Pending),
      ),
      AppPages.none: DrawerItem(
        title: 'Logout',
        icon: Icons.logout,
        action: _logout,
      ),
      AppPages.login: DrawerItem(
        title: 'Login',
        icon: Icons.logout,
        page: Login(),
        show: false,
      ),
      AppPages.register: DrawerItem(
        title: 'Register',
        icon: Icons.logout,
        page: Register(),
        show: false,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    _appState = context.watch<RootAppState>();
    bool isLoggedIn = _appState.isLoggedInSync();
    getAuthToken();

    if (!isLoggedIn) {
      return Scaffold(
        body: Center(child: _titles[_appState.page]?.page),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: !isLoggedIn && jwt != null
          ? null
          : NavAppBar(
              appState: _appState,
              page_title: _titles[_appState.page]?.title,
              jwt: jwt,
            ),
      drawer: NavDrawer(
        titles: _titles,
      ),
      body: Stack(children: [
        Center(
          child: _titles[_appState.page]?.page,
        ),
        QuickAction()
      ]),
    );
  }
}
