import 'package:flutter/material.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contact Us',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'If you have any questions or need assistance, please contact us at:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Phone Numbers:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('+256 708 596 212'),
            Text('+256 770 763 793'),
            Text('+256 764 270 851'),
            Text('+256 752 849 865'),
            Text('+256 762 309 324'),
          ],
        ),
      ),
    );
  }
}
