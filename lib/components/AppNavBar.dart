import 'package:flutter/material.dart';

class AppNavBar extends StatelessWidget implements PreferredSizeWidget {
  final String label;
  final Widget? actionWidget;

  AppNavBar({required this.label, this.actionWidget});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        label,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.yellow.shade800,
      foregroundColor: Colors.black,
      actions: [actionWidget ?? Container()],
      elevation: 2,
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(AppBar().preferredSize.height);
}