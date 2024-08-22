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
  @override
  Widget build(BuildContext context) {
    var rootState = context.watch<RootAppState>();
    bool isLoggedIn = rootState.isLoggedInSync();

    Widget page;
    switch (rootState.page) {
      case AppPages.home:
        page = Home();
        break;
      case AppPages.login:
        page = Login();
        break;
      case AppPages.register:
        page = Register();
        break;
      case AppPages.userProfile:
        page = UserProfilePage();
        break;
      case AppPages.updateUserProfile:
        page = UpdateUserProfilePage();
        break;
      default:
        throw UnimplementedError('No widget for ${rootState.page.name}');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            if (rootState.page != AppPages.login &&
                rootState.page != AppPages.register)
              SafeArea(
                child: NavigationRail(
                  extended: constraints.maxWidth >= 600,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.person),
                      label: Text('User Profile'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.settings),
                      label: Text('Update User Profile'),
                    ),
                    if (!isLoggedIn) // Only show Login if not logged in
                      NavigationRailDestination(
                        icon: Icon(Icons.login),
                        label: Text('Login'),
                      ),
                    if (!isLoggedIn) // Only show Register if not logged in
                      NavigationRailDestination(
                        icon: Icon(Icons.app_registration),
                        label: Text('Register'),
                      ),
                    if (isLoggedIn) // Only show Logout if logged in
                      NavigationRailDestination(
                        icon: Icon(Icons.logout),
                        label: Text('Logout'),
                      ),
                  ],
                  selectedIndex: isLoggedIn
                      ? rootState.page.index // Use actual index
                      : (rootState.page == AppPages.login ||
                              rootState.page == AppPages.register)
                          ? 2 // Adjust index if only showing login/register
                          : rootState.page.index,
                  onDestinationSelected: (value) {
                    if (isLoggedIn) {
                      if (value == (4 - (!isLoggedIn ? 2 : 0))) {
                        // Adjust Logout index based on login/register being hidden
                        rootState.logout();
                        rootState.switchPage(AppPages.login);
                      } else {
                        rootState.switchPage(AppPages.values[value]);
                      }
                    } else {
                      rootState.switchPage(AppPages.values[value + 2]);
                    }
                  },
                ),
              ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }
}
