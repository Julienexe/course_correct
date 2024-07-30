// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:course_correct/main.dart';
import 'package:course_correct/pages/initial_selection_page.dart';
import 'package:course_correct/pages/student_homepage.dart';
import 'package:course_correct/pages/tutors/fancy_questionnaire.dart';
import 'package:course_correct/pages/tutors_homepage.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return 
      appState.userProfile?.role == 'tutor' ? TutorHomepage(): appState.userProfile?.role == 'student' ? StudentHomepage() : RoleSelectionPage();
    
  }

 
}
