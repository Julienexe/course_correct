import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_correct/appstate/app_state.dart';
import 'package:course_correct/pages/appointments_page.dart';
import 'package:course_correct/pages/landing_page.dart';
import 'package:course_correct/pages/student_booking_page.dart';
import 'package:course_correct/pages/student_homepage.dart';
import 'package:course_correct/pages/tutor_appointments.dart';
import 'package:course_correct/pages/tutor_selection_page.dart';
import 'package:course_correct/pages/tutor_students.dart';
import 'package:course_correct/pages/zoom_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:course_correct/pages/profile_page.dart';
import 'package:course_correct/pages/test_page.dart';
import 'package:provider/provider.dart';
import 'package:course_correct/services/notification_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

late AppState appState;

Future<void> requestNotificationPermission() async {
  final status = await Permission.notification.request();
  if (status.isGranted) {
    print('Notification permission granted.');
  } else {
    print('Notification permission denied.');
  }
}

void storeDeviceToken() async {
  String? token = await FirebaseMessaging.instance.getToken();
  if (token != null) {
    // Save this token to your Firestore 'users' collection
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'deviceToken': token,
      });
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseAuth.instance.setLanguageCode('en');
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await NotificationService().init();
  await requestNotificationPermission();

  appState = AppState();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => appState,
      child: MaterialApp(
        title: 'Course Correct',
        debugShowCheckedModeBanner: false,
        routes: {
          '/studentHomepage': (context) => StudentHomepage(),
          '/profilepage': (context) => const ProfilePage1(),
          '/landingpage': (context) => LandingPage(),
          '/appointments': (context) => TutorAppointments(),
          '/students': (context) => TutorStudents(),
          '/appointments': (context) => AppointmentsPage(),
          '/tutorAvailabilityPage': (context) => TutorAvailabilityPage(),
          '/tutorBookingPage': (context) => TutorBookingPage(),
        },
        theme: ThemeData(
          primaryColor: Colors.white,
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.cyan,
            backgroundColor: Colors.white
          ),
          textTheme: const TextTheme(
            headlineLarge:
                TextStyle(fontFamily: 'Schyler', fontWeight: FontWeight.bold),
          ),
        ),
        home: Builder(builder: (context) {
          return const TestPage();
        }),
      ),
    );
  }
}

//for laterrrrrrr!!!!
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zoom API Integration'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            ZoomService zoomService = ZoomService();
            await zoomService.createMeeting(
              topic: 'Test Meeting',
              startTime: '2024-07-23T10:00:00Z',
            );
          },
          child: const Text('Create Zoom Meeting'),
        ),
      ),
    );
  }
}

class StudentBookingPageArguments {
  final String tutorId;
  final DateTime selectedStartTime;
  final DateTime selectedEndTime;

  StudentBookingPageArguments({
    required this.tutorId,
    required this.selectedStartTime,
    required this.selectedEndTime,
  });
}
