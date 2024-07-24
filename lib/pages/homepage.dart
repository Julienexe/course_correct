import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool? _isEnrolled;
  String? _role;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _checkEnrollmentStatus();
  }

  Future<void> _checkEnrollmentStatus() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userId = user.uid;
      // Determine the user's role and collection name
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('students').doc(_userId).get();
      if (!userDoc.exists) {
        userDoc = await FirebaseFirestore.instance.collection('tutors').doc(_userId).get();
        _role = 'tutor';
      } else {
        _role = 'student';
      }

      setState(() {
        _isEnrolled = userDoc['isEnrolled'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isEnrolled == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!_isEnrolled!) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('You are not enrolled yet.'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigate to enrollment page or perform enrollment
                },
                child: Text('Get Enrolled'),
              ),
            ],
          ),
        ),
      );
    }

    // If enrolled, show the homepage content
    return Scaffold(
      body: Center(
        child: Text('Welcome to Course Correct!'),
      ),
    );
  }
}
