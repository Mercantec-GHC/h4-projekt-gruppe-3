import 'package:flutter/material.dart';
import 'package:mobile/Components/ColorScheme.dart';
import 'package:mobile/Components/QuickAction.dart';
import 'package:mobile/Components/TaskList.dart';
import 'package:mobile/Components/TaskSelectedList.dart';
import 'package:mobile/NavigationComponents/DrawerItem.dart';
import 'package:mobile/NavigationComponents/NavigationAppBar.dart';
import 'package:mobile/NavigationComponents/NavigationDrawer.dart';
import 'package:mobile/config/app_pages.dart';
import 'package:mobile/config/task_list_types.dart';
import 'package:mobile/pages/Register.dart';
import 'package:mobile/pages/home.dart';
import 'package:mobile/pages/login.dart';
import 'package:mobile/pages/user_profile.dart';
import 'package:mobile/services/app_state.dart';
import 'package:provider/provider.dart';
import 'package:mobile/pages/leaderboard.dart';
import 'package:mobile/pages/Choose_family.dart';

class NavigationComponent extends StatefulWidget {
  @override
  State<NavigationComponent> createState() => _NavigationComponentState();
}

class _NavigationComponentState extends State<NavigationComponent> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late RootAppState _appState;
  bool _isProfileMenuVisible = false;
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
      AppPages.changeFamily: DrawerItem(
        title: 'Families',
        icon: Icons.people,
        page: ChooseFamilyPage(),
      ),
      AppPages.none: DrawerItem(
        title: 'Logout',
        icon: Icons.logout,
        action: _logout,
        show: false,
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

  void _toggleProfileMenu() {
    setState(() {
      _isProfileMenuVisible = !_isProfileMenuVisible;
    });
  }

  void _closeProfileMenu() {
    setState(() {
      _isProfileMenuVisible = false;
    });
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
              toggleProfileMenu: _toggleProfileMenu,
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
        if (_appState.user?.isParent ?? false) QuickAction(),
        if (_isProfileMenuVisible)
          GestureDetector(
            onTap: _closeProfileMenu,
            child: Container(
              color: Colors.transparent,
            ),
          ),
        AnimatedPositioned(
          duration: Duration(milliseconds: 300),
          top: _isProfileMenuVisible
              ? kToolbarHeight - 50
              : kToolbarHeight - 250,
          right: 16,
          child: GestureDetector(
            onTap: () {}, // Prevents the panel from closing when tapped inside
            child: Container(
              width: 200,
              height: _appState.family!.name.length < 11 ? 160 : 190,
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
                    Center(
                        child: Text(
                      "family: " + _appState.family!.name,
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
                                _titles[AppPages.none]?.title ?? '',
                                style: TextStyle(fontSize: 17.5),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(_titles[AppPages.none]?.icon),
                            ],
                          ),
                          onPressed: () => {
                                _closeProfileMenu(),
                                if (_titles[AppPages.none]?.action != null)
                                  {
                                    _titles[AppPages.none]?.action?.call(),
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
