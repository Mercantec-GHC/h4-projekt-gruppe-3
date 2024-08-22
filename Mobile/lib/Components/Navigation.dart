import 'package:flutter/material.dart';
import 'package:mobile/config/app_pages.dart';
import 'package:mobile/pages/Register.dart';
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
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var rootState = context.watch<RootAppState>();
    Widget page;
    switch (rootState.page) {
      case AppPages.login:
        page = Login();
        break; // Add break statements to avoid fall-through
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
                      icon: Icon(Icons.person),
                      label: Text('User Profile'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.settings),
                      label: Text('Update User Profile'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.login),
                      label: Text('Login'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.app_registration),
                      label: Text('Register'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.logout),
                      label: Text('Logout'),
                    ),
                  ],
                  selectedIndex: rootState.page.index,
                  onDestinationSelected: (value) {
                    // index need to match logout index
                    if (value == 4) {
                      rootState.logout();
                      rootState.switchPage(AppPages.login);
                    } else {
                      rootState.switchPage(AppPages.values[value]);
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
