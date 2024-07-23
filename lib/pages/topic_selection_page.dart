import 'package:flutter/material.dart';
import 'package:course_correct/pages/algorithm_practice_page.dart';
import 'package:course_correct/pages/web_development_practice.dart';
import 'package:course_correct/pages/programming_basics_practice.dart';

class TopicSelectionPage extends StatelessWidget {
  final String studentId;

  TopicSelectionPage({required this.studentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Practice Topic'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AlgorithmPracticePage(studentId: studentId),
                  ),
                );
              },
              child: Text('Algorithm Practice'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        WebDevPracticePage(studentId: studentId),
                  ),
                );
              },
              child: Text('Web Development Practice'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProgrammingBasicsPracticePage(studentId: studentId),
                  ),
                );
              },
              child: Text('Programming Basics Practice'),
            ),
          ],
        ),
      ),
    );
  }
}
