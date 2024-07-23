import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class AppointmentsPage extends StatelessWidget {
  final List<Appointment> appointments = [
    Appointment(
      tutorName: 'Tutor 1',
      subject: 'Math',
      dateTime: DateTime(2024, 7, 10, 14, 30),
    ),
    Appointment(
      tutorName: 'Tutor 2',
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
      ),
      body: ListView.builder(
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final appointment = appointments[index];
          return Card(
            child: ListTile(
              title: Text('${appointment.tutorName} - ${appointment.subject}'),
              subtitle: Text(
                '${appointment.dateTime.day}/${appointment.dateTime.month}/${appointment.dateTime.year} '
                'at ${appointment.dateTime.hour}:${appointment.dateTime.minute}',
              ),
              trailing: const Icon(Icons.more_vert),
              onTap: () {
                // Handle appointment tile tap
              },
            ),
          );
        },
      ),
    );
  }
}

class Appointment {
  final String tutorName;
  final String subject;
  final DateTime dateTime;

  Appointment({
    required this.tutorName,
    required this.subject,
    required this.dateTime,
  });
}
