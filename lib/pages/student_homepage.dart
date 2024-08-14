import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_correct/main.dart';
import 'package:course_correct/pages/appointments_page.dart';
import 'package:course_correct/pages/chat_screen.dart';
import 'package:course_correct/pages/login_page.dart';
import 'package:course_correct/pages/student_booking_page.dart';
import 'package:course_correct/pages/topic_selection_page.dart';
import 'package:course_correct/pages/tutors/tutor_sorting.dart';
import 'package:course_correct/pages/terms_and_conditions_page.dart';
import 'package:course_correct/pages/contact_us_page.dart';
import 'package:course_correct/pages/follow_us_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final String chatRoomId = appState.user!.email!;
String formatTimestamp(Timestamp timestamp) {
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
  return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
}

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
                Navigator.pop(context);
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
        child: FutureBuilder(
            future: gather(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 100,
                      ), 
                      CircularProgressIndicator(),
                    ],
                  ),
                );
              }
              
                final Booking = snapshot.data?[0]?? {};
                final studentData = snapshot.data?[1]?? {};
                
              
              return studentData.isNotEmpty
                  ? Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color.fromARGB(255, 7, 129, 229),
                              Color.fromARGB(255, 255, 255, 255),
                            ]),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              const Text(
                                'Welcome back',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              StudentAppointment(studentData: studentData, booking: Booking,),
                              Card(
                                elevation: 2,
                                child: Container(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      const Text(
                                        'Quick Links',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      const SizedBox(height: 16.0),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          QuickLinkButton(
                                            text: 'Appointments',
                                            icon: Icons.calendar_today,
                                            page: AppointmentsPage(),
                                          ),
                                          QuickLinkButton(
                                            text: 'Contact Us',
                                            icon: Icons.message,
                                            page: ContactUsPage(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 200,
                          ),
                          Card(
                            elevation: 2,
                            child: Container(
                              margin: const EdgeInsets.all(16.0),
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  const Text('Looks like you do not have a tutor yet'),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => TopicSelectionPage(studentId: appState.user!.uid,),
                                        ),
                                      );
                                    },
                                    child: const Text('Find a Tutor'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
            }),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ContactUsPage(),
                    ),
                  );
                },
                child: const Text('Contact Us'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TermsAndConditionsPage(),
                    ),
                  );
                },
                child: const Text('Terms & Conditions'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FollowUsPage(),
                    ),
                  );
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
      backgroundColor: const Color.fromARGB(255, 7, 129, 229),
      title: const Text(' Home', style: TextStyle(color: Colors.white)),
      actions: [
        IconButton(
          icon: const Icon(Icons.message, color: Colors.white),
          onPressed: () {
           Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        chatroomId: chatRoomId,
                      ),
                    ));
          },
        ),
        // IconButton(
        //   icon: const Icon(Icons.person, color: Colors.white),
        //   onPressed: () {
        //     // Navigate to profile
        //     Navigator.pop(context);
        //     Navigator.pushNamed(context, '/profilepage');
        //   },
        // ),
      ],
    );
  }
}

class StudentAppointment extends StatelessWidget {
  const StudentAppointment({
    super.key,
    required this.studentData, this.booking,
  });

  final Map studentData;
  final Map? booking;

  @override
  Widget build(BuildContext context) {
    return booking!.isEmpty ? Card(
      elevation: 2,
      child: Container(
        width: 617,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Your tutor is ${studentData['tutor']}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'No appointment set yet',
              style: TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => TutorBookingPage(),
                    ));
              },
              child: const Text('View Appointments'),
            ),
          ],
        ),
      ),
    ) : Card(
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Your tutoring session with ${studentData['tutor']} is scheduled for ${formatTimestamp(booking!['startTime'])} ',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                //create chatroom for student and tutor
                
                appState.createChatRoom(chatRoomId, [appState.user!.uid, studentData['tutorID']]);
                Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        chatroomId: chatRoomId,
                      ),
                    ));
              },
              child: const Text('Message Tutor'),
            ),
          ],
        ),
      ),
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
  QuickLinkButton({
    super.key, required this.text, required this.icon, this.page});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        IconButton(
          icon: Icon(icon),
          onPressed: () {
            // Handle quick link button press
            if (page != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => page as Widget,
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

Future<List> gather()async{
  Map? booking = {};
  try {
    booking = (await getStudentBooking()) ?? {};
  } on Exception {
    booking = {};
  }
  return[booking, await getStudentData()];
}

Future<List> gatherData() async {
  final bookings = await getStudentBooking();
  final studentData = await getStudentData();
  print(bookings);
  print(studentData);
  return [bookings, studentData];
}

Future<Map<String, dynamic>?> getStudentBooking() async {
  
    final db = FirebaseFirestore.instance;
    var data = await db.collection('bookings').where('studentId', isEqualTo: appState.user!.uid).get();
    if (data.docs.isEmpty) {
      return {};
      
    } 
    return data.docs.first.data();
  
}

Future<Map<String, dynamic>?> getStudentData() async {
  try {
    final db = FirebaseFirestore.instance;
    //print("progress");
    final data = await db.collection('students').doc(FirebaseAuth.instance.currentUser!.uid).get();
    appState.setTutor( data.data()!['tutorID']);


    return data.data() ?? {};
  } on Exception {
    //print("failed");
    return {};
  }
}
