import 'package:course_correct/main.dart';
import 'package:course_correct/models/user_model.dart';
import 'package:course_correct/pages/student_homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  Future<void> updateUserRole(String role, BuildContext context) async {
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
          'role': role, // Assuming initial enrollment status is false
        };

        // Merge existing data with new data
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          ...existingData,
          ...newData,
        }, SetOptions(merge: true));

        // Update the user profile in the app state
        appState.setUserProfile(UserModel(
          name: existingData['name'],
          role: role,
        ));
      } catch (e) {
        appState.snackBarMessage(e.toString(), context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                  await updateUserRole('student', context);
                  Navigator.of(_scaffoldKey.currentContext!).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const StudentHomepage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 50),
              RoleSelectionButton(
                role: 'Tutor',
                onTap: () async {
                  await updateUserRole('tutor', context);
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
