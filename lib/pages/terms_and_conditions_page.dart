import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms and Conditions'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Course Correct - Terms and Conditions',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'Welcome to Course Correct, a peer-to-peer tutorial app designed to connect students with tutors for personalized learning experiences. Our app is free to use, and students do not have to pay tutors for their services.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                '1. Acceptance of Terms',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'By using Course Correct, you agree to be bound by these terms and conditions. If you do not agree with any part of these terms, you must not use the app.',
              ),
              SizedBox(height: 16),
              Text(
                '2. User Accounts',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'To use the app, you must create an account. You are responsible for maintaining the confidentiality of your account information and for all activities that occur under your account.',
              ),
              SizedBox(height: 16),
              Text(
                '3. User Conduct',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'You agree to use the app only for lawful purposes. You must not use the app in any way that could damage, disable, overburden, or impair the app, or interfere with any other party\'s use and enjoyment of the app.',
              ),
              SizedBox(height: 16),
              Text(
                '4. Limitation of Liability',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Course Correct is provided on an "as is" and "as available" basis. We do not warrant that the app will be uninterrupted or error-free. In no event shall we be liable for any damages arising out of or in connection with the use of the app.',
              ),
              SizedBox(height: 16),
              Text(
                '5. Changes to Terms',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'We reserve the right to modify these terms at any time. Your continued use of the app after any such changes constitutes your acceptance of the new terms.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
