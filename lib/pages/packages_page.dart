import 'package:flutter/material.dart';

class TutoringOptionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const Spacer(flex: 2), // Add more spacing at the top
              const Text(
                'Choose Tutoring Option',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(
                  flex: 1), // Adjust the spacing between the text and the cards
              TutoringOptionCard(
                icon: Icons.computer,
                title: 'Online Tutoring',
                description: 'Get tutoring online via video calls and chat.',
                onTap: () {
                  // Navigate to online tutoring page
                },
              ),
              const SizedBox(height: 20),
              TutoringOptionCard(
                icon: Icons.location_on,
                title: 'Physical Tutoring',
                description: 'Meet tutors in person for one-on-one sessions.',
                onTap: () {
                  // Navigate to physical tutoring page
                },
              ),
              const Spacer(flex: 2), // Add more spacing at the bottom
            ],
          ),
        ),
      ),
    );
  }
}

class TutoringOptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const TutoringOptionCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: <Widget>[
              Icon(icon, size: 50, color: Colors.blue),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      description,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
