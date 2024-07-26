import 'package:accordion/accordion.dart';
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
Map<String, int> subsRating = {};

class TutorAvailabilityPage extends StatefulWidget {
  const TutorAvailabilityPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
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
  // ignore: non_constant_identifier_names
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
                next: _nextPage,
              ),
              //subtopics
              SubTopics(
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

class SubTopics extends StatelessWidget {
  final Function next;
  const SubTopics({super.key, required this.next});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: appState.fetchSubs(appState.courseName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final data = snapshot.data as List<CoursesModel>;
          return Center(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                        'How competent are you in the following concepts',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    Accordion(children: [
                      ...data.map((e) => AccordionSection(
                            isOpen: false,
                            leftIcon: const Icon(Icons.circle_outlined,
                                color: Colors.black54),
                            rightIcon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.black54,
                              size: 20,
                            ),
                            headerBackgroundColor: Colors.transparent,
                            headerBackgroundColorOpened:
                                const Color.fromARGB(255, 255, 255, 255),
                            headerBorderColor: Colors.black54,
                            headerBorderColorOpened: Colors.black54,
                            headerBorderWidth: 1,
                            headerPadding: const EdgeInsets.all(4),
                            contentBackgroundColor:
                                const Color.fromARGB(255, 255, 255, 255),
                            contentBorderColor: Colors.black54,
                            contentBorderWidth: 1,
                            contentVerticalPadding: 30,
                            header: Text(e.name,
                                style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                            content: Column(
                              children: [
                                MultiSelectCheckList(
                                    maxSelectableCount: 1,
                                    items: [
                                      CheckListCard(
                                          title: const Text('1'), value: 1),
                                      CheckListCard(
                                          title: const Text('2'), value: 2),
                                      CheckListCard(
                                          title: const Text('3'), value: 3),
                                      CheckListCard(
                                          title: const Text('4'), value: 4),
                                      CheckListCard(
                                          title: const Text('5'), value: 5)
                                    ],
                                    onChange: (allItems, selected) {
                                      subsRating[e.name] = selected;
                                    }),
                              ],
                            ),
                          )),
                    ]),
                    ElevatedButton(
                      child: const Text('Next'),
                      onPressed: () {
                        if (subsRating.length == 5) {
                          next();
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Incomplete Selection'),
                                content: Text('Please select all options for all 5 sub topics.'),
                                actions: [
                                  TextButton(
                                    child: Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class CoursesBuilder extends StatelessWidget {
  final Future<Object?>? future;
  final Function next;

  const CoursesBuilder({
    super.key,
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

  // ignore: non_constant_identifier_names
  Center SelectCard(List<CheckListCard<String>> listItems, BuildContext context,
      Function next) {
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
  const TimeSelection({super.key});

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
                  submitTutorInfo(
                    context,
                    startTime ?? TimeOfDay.now(),
                    endTime ?? TimeOfDay.now(),
                    appState.courseName!,
                    days,
                  );
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
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

Future<void> submitTutorInfo(
    BuildContext context,
    TimeOfDay startTime,
    TimeOfDay endTime,
    String selectedSubject,
    List<String> selectedDays) async {
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
        "subtopics": subsRating,
        'days': days,
        'startTime': startTime.toString(),
        'endTime': endTime.toString(),
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
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
