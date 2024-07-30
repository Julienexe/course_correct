import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:concentric_transition/concentric_transition.dart';
import 'package:course_correct/main.dart';
import 'package:course_correct/models/courses_models.dart';
import 'package:course_correct/models/user_model.dart';
import 'package:course_correct/pages/tutors_homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';

List<String> days = [];
Map<String, int> subsRating = {};
TimeOfDay? startTime;
TimeOfDay? endTime;

final pages = [
  PageData(
    dataCheck: () {
      if (appState.courseName == null) {
        return false;
      }
      return true;
    },
    content: CoursesBuilder(
      future: appState.getCourses(),
      next: () {
        //appState.setCourseName('');
      },
    ),
    icon: Icons.school_outlined,
    title: "Enter your subject",
    bgColor: const Color(0xff3b1791),
    textColor: Colors.white,
  ),
  PageData(
    dataCheck: () {
      if (subsRating.keys.length < 5) {
        return false;
      }
      return true;
    },
    content: SubTopics(next: () {}),
    icon: Icons.topic,
    title: "Rate your expertise in 5 subtopics",
    bgColor: const Color(0xfffab800),
    textColor: const Color(0xff3b1790),
  ),
  PageData(
    dataCheck: () {
      if (days.isEmpty) {
        return false;
      }
      return true;
    },
    content: DaysOfTheWeek(next: () {}),
    icon: Icons.delivery_dining,
    title: "On Which days are you available",
    bgColor: const Color(0xff3b1790),
    textColor: const Color(0xffffffff),
  ),
  PageData(
    dataCheck: () {
      if (startTime == null || endTime == null) {
        return false;
      }
      return true;
    },
    content: const TimeSelection(),
    icon: Icons.delivery_dining,
    title: "Please select the time you are available",
    bgColor: const Color(0xfffab800),
    textColor: const Color(0xff3b1790),
  ),
];

class ConcentricAnimationOnboarding extends StatelessWidget {
  const ConcentricAnimationOnboarding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ConcentricPageView(
        itemCount: pages.length,
        colors: pages.map((p) => p.bgColor).toList(),
        radius: screenWidth * 0.1,
        onChange: (page) => () {
          if (pages[page].dataCheck!()) {
            return;
          }
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Incomplete Selection'),
                content: const Text(
                    'Please select all options for all 5 sub topics.'),
                actions: [
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        onFinish: () {
          try {
            submitTutorInfo(
                context, startTime!, endTime!, appState.courseName!, days);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const TutorHomepage()));
          }catch (e) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Incomplete Selection',
                  style:TextStyle(
                      fontSize: 16,
                      color: Color(0xff3b1791),
                      fontWeight: FontWeight.bold
                  ) ,),
                  content: const Text(
                      'Please complete selections for all the pages, make sure you have ranked 5 subtopics and selected appropriate days and time for sessions. \n Hint: You can go back by swiping down on the page.',
                      style: TextStyle(
                          fontSize: 16,
                          color: Color(0xff3b1791),
                          fontWeight: FontWeight.bold
                      ),),
                  actions: [
                    TextButton(
                      child: const Text('OK'),
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
        nextButtonBuilder: (context) => Padding(
          padding: const EdgeInsets.only(left: 3), // visual center
          child: Icon(
            Icons.navigate_next,
            size: screenWidth * 0.08,
          ),
        ),
        // enable itemcount to disable infinite scroll
        // itemCount: pages.length,
        // opacityFactor: 2.0,
        scaleFactor: 2,
        // verticalPosition: 0.7,
        // direction: Axis.vertical,
        // itemCount: pages.length,
        // physics: NeverScrollableScrollPhysics(),
        itemBuilder: (index) {
          final page = pages[index % pages.length];
          return SafeArea(
            child: _Page(page: page),
          );
        },
      ),
    );
  }
}

class PageData {
  final String? title;
  final IconData? icon;
  final Color bgColor;
  final Color textColor;
  final Widget? content;
  final Function? dataCheck;

  const PageData({
    this.content,
    this.dataCheck,
    this.title,
    this.icon,
    this.bgColor = Colors.white,
    this.textColor = Colors.black,
  });
}

class _Page extends StatelessWidget {
  final PageData page;

  const _Page({Key? key, required this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          height: 90,
        ),
        Container(
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.all(16.0),
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: page.textColor),
          child: Icon(
            page.icon,
            size: screenHeight * 0.1,
            color: page.bgColor,
          ),
        ),
        Text(
          page.title ?? "",
          style: TextStyle(
              color: page.textColor,
              fontSize: screenHeight * 0.035,
              fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(
            height: 240,
            child: SizedBox.expand(child: page.content ?? Container())),
      ],
    );
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
          height: 200,
          width: 200,
          child: MultiSelectCheckList(
              textStyles: const MultiSelectTextStyles(
                textStyle: TextStyle(
                    fontSize: 16,
                    color: Color(0xff3b1791),
                    fontWeight: FontWeight.bold),
                selectedTextStyle: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.bold),
              ),
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
                height: 210,
                width: 300,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            //showNumbers(context, data[index].name);
                            //show dialog to select
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) => Container(
                                padding: const EdgeInsets.all(10),
                                height: MediaQuery.of(context).size.height *
                                    0.5, // Occupy half of the page
                                child: Column(
                                  children: [
                                    MultiSelectCheckList(
                                      itemPadding: const EdgeInsets.all(10),
                                      textStyles: const MultiSelectTextStyles(
                                        textStyle: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xff3b1791),
                                            fontWeight: FontWeight.bold),
                                      ),
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
                                        subsRating[data[index].name] = selected;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 2,
                            child: Container(
                              width: 150,
                              height: 100,
                              padding: const EdgeInsets.only(
                                top: 8,
                                left: 6,
                                right: 6,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const CircleAvatar(
                                    radius: 40,
                                    backgroundImage: NetworkImage(
                                        'https://via.placeholder.com/150'),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    data[index].name,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    itemCount: data.length),
              ),
            ),
          );
        });
  }
}

//pop up dialog
Future showNumbers(BuildContext context, sub) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Selection a number'),
        content: Column(
          children: [
            MultiSelectCheckList(
                itemPadding: const EdgeInsets.all(2.5),
                maxSelectableCount: 1,
                items: [
                  CheckListCard(title: const Text('1'), value: 1),
                  CheckListCard(title: const Text('2'), value: 2),
                  CheckListCard(title: const Text('3'), value: 3),
                  CheckListCard(title: const Text('4'), value: 4),
                  CheckListCard(title: const Text('5'), value: 5)
                ],
                onChange: (allItems, selected) {
                  subsRating[sub] = selected;
                }),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

class DaysOfTheWeek extends StatelessWidget {
  final Function next;
  const DaysOfTheWeek({super.key, required this.next});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
          elevation: 3,
          child: SingleChildScrollView(
            child: SizedBox(
              height: 240,
              width: 300,
              child: MultiSelectCheckList(
                maxSelectableCount: 6,
                items: [
                  CheckListCard(title: const Text('Monday'), value: 'Monday'),
                  CheckListCard(title: const Text('Tuesday'), value: 'Tuesday'),
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

  Text _formatTime(TimeOfDay? time) {
    if (time == null) {
      return const Text(
        'Select Time',
        style: TextStyle(
            fontSize: 16,
            color: Color(0xff3b1791),
            fontWeight: FontWeight.bold),
      );
    }
    final hour = time.hourOfPeriod.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return Text(
      '$hour:$minute $period',
      style: const TextStyle(
          fontSize: 16, color: Color(0xff3b1791), fontWeight: FontWeight.bold),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 1,
        child: SizedBox(
          height: 170,
          width: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  // Select start time
                  _selectTime(context, true);
                },
                child: _formatTime(startTime),
              ),
              const Text(' to '),
              TextButton(
                onPressed: () {
                  // Select end time
                  _selectTime(context, false);
                },
                child: _formatTime(endTime),
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
        "name": existingData['name'],
        "email": existingData['email'],
        'role': 'tutor',
        'subjects': selectedSubject,
        "subtopics": subsRating,
        'days': days,
        'startTime': startTime.toString(),
        'endTime': endTime.toString(),
        "availability": 1,
        "experience": 1,
        "isBooked": false,

      };

      // Merge existing data with new data
      await FirebaseFirestore.instance.collection('tutors').doc(user.uid).set({
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
