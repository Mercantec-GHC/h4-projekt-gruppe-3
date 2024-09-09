import 'package:flutter/material.dart';
import 'package:mobile/Components/ColorScheme.dart';
import 'package:mobile/Components/QuickAction.dart';
import 'package:mobile/Components/TaskList.dart';
import 'package:mobile/Components/TaskSelectedList.dart';
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
  late RootAppState appState;
  bool _isPanelVisible = false;

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
      AppPages.none: Title('Logout', Icons.logout, Login(), false, _logout),
      AppPages.login: Title('Logout', Icons.logout, Login(), false),
      AppPages.register: Title('Logout', Icons.logout, Register(), false),
    };
  }

  void _logout() {
    appState.logout();
    appState.switchPage(AppPages.login);
  }

  Color? _getSelectedColor(AppPages index) {
    return appState.page == index ? Colors.blue : null;
  }

  void _togglePanel() {
    setState(() {
      _isPanelVisible = !_isPanelVisible;
    });
  }

  void _closePanel() {
    setState(() {
      _isPanelVisible = false;
    });
  }

  void _onItemTapped(AppPages appPage) {
    setState(() {
      appState.taskList.clear();
      appState.switchPage(appPage);
    });
    // Close the drawer after selecting an item
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    appState = context.watch<RootAppState>();
    Map<AppPages, Title> titles = _getTitles();

    if (!appState.isLoggedInSync()) {
      return Scaffold(
        body: Center(child: titles[appState.page]?.page),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: CustomColorScheme.secondary,
        title: appState.user?.isParent ?? false
            ? null
            : Card(
                color: Colors.green,
                child: Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(appState.points.toString() + 'p'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.family_restroom),
            onPressed: () {
              _togglePanel();
            },
          ),
        ],
      ),
      drawer: Drawer(
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
                    appState.user?.name.toString() ?? 'No user logged in',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                    ),
                  ),
                ],
              ),
            ),
            for (var title in titles.entries)
              if (title.value.show)
                ListTile(
                    leading: Icon(title.value.icon,
                        color: _getSelectedColor(title.key)),
                    title: Text(
                      title.value.title,
                      style: TextStyle(color: _getSelectedColor(title.key)),
                    ),
                    onTap: () => {
                          if (title.value.action == null)
                            {_onItemTapped(title.key)}
                          else
                            {
                              title.value.action?.call(),
                            }
                        }),
          ],
        ),
      ),
      body: Stack(children: [
        Center(
          child: titles[appState.page]?.page,
        ),
        if (appState.user?.isParent ?? false) QuickAction(),
        if (_isPanelVisible)
          GestureDetector(
            onTap: _closePanel,
            child: Container(
              color: Colors.transparent,
            ),
          ),
        AnimatedPositioned(
          duration: Duration(milliseconds: 300),
          top: _isPanelVisible ? kToolbarHeight - 50 : kToolbarHeight - 250,
          right: 16,
          child: GestureDetector(
            onTap: () {}, // Prevents the panel from closing when tapped inside
            child: Container(
              width: 200,
              height: 130,
              decoration: BoxDecoration(
                color: CustomColorScheme.menu,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Center(
                        child: Text(
                      "Profile menu",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )),
                    SizedBox(height: 10),
                    Container(
                      width: 200,
                      child: FloatingActionButton(
                          elevation: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                titles[AppPages.none]?.title ?? '',
                                style: TextStyle(fontSize: 17.5),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(titles[AppPages.none]?.icon),
                            ],
                          ),
                          onPressed: () => {
                                _closePanel(),
                                if (titles[AppPages.none]?.action != null)
                                  {
                                    titles[AppPages.none]?.action?.call(),
                                  }
                              }),
                    ),
                    Container(
                      height: 2,
                      width: 150,
                      color: Colors.grey,
                      margin: EdgeInsets.symmetric(vertical: 8),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
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
