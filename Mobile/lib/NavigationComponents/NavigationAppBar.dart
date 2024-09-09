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
          icon: CircleAvatar(
            backgroundColor: CustomColorScheme.limeGreen,
            backgroundImage: AssetImage('assets/account_circle.png'),
            foregroundImage: NetworkImage(
              baseUrl + '/api/user/${appState.user?.id}/profile/picture',
            ),
          ),
          onPressed: () {
            toggleProfileMenu();
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(50);
}
