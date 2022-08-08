import 'package:flutter/material.dart';
import 'package:flutter_to_do_list/pages/todo/HomePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List',
      theme: ThemeData(
        primarySwatch: Colors.yellow
      ),
      home: const HomePage(title: 'To-Do List Home Page'),
    );
  }
}

