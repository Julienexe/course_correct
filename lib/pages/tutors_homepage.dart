import 'package:course_correct/main.dart';
import 'package:course_correct/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class TutorHomepage extends StatefulWidget {
  const TutorHomepage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TutorHomepageState createState() => _TutorHomepageState();
}

class _TutorHomepageState extends State<TutorHomepage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final String _userName = appState.userProfile?.name ?? 'Tutor';

  // Function to handle logout action
  void _handleLogout(BuildContext context) {
    // Clear any stored authentication tokens or session data
    // Example: AuthService.logout();

    // Navigate to the login screen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false, // This prevents going back to the previous screen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Tutor Homepage'),
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
            },
          ),
        ],
      ),
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
              title: const Text('My Students'),
              onTap: () {
                Navigator.pushNamed(context, '/students');
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
              // Welcome Message
              Text(
                'Welcome, $_userName',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),

              // Calendar
              const Text(
                'Calendar',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay =
                        focusedDay; // update `_focusedDay` here as well
                  });
                },
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
              ),
              const SizedBox(height: 16.0),

              // New Requests
              const Text(
                'New Requests',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: <Widget>[
                  RequestCard(
                      requestDetails: 'Math tutoring request from Student 1'),
                  RequestCard(
                      requestDetails:
                          'Science tutoring request from Student 2'),
                ],
              ),
              const SizedBox(height: 16.0),

              // Quick Links
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  QuickLinkButton(
                    text: 'Appointments',
                    icon: Icons.calendar_today,
                    onPressed: () {
                      Navigator.pushNamed(context, '/appointments');
                    },
                  ),
                  QuickLinkButton(
                    text: 'Manage Availability',
                    icon: Icons.schedule,
                    onPressed: () {
                      // Handle Manage Availability press
                    },
                  ),
                  QuickLinkButton(
                    text: 'Message Students',
                    icon: Icons.message,
                    onPressed: () {
                      // Handle Message Students press
                    },
                  )
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
                  // Navigate to Contact Support
                },
                child: const Text('Support'),
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
}

class RequestCard extends StatelessWidget {
  final String requestDetails;

  // ignore: prefer_const_constructors_in_immutables
  RequestCard({super.key, required this.requestDetails});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(requestDetails),
        trailing: const Icon(Icons.more_vert),
        onTap: () {
          // Handle request card tap
        },
      ),
    );
  }
}

class QuickLinkButton extends StatelessWidget {
  final String text;
  final IconData icon;

  // ignore: prefer_const_constructors_in_immutables
  QuickLinkButton(
      {super.key,
      required this.text,
      required this.icon,
      required Null Function() onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        IconButton(
          icon: Icon(icon),
          onPressed: () {
            // Handle quick link button press
          },
        ),
        Text(text),
      ],
    );
  }
}
