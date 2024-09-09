import 'package:flutter/material.dart';
import 'package:mobile/Components/ColorScheme.dart';
import 'package:mobile/NavigationComponents/DrawerItem.dart';
import 'package:mobile/config/app_pages.dart';
import 'package:provider/provider.dart';
import 'package:mobile/services/app_state.dart';
import 'package:mobile/config/general_config.dart';

class NavDrawer extends StatefulWidget {
  final Map<AppPages, DrawerItem> titles;

  const NavDrawer({super.key, required this.titles});

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  late RootAppState _appState;

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
                CircleAvatar(
                  radius: 30,
                  backgroundColor: CustomColorScheme.limeGreen,
                  backgroundImage: AssetImage('assets/account_circle.png'),
                  foregroundImage: NetworkImage(
                    baseUrl + '/api/user/${_appState.user?.id}/profile/picture',
                  ),
                ),
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
          for (var title in widget.titles.entries)
            if (title.value.show)
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
