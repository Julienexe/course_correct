import 'package:course_correct/components/slider.dart';
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
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false, // This prevents going back to the previous screen
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> Carouselitems = [Container(
      height: 360,
      padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: TableCalendar(
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
              _focusedDay = focusedDay; // update `_focusedDay` here as well
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
      ),
      Container(
        
        height: 300,
        width: 400,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: const Center(child: Text('Appointments')),
      ),
      Container(
        
        height: 300,
        width: 400,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: const Center(child:Icon(Icons.message)),
      ),

      Container(
        //margin: const EdgeInsets.all(5.0),
        height: 250,
        width: 400,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: const Center(child: Text('Manage Availability')),
      ),
      
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 7, 129, 229),
        title: const Text('Home', style: TextStyle(color: Colors.white)),
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
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 7, 129, 229),
                  Color.fromARGB(255, 255, 255, 255),
                ]),
          ),
          child: SingleChildScrollView(
            child: Center(
              //padding: const EdgeInsets.all(0),
              child: Column(
                
                children: [
                  // Welcome Message
                  Text(
                    'Welcome, $_userName',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 20.0),
        
                  // Calendar
                  
                  CarouselWigdet(items: Carouselitems),
        
                  const SizedBox(height: 16.0),
        
                  // New Requests
                  
        
                  // Quick Links
                 
                ],
              ),
            ),
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
