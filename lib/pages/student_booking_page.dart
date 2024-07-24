import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TutorBookingPage extends StatefulWidget {
  @override
  _TutorBookingPageState createState() => _TutorBookingPageState();
}

class _TutorBookingPageState extends State<TutorBookingPage> {
  List<Map<String, dynamic>> tutors = [];

  @override
  void initState() {
    super.initState();
    fetchTutors();
  }

  Future<void> fetchTutors() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'tutor')
        .get();
    List<Map<String, dynamic>> fetchedTutors = [];
    for (var doc in querySnapshot.docs) {
      fetchedTutors.add({
        'id': doc.id,
        'data': doc.data(),
      });
    }
    setState(() {
      tutors = fetchedTutors;
    });
  }

  Future<bool> canBookSessionThisMonth(String studentId, String tutorId) async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0); // Last day of the month

    final bookings = await FirebaseFirestore.instance
        .collection('bookings')
        .where('studentId', isEqualTo: studentId)
        .where('tutorId', isEqualTo: tutorId)
        .where('startTime', isGreaterThanOrEqualTo: startOfMonth)
        .where('startTime', isLessThanOrEqualTo: endOfMonth)
        .get();

    return bookings.docs.length < 3; // Allow up to 3 bookings per month
  }

  Future<void> bookSession(String studentId, String tutorId, DateTime startTime, DateTime endTime) async {
    if (await canBookSessionThisMonth(studentId, tutorId)) {
      await FirebaseFirestore.instance.collection('bookings').add({
        'studentId': studentId,
        'tutorId': tutorId,
        'startTime': startTime,
        'endTime': endTime,
      });
    } else {
      throw Exception('Booking limit reached for this month');
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String studentId = user?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Select and Book a Tutor'),
      ),
      body: ListView.builder(
        itemCount: tutors.length,
        itemBuilder: (context, index) {
          final tutor = tutors[index];
          final tutorData = tutor['data'] as Map<String, dynamic>?;

          if (tutorData == null) {
            return ListTile(
              title: Text('No data available'),
            );
          }

          // Ensure the required fields are not null
          final tutorName = tutorData['name'] ?? 'Unknown';
          final startTime = tutorData['startTime'] ?? 'N/A';
          final endTime = tutorData['endTime'] ?? 'N/A';

          // Add padding before the first item
          Widget tile = Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Vertical padding for spacing between tiles
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey[300]!, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              title: Text(
                tutorName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Available from $startTime to $endTime', style: TextStyle(fontSize: 15),),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                ),
                onPressed: () async {
                  try {
                    DateTime now = DateTime.now();
                    DateTime startTime = DateTime(
                      now.year, now.month, now.day,
                      int.parse(tutorData['startTime'].split(':')[0]),
                      int.parse(tutorData['startTime'].split(':')[1].split(' ')[0]),
                    );
                    DateTime endTime = DateTime(
                      now.year, now.month, now.day,
                      int.parse(tutorData['endTime'].split(':')[0]),
                      int.parse(tutorData['endTime'].split(':')[1].split(' ')[0]),
                    );

                    await bookSession(studentId, tutor['id'], startTime, endTime);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Session booked successfully!')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error booking session: $e')),
                    );
                  }
                },
                child: Text('Book'),
              ),
            ),
          );

          // Add extra top padding for the first item
          if (index == 0) {
            tile = Padding(
              padding: EdgeInsets.only(top: 16), // Additional top padding for the first item
              child: tile,
            );
          }

          return tile;
        },
      ),
    );
  }
}
