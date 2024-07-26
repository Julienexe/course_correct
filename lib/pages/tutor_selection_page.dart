import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_correct/main.dart';
import 'package:course_correct/models/courses_models.dart';
import 'package:course_correct/models/user_model.dart';
import 'package:course_correct/pages/tutors_homepage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';

// int current_page = 0;

//   List<Widget> pages = [
//       Topics(),
//       SubTopics(name: name),
//       DaysOfTheWeek(),
//       TimeSelection()
//     ];
List<String> days = [];
class TutorAvailabilityPage extends StatefulWidget {
  @override
  _TutorAvailabilityPageState createState() => _TutorAvailabilityPageState();
}

class _TutorAvailabilityPageState extends State<TutorAvailabilityPage> {
  

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
                future: appState.getCourses(),
                next:_nextPage,
              ),
              //subtopics
              CoursesBuilder(
                future: appState.fetchSubs(courseName),
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

//Functions to fetch topics and subtopics were moved to appstate

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
                    // Add the selected item to the list of days
                   
                      days.add(selectedItem);
                    
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

class TimeSelection extends StatefulWidget {
  const TimeSelection({Key? key}) : super(key: key);

  @override
  State<TimeSelection> createState() => _TimeSelectionState();
}

class _TimeSelectionState extends State<TimeSelection> {
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

  String _formatTime(TimeOfDay? time) {
    if (time == null) {
      return 'Select Time';
    }
    final hour = time.hourOfPeriod.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 3,
        child: SizedBox(
          height: 200,
          width: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  // Select start time
                  _selectTime(context, true);
                },
                child: Text(_formatTime(startTime)),
              ),
              const Text(' to '),
              TextButton(
                onPressed: () {
                  // Select end time
                  _selectTime(context, false);
                },
                child: Text(_formatTime(endTime)),
              ),
              ElevatedButton(
                onPressed: () {
                  // Navigate to next page
                  submitTutorInfo(context, startTime?? TimeOfDay.now(), endTime?? TimeOfDay.now(), appState.courseName!, days,);
                  Navigator.pushReplacement(context, 
                  MaterialPageRoute(builder: (context){
                    return const TutorHomepage();
                  }));
                },
                child: const Text('Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


Future<void> submitTutorInfo(BuildContext context,TimeOfDay startTime,TimeOfDay endTime, String selectedSubject,List<String>selectedDays) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      
        // Fetch the current data
        try {
  DocumentSnapshot doc = await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .get();
  Map<String, dynamic> existingData = doc.data() as Map<String, dynamic>;
  
  // Prepare the new data to be merged
  Map<String, dynamic> newData = {
    'role': 'tutor',
    'subjects': selectedSubject,
    'days': days,
    'startTime': startTime.toString(),
    'endTime':endTime.toString(),
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
} on Exception catch (e) {
  //show snackbar
  final snackBar = SnackBar(
    content: Text('An error occurred: $e'),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
      
    }
  }