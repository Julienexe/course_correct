import 'package:cloud_firestore/cloud_firestore.dart';
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
            title: const Text('Your Scores'),
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
                  'The next step is to find a tutor who can help you improve your scores.',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    //write tutor name to database
                    List<Map> tutorList = tutorMatcher.matchTutors(scoresByTopic);
                    Map topTutor = tutorList[0];
                    appState.setTutor(topTutor['email']);
                    final db = FirebaseFirestore.instance;
                    db.collection('students').doc(studentId).update({
                      'tutor': topTutor['Tutor']

                    });
                    
                    showDialog(
                      context: context, 
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Recommendations'),
                          content: SizedBox(
                            height: 200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:[
                                const Text('You have been matched with the following tutor:',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold
                                ),),
                                Text('${topTutor['Tutor']}',
                                style: const TextStyle(
                                  fontSize: 16
                                ),),
                              ] 
                            
                            ),
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {

                                Navigator.of(context).pushReplacementNamed(
                                  "/studentHomepage"
                                );
                              },
                              child: const Text('Next'),
                            ),
                          ],
                        );
                      }
                      );
                    // Add functionality for exporting the results
                  },
                  child: const Text('Find me a tutor'),
                ),
                
              ],
            ),
          ),
        );
      }
    );
  }
}
