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
  List<Title> _getTitles() =>
  [
    Title('Home', AppPages.home, Icons.home),
    Title('Profile', AppPages.userProfile, Icons.person),
    Title('Edit Profile', AppPages.updateUserProfile, Icons.settings),
    Title('Logout', AppPages.login, Icons.logout, Logout),
  ];

  Widget _getSelectedPage() {
    switch (appState?.page) {
      case AppPages.home:
        return Home();
      case AppPages.login:
        return Login();
      case AppPages.register:
        return Register();
      case AppPages.userProfile:
        return UserProfilePage();
      case AppPages.updateUserProfile:
        return UpdateUserProfilePage();
      default:
        throw UnimplementedError('No widget for ${appState?.page.name}');
    }
  }
  
  void Logout() {
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
    List<Title> titles = _getTitles();
    
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
            for (Title title in titles)
              ListTile(
                leading: Icon(title.icon, color: _getSelectedColor(title.destination)),
                title: Text(
                  title.title,
                  style: TextStyle(color: _getSelectedColor(title.destination)),
                ),
                onTap: () => {
                  if (title.action == null){
                    _onItemTapped(title.destination)
                  }
                  else {
                    title.action?.call(),
                  }
                } 
              ),
          ],
        ),
      ),
      body: Center(
        child: _getSelectedPage(),
      ),
    );
  }
}

class Title {
  String title;
  AppPages destination;
  IconData icon;
  VoidCallback? action;

  Title(this.title, this.destination, this.icon, [ this.action ]);
}