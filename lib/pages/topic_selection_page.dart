import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
        title: const Text('Select Practice Topic'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                setTopicOnDatabase(studentId, 'Algorithms');

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AlgorithmPracticePage(studentId: studentId),
                  ),
                );
              },
              child: const Text('Algorithm Practice'),
            ),
            ElevatedButton(
              onPressed: () {
                setTopicOnDatabase(studentId, 'Web Development');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        WebDevPracticePage(studentId: studentId),
                  ),
                );
              },
              child: const Text('Web Development Practice'),
            ),
            ElevatedButton(
              onPressed: () {
                setTopicOnDatabase(studentId, 'Programming Basics');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProgrammingBasicsPracticePage(studentId: studentId),
                  ),
                );
              },
              child: const Text('Programming Basics Practice'),
            ),
          ],
        ),
      ),
    );
  }
}

void setTopicOnDatabase(String studentId, String topic) {
  // Set the topic on the database
final db = FirebaseFirestore.instance;
                    db.collection('students').doc(studentId).set({
                      'email': FirebaseAuth.instance.currentUser!.email,
                      'topic': topic
                    });
}

