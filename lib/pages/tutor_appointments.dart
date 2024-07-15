import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class TutorAppointments extends StatelessWidget {
  final List<Appointment> appointments = [
    Appointment(
      studentName: 'Student 1',
      subject: 'Math',
      dateTime: DateTime(2024, 7, 10, 14, 30),
    ),
    Appointment(
      studentName: 'Student 2',
      subject: 'Science',
      dateTime: DateTime(2024, 7, 11, 16, 0),
    ),
    // Add more appointments as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigate to add appointment
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
                // Navigate to My Students
              },
            ),
            ListTile(
              title: const Text('Appointments'),
              onTap: () {
                // Navigate to appointments
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                // Log out
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final appointment = appointments[index];
          return Card(
            child: ListTile(
              title: Text('${appointment.studentName} - ${appointment.subject}'),
              subtitle: Text(
                '${'${appointment.dateTime.toLocal()}'.split(' ')[0]} at ${'${appointment.dateTime.toLocal()}'.split(' ')[1].substring(0, 5)}',
              ),
              trailing: const Icon(Icons.more_vert),
              onTap: () {
                // Handle appointment card tap
              },
            ),
          );
        },
      ),
    );
  }
}

class Appointment {
  final String studentName;
  final String subject;
  final DateTime dateTime;

  Appointment({
    required this.studentName,
    required this.subject,
    required this.dateTime,
  });
}
