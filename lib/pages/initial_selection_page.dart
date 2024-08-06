import 'package:course_correct/main.dart';
import 'package:course_correct/models/user_model.dart';
import 'package:course_correct/pages/student_homepage.dart';
import 'package:course_correct/pages/tutors/fancy_questionnaire.dart';
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
      appBar: firstAppbar(),
      drawer: firstDrawer(context),
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
                 // Navigator.pushNamed(context, '/tutorAvailabilityPage');
                 Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>ConcentricAnimationOnboarding()
                    ),
                  );
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

 Drawer firstDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.grey[100],
        child: Column(
          children: [
            DrawerHeader(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  iconColor: Colors.blueAccent, // background color
                  backgroundColor: Colors.white, // foreground color
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/profilepage');
                },
                child: const Icon(
                  Icons.person,
                  size: 45,
                ),
              ),
            ),
            // Categories with Dropdown
            
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () {
                Navigator.pop(context);
                // go to settings page
                Navigator.pushNamed(context, '/settingspage');
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () {
                //log user out
               appState.logoutUser(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  AppBar firstAppbar() {
    return AppBar(
      title: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Course ",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          Text(
            "Correct ",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black87,
      elevation: 50,
      iconTheme: const IconThemeData(color: Colors.lightBlueAccent),
    );
  }

