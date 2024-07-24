import 'package:course_correct/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  Future<void> updateUserRole(String role) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Fetch the current data
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        Map<String, dynamic> existingData = doc.data() as Map<String, dynamic>;

        // Prepare the new data to be merged
        Map<String, dynamic> newData = {
          'role': role,
          'isEnrolled': false, // Assuming initial enrollment status is false
        };

        // Merge existing data with new data
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          ...existingData,
          ...newData,
        }, SetOptions(merge: true));
      } catch (e) {
        print("Error updating user role: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 40),
              RoleSelectionButton(
                role: 'Student',
                onTap: () async {
                  await updateUserRole('student');
                  Navigator.pushNamed(context, '/tutorBookingPage',);
                },
              ),
              const SizedBox(height: 50),
              RoleSelectionButton(
                role: 'Tutor',
                onTap: () async {
                  await updateUserRole('tutor');
                  Navigator.pushNamed(context, '/tutorAvailabilityPage');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RoleSelectionButton extends StatelessWidget {
  final String role;
  final VoidCallback onTap;

  const RoleSelectionButton({
    super.key,
    required this.role,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
        child: SizedBox(
          width: 250, // Set the width of the button
          height: 100, // Set the height of the button
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  role == 'Student' ? Icons.school : Icons.person,
                  size: 50,
                  color: Colors.blue,
                ),
                const SizedBox(width: 20),
                Text(
                  role,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
