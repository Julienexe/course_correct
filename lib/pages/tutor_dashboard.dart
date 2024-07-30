import 'package:course_correct/main.dart';
import 'package:course_correct/pages/tutor_matching_algorithm.dart';
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
    return FutureBuilder(
      future: appState.fetchTutors(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        //print(snapshot.data);
        TutorModelMatcher tutorMatcher = TutorModelMatcher(tutors: 
          snapshot.data!
          );
        return Scaffold(
          appBar: AppBar(
            title: const Text('Tutor Dashboard'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Student ID: $studentId',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'Overall Score: $score/${questionsPerTopic.values.reduce((a, b) => a + b)}',
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Scores by Topic:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ...scoresByTopic.entries.map((entry) {
                  return Text(
                    '${entry.key}: ${entry.value}/${questionsPerTopic[entry.key]}',
                    style: const TextStyle(fontSize: 18),
                  );
                }).toList(),
                const SizedBox(height: 20),
                const Text(
                  'Additional Features',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    List<Map> tutorList = tutorMatcher.matchTutors(scoresByTopic);
                    Map topTutor = tutorList[0];
                    showDialog(
                      context: context, 
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Recommendations'),
                          content: Column(
                            children:[
                              const Text('You have been matched with the following tutor:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                              ),),
                              Text('Name: ${topTutor['Tutor']}',
                              style: const TextStyle(
                                fontSize: 16
                              ),),
                            ] 

                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Close'),
                            ),
                          ],
                        );
                      }
                      );
                    // Add functionality for exporting the results
                  },
                  child: const Text('Find me a tutor'),
                ),
                ElevatedButton(
                  onPressed: () {
                    
                    // Add functionality for emailing the results
                  },
                  child: const Text('Email Results'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Add functionality for showing detailed analysis
                  },
                  child: const Text('Show Detailed Analysis'),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
