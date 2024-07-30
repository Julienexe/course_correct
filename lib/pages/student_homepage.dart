import 'package:course_correct/main.dart';
import 'package:course_correct/pages/login_page.dart';
import 'package:course_correct/pages/topic_selection_page.dart';
import 'package:course_correct/pages/tutors/tutor_sorting.dart';
import 'package:flutter/material.dart';

class StudentHomepage extends StatelessWidget {
  const StudentHomepage({super.key});

  // Function to handle logout action
  void _handleLogout(BuildContext context) {
    // Clear any stored authentication tokens or session data
    // Example: AuthService.logout();

    // Navigate to the login screen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false, // This prevents going back to the previous screen
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: studentAppBar(context),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Menu'),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                // Navigate to home
              },
            ),
            ListTile(
              title: const Text('Find a Tutor'),
              onTap: () {
                // Navigate to find a tutor
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>const TutorSorting(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Appointments'),
              onTap: () {
                Navigator.pushNamed(context, '/appointments');
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                _handleLogout(context);
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              const TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Search for tutors',
                  suffixIcon: Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 16.0),

              // Featured Tutors
              const Text(
                'Featured Tutors',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              SizedBox(
                height: 150,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    FeaturedTutorCard(tutorName: 'Tutor 1'),
                    FeaturedTutorCard(tutorName: 'Tutor 2'),
                    FeaturedTutorCard(tutorName: 'Tutor 3'),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),

              // Upcoming Appointments
              const Text(
                'Upcoming Appointments',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: <Widget>[
                  AppointmentCard(appointmentDetails: 'Math with Tutor 1 at 3 PM'),
                  AppointmentCard(appointmentDetails: 'Science with Tutor 2 at 5 PM'),
                ],
              ),
              const SizedBox(height: 16.0),

              // Quick Links
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  QuickLinkButton(text: 'Find a Tutor', icon: Icons.search,page: TopicSelectionPage(studentId: appState.user!.uid),),
                  QuickLinkButton(text: 'My Appointments', icon: Icons.calendar_today),
                  QuickLinkButton(text: 'Messages', icon: Icons.message),
                ],
              ),
            ],
          ),
        ),
      ),
      // Footer
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  // Navigate to Contact Us
                },
                child: const Text('Contact Us'),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to Terms & Conditions
                },
                child: const Text('Terms & Conditions'),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to Social Media
                },
                child: const Text('Follow Us'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar studentAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Student Homepage'),
      actions: [
        IconButton(
          icon: const Icon(Icons.message),
          onPressed: () {
            // Navigate to messages
          },
        ),
        IconButton(
          icon: const Icon(Icons.person),
          onPressed: () {
            // Navigate to profile
            Navigator.pop(context);
            Navigator.pushNamed(context, '/profilepage');
          },
        ),
      ],
    );
  }
}

class FeaturedTutorCard extends StatelessWidget {
  final String tutorName;

  // ignore: prefer_const_constructors_in_immutables
  FeaturedTutorCard({super.key, required this.tutorName});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        width: 120,
        child: Center(
          child: Text(tutorName),
        ),
      ),
    );
  }
}

class AppointmentCard extends StatelessWidget {
  final String appointmentDetails;

  // ignore: prefer_const_constructors_in_immutables
  AppointmentCard({super.key, required this.appointmentDetails});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(appointmentDetails),
        trailing: const Icon(Icons.more_vert),
        onTap: () {
          // Handle appointment card tap
        },
      ),
    );
  }
}

class QuickLinkButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Widget? page;

  // ignore: prefer_const_constructors_in_immutables
  QuickLinkButton({super.key, required this.text, required this.icon, this.page});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        IconButton(
          icon: Icon(icon),
          onPressed: () {
            // Handle quick link button press
             if (page != null) {
               Navigator.push(context, MaterialPageRoute(
              builder: 
              (context) => page as Widget,
              ),
              );
             }

              },
        ),
        Text(text),
      ],
    );
  }
}
