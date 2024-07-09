import 'package:course_correct/pages/add_course.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:course_correct/pages/profile_page.dart';
import 'package:course_correct/pages/test_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        '/profilepage': (context) => ProfilePage1(),
        '/testpage': (context) => TestPage(),
        '/addcourse': (context) => AddCoursePage(),
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
