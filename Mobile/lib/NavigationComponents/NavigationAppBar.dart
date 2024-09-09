import 'package:flutter/material.dart';
import 'package:mobile/Components/ColorScheme.dart';
import 'package:mobile/config/general_config.dart';
import 'package:mobile/services/app_state.dart';

class NavAppBar extends StatelessWidget implements PreferredSizeWidget {
  final RootAppState appState;
  final VoidCallback toggleProfileMenu;
  final String? page_title;
  final String? jwt;

  const NavAppBar({
    super.key,
    required this.appState,
    required this.toggleProfileMenu,
    required this.page_title,
    required this.jwt,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: CustomColorScheme.secondary,
      title: appState.user?.isParent ?? false
          ? Text(page_title ?? '')
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
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.family_restroom),
          onPressed: () {
            toggleProfileMenu();
          },
        ),
        Container(
          width: 75,
          child: Center(
            child: CircleAvatar(
              radius: 15,
              backgroundImage: appState.user != null
                  ? NetworkImage(
                      baseUrl +
                          '/api/user/${appState.user?.id}/profile/picture',
                    )
                  : const AssetImage('assets/default_profile.png')
                      as ImageProvider, // Default image if no URL
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(50);
}
