import 'package:flutter/material.dart';

class DrawerItem {
  String title;
  IconData icon;
  StatefulWidget? page;
  VoidCallback? action;
  bool show;

  DrawerItem({
    required this.title,
    required this.icon,
    this.page,
    this.action,
    this.show = true,
  });
}
