import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_correct/main.dart';
import 'package:course_correct/models/courses_models.dart';
import 'package:course_correct/models/user_model.dart';
import 'package:course_correct/pages/tutors_homepage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

// int current_page = 0;

//   List<Widget> pages = [
//       Topics(),
//       SubTopics(name: name),
//       DaysOfTheWeek(),
//       TimeSelection()
//     ];

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
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        Map<String, dynamic> existingData = doc.data() as Map<String, dynamic>;

        // Prepare the new data to be merged
        Map<String, dynamic> newData = {
          'role': 'tutor',
          'subjects': selectedSubjects.keys
              .where((key) => selectedSubjects[key] == true)
              .toList(),
          'days': selectedDays.keys
              .where((key) => selectedDays[key] == true)
              .toList(),
          'startTime': startTime != null ? startTime!.format(context) : '',
          'endTime': endTime != null ? endTime!.format(context) : '',
        };

        // Merge existing data with new data
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          ...existingData,
          ...newData,
        }, SetOptions(merge: true));
        appState.setUserProfile(UserModel(
          name: existingData['name'],
          role: 'tutor',
        ));
      } catch (e) {
        appState.snackBarMessage(e.toString(), context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Questions();
  }
}

class Questions extends StatefulWidget {
  const Questions({
    super.key,
  });

  @override
  State<Questions> createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> {
  int current_page = 0;

  void _nextPage() {
    setState(() {
      current_page++;
    });
  }
  @override
  Widget build(BuildContext context) {
    final courseName = appState.courseName;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Tutor Availability'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.only(
            left: 10,
            right: 10,
          ),
          child: IndexedStack(
            index: current_page,
            children: [
              //courses
              CoursesBuilder(
                future: getCourses(),
                next:_nextPage,
              ),
              //subtopics
              CoursesBuilder(
                future: fetchSubs(courseName),
                next: _nextPage,
              ),
              DaysOfTheWeek(next: _nextPage),
              const TimeSelection(),
            ],
          ),
        ),
      ),
    );
  }
}

//Functions to fetch topics and subtopics


Future<List<CoursesModel>> fetchCourses(dbRef) async {
  try {
    var snap = await dbRef.get();
    return CoursesModel.listFromFirestore(snap);
  } catch (e) {
    //print("Error fetching courses: $e");
    return [];
  }
}

Future<List<CoursesModel>> getCourses() async {
  return await fetchCourses(FirebaseFirestore.instance.collection("Courses "));
}

Future<List<CoursesModel>> fetchSubs(String? name) {
  return fetchCourses(FirebaseFirestore.instance
      .collection("Courses ")
      .doc(name)
      .collection("subs"));
}

class CoursesBuilder extends StatelessWidget {
  final Future<Object?>? future;
  final Function next;
  
  CoursesBuilder(
      {super.key,
      this.future,
      required this.next,
      
      });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final data = snapshot.data as List<CoursesModel>;
          //change data to checklist items
          final listItems = data
              .map((e) => CheckListCard(title: Text(e.name), value: e.name))
              .toList();
          return SelectCard(listItems, context, next);
        });
  }

  Center SelectCard(
      List<CheckListCard<String>> listItems, BuildContext context, Function next) {
    return Center(
      child: Card(
        elevation: 3,
        child: SizedBox(
          height: 400,
          child: MultiSelectCheckList(
              maxSelectableCount: 1,
              items: listItems,
              onChange: (allSelected, selectedItem) {
                //do something with the selected item
                appState.setCourseName(selectedItem);
                next();
              }),
        ),
      ),
    );
  }
}

class DaysOfTheWeek extends StatelessWidget {
  final Function next;
  const DaysOfTheWeek({super.key, required this.next});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
          elevation: 3,
          child: SizedBox(
            height: 600,
            child: Column(
              children: [
                MultiSelectCheckList(
                  maxSelectableCount: 6,
                  items: [
                    CheckListCard(title: const Text('Monday'), value: 'Monday'),
                    CheckListCard(
                        title: const Text('Tuesday'), value: 'Tuesday'),
                    CheckListCard(
                        title: const Text('Wednesday'), value: 'Wednesday'),
                    CheckListCard(
                        title: const Text('Thursday'), value: 'Thursday'),
                    CheckListCard(title: const Text('Friday'), value: 'Friday'),
                    CheckListCard(
                        title: const Text('Saturday'), value: 'Saturday'),
                  ],
                  onChange: (allSelected, selectedItem) {
                    //do something with the selected item
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to next page
                   next();
                  },
                  child: const Text('Next'),
                ),
              ],
            ),
          )),
    );
  }
}

class TimeSelection extends StatelessWidget {
  const TimeSelection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
          elevation: 3,
          child: SizedBox(
            height: 200,
            width: 200,
            child: Column(
              children: [
                TextButton(
                  onPressed: () {
                    // Select start time
                  },
                  child: const Text('Start Time'),
                ),
                const Text(' to '),
                TextButton(
                  onPressed: () {
                    // Select end time
                  },
                  child: const Text('End Time'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to next page
                  },
                  child: const Text('Next'),
                ),
              ],
            ),
          )),
    );
  }
}
