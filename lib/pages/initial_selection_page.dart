import 'package:course_correct/pages/student_homepage.dart';
import 'package:course_correct/pages/tutor_selection_page.dart';
import 'package:flutter/material.dart';

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Are you a Student or a Tutor?',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              RoleSelectionButton(
                role: 'Student',
                onTap: () {
                  // Navigate to student page
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const StudentHomepage()));
                },
              ),
              const SizedBox(height: 20),
              RoleSelectionButton(
                role: 'Tutor',
                onTap: () {
                  // Navigate to tutor page
                   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>TutorAvailabilityPage()));
                },
              ),
            ],
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
      onTap: (){
       onTap();
      },
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

class SettingsPage extends StatelessWidget {
const SettingsPage({ super.key });

  @override
  Widget build(BuildContext context){
    return const Center(
      child: Text('Coming Soon!',style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),),
    );
  }
}