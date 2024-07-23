import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_correct/models/courses_models.dart';
import 'package:course_correct/pages/tutors_homepage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TutorAvailabilityPage(),
    );
  }
}

// class CoursesModel {
//   String name;

//   CoursesModel({
//     required this.name,
//   });

//   factory CoursesModel.fromFirestore(DocumentSnapshot doc) {
//     Map data = doc.data() as Map<String, dynamic>;
//     return CoursesModel(
//       name: data['name'],
//     );
//   }

//   static List<CoursesModel> listFromFirestore(QuerySnapshot snapshot) {
//     return snapshot.docs.map((doc) {
//       return CoursesModel.fromFirestore(doc);
//     }).toList();
//   }
// }

class TutorAvailabilityPage extends StatefulWidget {
  @override
  _TutorAvailabilityPageState createState() => _TutorAvailabilityPageState();
}

class _TutorAvailabilityPageState extends State<TutorAvailabilityPage> {
  final Map<String, bool> selectedSubjects = {};
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

  Future<List<CoursesModel>> fetchCourses() async {
  try {
    var snap = await FirebaseFirestore.instance.collection("Courses ").get();
    return CoursesModel.listFromFirestore(snap);
  } catch (e) {
    print("Error fetching courses: $e");
    return [];
  }
}

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

Future<void> submitTutorInfo() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    try {
      // Fetch the current data
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      Map<String, dynamic> existingData = doc.data() as Map<String, dynamic>;

      // Prepare the new data to be merged
      Map<String, dynamic> newData = {
        'role': 'tutor',
        'subjects': selectedSubjects.keys.where((key) => selectedSubjects[key] == true).toList(),
        'days': selectedDays.keys.where((key) => selectedDays[key] == true).toList(),
        'startTime': startTime != null ? startTime!.format(context) : '',
        'endTime': endTime != null ? endTime!.format(context) : '',
      };

      // Merge existing data with new data
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        ...existingData,
        ...newData,
      }, SetOptions(merge: true));

    } catch (e) {
      print("Error updating tutor info: $e");
    }
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
              child: FutureBuilder<List<CoursesModel>>(
                future: fetchCourses(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (snapshot.hasData) {
                    final courses = snapshot.data!;
                    return ListView(
                      children: courses.map((course) {
                        return CheckboxListTile(
                          title: Text(course.name),
                          value: selectedSubjects[course.name] ?? false,
                          onChanged: (bool? value) {
                            setState(() {
                              selectedSubjects[course.name] = value ?? false;
                            });
                          },
                        );
                      }).toList(),
                    );
                  } else {
                    return const Center(
                      child: Text('No subjects available'),
                    );
                  }
                },
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
                onPressed: () async {
                  await submitTutorInfo();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TutorHomepage(),
                    ),
                  );
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

