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
      case AppPages.register:
        page = Register();
      case AppPages.userProfile:
        page = UserProfilePage();
      case AppPages.updateUserProfile:
        page = UpdateUserProfilePage();
      default:
        throw UnimplementedError('no widget for ${rootState.page.name}');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 600,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.person),
                    label: Text('User profile'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.settings),
                    label: Text('Update user profiles'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.login),
                    label: Text('Login'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.app_registration),
                    label: Text('Register'),
                  ),
                ],
                selectedIndex: rootState.page.index,
                onDestinationSelected: (value) {
                  rootState.switchPage(AppPages.values[value]);
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
