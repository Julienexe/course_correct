import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_correct/pages/tutors_homepage.dart';
import 'package:flutter/material.dart';
import 'package:course_correct/models/courses_models.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

final List<String> subjects = [];
Future<List<CoursesModel>> getCourses() async {
  var snap = await FirebaseFirestore.instance.collection("Courses ").get();
  return CoursesModel.listFromFirestore(snap);
}

class TutorAvailabilityPage extends StatefulWidget {
  @override
  _TutorAvailabilityPageState createState() => _TutorAvailabilityPageState();
}

Future<void> populateSubjects() async {
    List<CoursesModel> courses = await getCourses();
    while (subjects.isEmpty) {
  for (var course in courses) {
    subjects.add(course.name);
  }
  //update selected subjects map
  for (var subject in subjects) {
    selectedSubjects[subject] = false;
  }
}
  }

final Map<String, bool> selectedSubjects = {};

class _TutorAvailabilityPageState extends State<TutorAvailabilityPage> {
  //list of courses


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
            const Expanded(
              
              child: Subjects(),
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
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TutorHomepage()));
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

class Subjects extends StatefulWidget {
  const Subjects({
    super.key,
  });

  @override
  State<Subjects> createState() => _SubjectsState();
}

class _SubjectsState extends State<Subjects> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: populateSubjects(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
         return SubjectSelection(
            selectedSubjects: selectedSubjects,
            subjects: subjects,
         );
        }
      },
    );
  }
}

class SubjectSelection extends StatefulWidget {
  final selectedSubjects;
  final subjects;
  const SubjectSelection({super.key, this.selectedSubjects, this.subjects});

  @override
  _SubjectSelectionState createState() => _SubjectSelectionState();
}

class _SubjectSelectionState extends State<SubjectSelection> {
  @override
  Widget build(BuildContext context) {
    List<String> subjects = widget.subjects;
    Map<String, bool> selectedSubjects = widget.selectedSubjects;
    return ListView(
      children: [
        Container(
          height: 200, // fixed height
          child: MultiSelectDialogField(
            title: const Text('Subjects'),
            backgroundColor: Colors.white,
            buttonText: const Text('Subjects'),
            dialogHeight: 200,
            items: subjects
               .map((subject) => MultiSelectItem<String>(subject, subject))
               .toList(),
            onConfirm: (value) {
              setState(() {
                //remove the item from the selected list if it is already selected
                selectedSubjects.remove(value);
              });
            },
          ),
        ),
        // Display selected subjects in a scrollable list
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: selectedSubjects.length,
          itemBuilder: (context, index) {
            String subject = selectedSubjects.keys.elementAt(index);
            return ListTile(
              title: Text(subject),
            );
          },
        ),
      ],
    );
  }
}