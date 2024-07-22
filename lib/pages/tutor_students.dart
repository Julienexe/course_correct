import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class TutorStudents extends StatelessWidget {
  final List<Student> students = [
    Student(name: 'Student 1', subject: 'Math'),
    Student(name: 'Student 2', subject: 'Science'),
    // Add more students as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Students'),
      ),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          final student = students[index];
          return ListTile(
            title: Text(student.name),
            subtitle: Text(student.subject),
            trailing: const Icon(Icons.more_vert),
            onTap: () {
              // Handle student tile tap
            },
          );
        },
      ),
    );
  }
}

class Student {
  final String name;
  final String subject;

  Student({
    required this.name,
    required this.subject,
  });
}
