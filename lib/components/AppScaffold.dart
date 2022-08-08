import 'package:flutter/material.dart';

/**
 * Wraps scaffold with GestureDetector because Flutter input fields are unable to unfocus on its own
 * This is mainly used on screens where input fields are present
 */
class AppScaffold extends StatelessWidget {
  Widget body;
  PreferredSizeWidget appBar;
  Color backgroundColor;

  AppScaffold({required this.body, required this.appBar, this.backgroundColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: appBar,
        body: body,
        backgroundColor: backgroundColor,
      ),

    );
  }
}