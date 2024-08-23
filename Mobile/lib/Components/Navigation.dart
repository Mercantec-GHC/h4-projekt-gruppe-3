import 'package:flutter/material.dart';
import 'package:mobile/config/app_pages.dart';
import 'package:mobile/pages/Register.dart';
import 'package:mobile/pages/home.dart';
import 'package:mobile/pages/login.dart';
import 'package:mobile/pages/update_user_profile.dart';
import 'package:mobile/pages/user_profile.dart';
import 'package:mobile/services/app_state.dart';
import 'package:provider/provider.dart';

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
      AppPages.updateUserProfile: Title('Edit Profile', Icons.settings, UpdateUserProfilePage()),
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

    return Scaffold(
      key: _scaffoldKey,
      // if not logged in or root app state is null don't add drawer. 
      appBar: !(isLoggedIn ?? false) ? null : AppBar(
        title: Text('Title'),
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
                    appState?.user?.name.toString() ?? 'No user logged in',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                    ),
                  ),
                ],
              ),
            ),
            for (var title in titles.entries)
              if(title.value.show)
                ListTile(
                  leading: Icon(title.value.icon, color: _getSelectedColor(title.key)),
                  title: Text(
                    title.value.title,
                    style: TextStyle(color: _getSelectedColor(title.key)),
                  ),
                  onTap: () => {
                    if (title.value.action == null){
                      _onItemTapped(title.key)
                    }
                    else {
                      title.value.action?.call(),
                    }
                  } 
                ),
          ],
        ),
      ),
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

  Title(this.title, this.icon, this.page, [ this.show = true, this.action ]);
}