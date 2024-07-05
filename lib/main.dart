import 'package:course_correct/pages/profile_page.dart';
import 'package:course_correct/pages/test_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Course Correct',
      debugShowCheckedModeBanner: false,
      routes: {
        '/profilepage' : (context) => ProfilePage1(),
      },
      theme: ThemeData(
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontFamily: 'Schyler', fontWeight: FontWeight.bold),
        ),
      ),
      home: TestPage(),
    );
  }
}