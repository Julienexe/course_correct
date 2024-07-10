import 'package:course_correct/pages/tutors_homepage.dart';
import 'package:flutter/material.dart';

class TutorAvailabilityPage extends StatefulWidget {
  @override
  _TutorAvailabilityPageState createState() => _TutorAvailabilityPageState();
}

class _TutorAvailabilityPageState extends State<TutorAvailabilityPage> {
  final List<String> subjects = [
    'Python',
    'C',
    'C++',
    'Web Development',
    'Embedded Systems',
  ];

  final Map<String, bool> selectedSubjects = {
    'Python': false,
    'C': false,
    'C++': false,
    'Web Development': false,
    'Embedded Systems': false,
  };

  final Map<String, bool> selectedDays = {
    'Monday': false,
    'Tuesday': false,
    'Wednesday': false,
    'Thursday': false,
    'Friday': false,
    'Saturday': false,
    'Sunday': false,
  };

  TimeOfDay? startTime;
  TimeOfDay? endTime;

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          startTime = picked;
        } else {
          endTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Tutor Availability'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Select Subjects You Want to Teach',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView(
                children: subjects.map((subject) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: CheckboxListTile(
                      title: Text(subject),
                      value: selectedSubjects[subject],
                      onChanged: (bool? value) {
                        setState(() {
                          selectedSubjects[subject] = value ?? false;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Select Your Available Days',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView(
                children: selectedDays.keys.map((day) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: CheckboxListTile(
                      title: Text(day),
                      value: selectedDays[day],
                      onChanged: (bool? value) {
                        setState(() {
                          selectedDays[day] = value ?? false;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Select Your Available Hours',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: <Widget>[
                    TextButton(
                      onPressed: () => _selectTime(context, true),
                      child: Text(startTime == null
                          ? 'Start Time'
                          : startTime!.format(context)),
                    ),
                    const Text(' to '),
                    TextButton(
                      onPressed: () => _selectTime(context, false),
                      child: Text(endTime == null
                          ? 'End Time'
                          : endTime!.format(context)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle form submission
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const TutorHomepage()));
                },
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
