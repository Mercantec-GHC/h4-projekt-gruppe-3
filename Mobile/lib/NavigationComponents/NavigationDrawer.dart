import 'package:flutter/material.dart';
import 'package:mobile/Components/TaskList.dart';
import 'package:mobile/Components/TaskSelectedList.dart';
import 'package:mobile/config/app_pages.dart';
import 'package:mobile/pages/home.dart';
import 'package:mobile/pages/leaderboard.dart';
import 'package:mobile/pages/user_profile.dart';
import 'package:provider/provider.dart';
import 'package:mobile/services/app_state.dart';

class DrawerItem {
  String title;
  IconData icon;
  StatefulWidget? page;
  VoidCallback? action;

  DrawerItem({
    required this.title,
    required this.icon,
    this.page,
    this.action,
  });
}

class NavDrawer extends StatefulWidget {
  const NavDrawer({super.key});

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  late RootAppState _appState;

  Map<AppPages, DrawerItem> _titles = {};

  void _logout() {
    _appState.logout();
    _appState.switchPage(AppPages.login);
  }

  Color? _getSelectedColor(AppPages page) {
    return _appState.page == page ? Colors.blue : null;
  }

  void _onItemTapped(MapEntry<AppPages, DrawerItem> item) {
    if (item.value.action == null) {
      _appState.switchPage(item.key);
      // Close the drawer after selecting an item
      Navigator.pop(context);
    } else {
      item.value.action?.call();
    }
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
      AppPages.AssignedTasks: DrawerItem(
        title: 'Assigned Tasks',
        icon: Icons.list,
        page: TaskSelectedList(type: TasklistType.Assigned),
      ),
      AppPages.AvailableTasks: DrawerItem(
        title: 'Available Tasks',
        icon: Icons.list,
        page: TaskSelectedList(type: TasklistType.Available),
      ),
      AppPages.CompletedTasks: DrawerItem(
        title: 'Completed Tasks',
        icon: Icons.list,
        page: TaskSelectedList(type: TasklistType.Completed),
      ),
      AppPages.PendingTasks: DrawerItem(
        title: 'Pending Tasks',
        icon: Icons.list,
        page: TaskSelectedList(type: TasklistType.Pending),
      ),
      AppPages.none: DrawerItem(
        title: 'Logout',
        icon: Icons.logout,
        action: _logout,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    _appState = context.watch<RootAppState>();
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(Icons.account_circle, size: 80.0, color: Colors.white),
                SizedBox(height: 16.0),
                Text(
                  _appState.user?.name.toString() ?? 'No user logged in',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                  ),
                ),
              ],
            ),
          ),
          for (var title in _titles.entries)
            ListTile(
              leading:
                  Icon(title.value.icon, color: _getSelectedColor(title.key)),
              title: Text(
                title.value.title,
                style: TextStyle(color: _getSelectedColor(title.key)),
              ),
              onTap: () => {_onItemTapped(title)},
            ),
        ],
      ),
    );
  }
}
