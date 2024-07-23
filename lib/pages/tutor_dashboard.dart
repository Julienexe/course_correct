import 'package:flutter/material.dart';

class TutorDashboard extends StatelessWidget {
  final String studentId;
  final int score;
  final Map<String, int> scoresByTopic;
  final Map<String, int> questionsPerTopic;

  TutorDashboard({
    required this.studentId,
    required this.score,
    required this.scoresByTopic,
    required this.questionsPerTopic,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tutor Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Student ID: $studentId',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Overall Score: $score/${questionsPerTopic.values.reduce((a, b) => a + b)}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              'Scores by Topic:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ...scoresByTopic.entries.map((entry) {
              return Text(
                '${entry.key}: ${entry.value}/${questionsPerTopic[entry.key]}',
                style: TextStyle(fontSize: 18),
              );
            }).toList(),
            SizedBox(height: 20),
            Text(
              'Additional Features',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Add functionality for exporting the results
              },
              child: Text('Export Results'),
            ),
            ElevatedButton(
              onPressed: () {
                // Add functionality for emailing the results
              },
              child: Text('Email Results'),
            ),
            ElevatedButton(
              onPressed: () {
                // Add functionality for showing detailed analysis
              },
              child: Text('Show Detailed Analysis'),
            ),
          ],
        ),
      ),
    );
  }
}
