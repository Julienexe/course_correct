import 'package:flutter/material.dart';
import 'topic_selection_page.dart';
import 'zoom_service.dart';
import 'textbelt_service.dart';

class RoleSelectionPage extends StatelessWidget {
  final ZoomService _zoomService = ZoomService();
  final TextbeltService _textbeltService = TextbeltService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Your Role'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RoleSelectionButton(
                role: 'Student',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TopicSelectionPage(
                        studentId: '',
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              RoleSelectionButton(
                role: 'Tutor',
                onTap: () async {
                  await _zoomService.createMeeting(
                    topic: 'Tutor Meeting',
                    startTime: DateTime.now().toUtc().toIso8601String(),
                  );

                  await _textbeltService.sendSms(
                    '+1234567890', // Replace with the actual phone number
                    'Welcome to Course Correct!',
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Tutor role selected and SMS sent.')),
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
    Key? key,
    required this.role,
    required this.onTap,
  }) : super(key: key);

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
          width: 250,
          height: 100,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                role,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
