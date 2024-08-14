import 'package:course_correct/services/notification_service.dart';
import 'package:course_correct/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

double _slotFactor = 0;
class TutorBookingPage extends StatefulWidget {
  @override
  _TutorBookingPageState createState() => _TutorBookingPageState();
}

class _TutorBookingPageState extends State<TutorBookingPage> {
  List<Map<String, dynamic>> tutors = [];
  bool _isLoading = false; 

  @override
  void initState() {
    super.initState();
    fetchTutors();
  }

  Future<void> fetchTutors() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('tutors')
        .doc(appState.selectedTutor)
        .get();
    List<Map<String, dynamic>> fetchedTutors = [];
    
      fetchedTutors.add({
        'id': querySnapshot.id,
        'data': querySnapshot.data(),
      });
    setState(() {
      tutors = fetchedTutors;
    });
  }

Future<void> createBookingNotification(String studentId, String tutorId, String message) async {
  // Get current timestamp
  final timestamp = Timestamp.now();

  // Notification for the student
  await FirebaseFirestore.instance.collection('notifications').add({
    'recipientId': studentId,
    'recipientType': 'student',
    'message': message,
    'timestamp': timestamp,
    'isRead': false,
  });

  // Notification for the tutor
  await FirebaseFirestore.instance.collection('notifications').add({
    'recipientId': tutorId,
    'recipientType': 'tutor',
    'message': message,
    'timestamp': timestamp,
    'isRead': false,
  });
}

Future<void> checkForMissedNotifications() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  String userId = user.uid;
  String userType = await getUserType(userId); // Fetch whether the user is a student or tutor

  // Fetch unread notifications
  final querySnapshot = await FirebaseFirestore.instance
      .collection('notifications')
      .where('recipientId', isEqualTo: userId)
      .where('recipientType', isEqualTo: userType)
      .where('isRead', isEqualTo: false)
      .get();

  // Display notifications or handle them as needed
  for (var doc in querySnapshot.docs) {
    String message = doc['message'];
    // Display notification to the user
    // You could use a local notification library or show them in the UI
    print('Missed Notification: $message');

    // Mark the notification as read
    doc.reference.update({'isRead': true});
  }
}

Future<String> getUserType(String userId) async {
  final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
  return userDoc.data()?['role'] ?? 'student'; // Default to 'student' if role not found
}



  Future<bool> canBookSessionThisMonth(String studentId, String tutorId) async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0); // Last day of the month

    final bookings = await FirebaseFirestore.instance
        .collection('bookings')
        .where('studentId', isEqualTo: studentId)
        .where('tutorId', isEqualTo: tutorId)
        .where('startTime', isGreaterThanOrEqualTo: startOfMonth)
        .where('startTime', isLessThanOrEqualTo: endOfMonth)
        .get();

    return bookings.docs.length < 3; // Allow up to 3 bookings per month
  }

  Future<void> bookSession(String studentId, String tutorId, DateTime startTime, DateTime endTime) async {
  //print(startTime);
  setState(() {
    _isLoading = true; // Set loading state to true
  });

  try {
    final now = DateTime.now();


    // Ensure the booking is exactly one hour
    if (endTime.difference(startTime) != Duration(hours: 1)) {
      throw Exception('Booking must be exactly one hour.');
    }
    // Check if the student has already booked this tutor for this time slot
    final existingBookings = await FirebaseFirestore.instance
        .collection('bookings')
        .where('studentId', isEqualTo: studentId)
        .where('tutorId', isEqualTo: tutorId)
        .where('startTime', isEqualTo: startTime)
        .get();

    if (existingBookings.docs.isNotEmpty) {
      throw Exception('You have already booked this slot.');
    }

    // Check if the tutor is available for this time slot
    final tutorData = await FirebaseFirestore.instance
        .collection('tutors')
        .doc(tutorId)
        .get();
    String startTimeStr = _parseTimeOfDay(tutorData['startTime']); 
    String endTimeStr = _parseTimeOfDay(tutorData['endTime']); 
    final availableStartTime = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(startTimeStr.split(':')[0]),
      int.parse(startTimeStr.split(':')[1].split(' ')[0]),
    );

    final availableEndTime = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(endTimeStr.split(':')[0]),
      int.parse(endTimeStr.split(':')[1].split(' ')[0]),
    );

    if (startTime.isBefore(availableStartTime) || endTime.isAfter(availableEndTime)) {
      throw Exception('Selected time slot is out of the tutor\'s available hours.');
    }

    // Check if the student has reached the monthly booking limit for this tutor
    if (await canBookSessionThisMonth(studentId, tutorId)) {
      final studentData = await FirebaseFirestore.instance
          .collection('users')
          .doc(studentId)
          .get();

      final tutorName = tutorData['name'] ?? 'Unknown';
      final studentName = studentData['name'] ?? 'Unknown';

      await FirebaseFirestore.instance.collection('bookings').add({
        'studentId': studentId,
        'tutorId': tutorId,
        'startTime': startTime,
        'endTime': endTime,
        'tutorName': tutorName,
        'studentName': studentName,
      });

      
      
      final newAvailability = tutorData['availability'] - _slotFactor;
      await FirebaseFirestore.instance.collection('tutors').doc(tutorId).update({
        'availability': newAvailability,
      });

      // Show custom floating notification for student
      CustomFloatingNotification.show(context, 'Session booked successfully!');

      // Show status bar notification for student
      NotificationService().showNotification(
        id: 1,
        title: 'Booking Confirmed',
        body: 'You have booked a session with tutor $tutorName from ${startTime.hour}:${startTime.minute.toString().padLeft(2, '0')} to ${endTime.hour}:${endTime.minute.toString().padLeft(2, '0')}',
      );

      // Notify the tutor
      // final tutorToken = tutorData['deviceToken']; // Assuming 'deviceToken' is stored in Firestore
      // if (tutorToken != null) {
      //   NotificationService().showNotification(
      //     id: 2, // Use a different ID to differentiate notifications
      //     title: 'New Booking',
      //     body: 'You have a new session booked with student $studentName from ${startTime.hour}:${startTime.minute.toString().padLeft(2, '0')} to ${endTime.hour}:${endTime.minute.toString().padLeft(2, '0')}',
      //     payload: 'booking_${startTime.millisecondsSinceEpoch}', // Optional: pass additional data
      //     channelId: 'tutor_channel_id', // Separate channel for tutors
      //     channelName: 'Tutor Notifications',
      //     channelDescription: 'Notifications for new tutor bookings.',

      //   );
      // }
    } else {
      throw Exception('Booking limit reached for this month');
    }
  } catch (e) {
    // Show custom floating notification for errors
    CustomFloatingNotification.show(context, 'Error: $e');

    // Optionally, show a status bar notification for errors
    NotificationService().showNotification(
      id: 3, // Use a different ID for error notifications
      title: 'Booking Error',
      body: 'Failed to book session: $e',
    );
  } finally {
    setState(() {
      _isLoading = false; // Set loading state to false after booking
    });
  }
  Navigator.pushReplacementNamed(context, '/studentHomepage');
}




  // Function to generate one-hour slots
  List<DateTime> generateTimeSlots(DateTime start, DateTime end) {
    List<DateTime> slots = [];
    DateTime slotStart = start;
    while (slotStart.add(const Duration(hours: 1)).isBefore(end) || slotStart.add(const Duration(hours: 1)).isAtSameMomentAs(end)) {
      slots.add(slotStart);
      slotStart = slotStart.add(const Duration(hours: 1));
    }
    _slotFactor = 1/slots.length;
    return slots;
  }
  //parse time of day properly
  String _parseTimeOfDay(String timeString) {
  final timeParts = timeString.replaceAll('TimeOfDay(', '').replaceAll(')', '').split(':');
  final hour = int.parse(timeParts[0]);
  final minute = int.parse(timeParts[1]);

  return "$hour:$minute";
}
  // Helper function to parse time strings
  DateTime _parseTime(String timeStr, DateTime referenceDate) {
    //if the string starts with TimeOfDay, parse it as TimeOfDay
    if (timeStr.startsWith('TimeOfDay')){
      
    timeStr = _parseTimeOfDay(timeStr);
    } 
    
    final amPmPattern = RegExp(r'(AM|PM)$', caseSensitive: false);
    bool is12HourFormat = amPmPattern.hasMatch(timeStr);

    // Handle 12-hour format with AM/PM
    if (is12HourFormat) {
      final parts = timeStr.split(RegExp(r'[:\s]'));
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      final period = parts[2].toUpperCase();

      int hour24 = hour % 12;
      if (period == 'PM') hour24 += 12;

      return DateTime(
        referenceDate.year, referenceDate.month, referenceDate.day,
        hour24, minute,
      );
    }

    // Handle 24-hour format
    final parts = timeStr.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    
    
    return DateTime(
      referenceDate.year, referenceDate.month, referenceDate.day,
      hour, minute,
    );
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String studentId = user?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book an appointment'),
      ),
      body: _isLoading
          ? const Center(
              child: const CircularProgressIndicator(),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: tutors.length,
              itemBuilder: (context, index) {
                final tutor = tutors[index];
                final tutorData = tutor['data'] as Map<String, dynamic>?;

                if (tutorData == null) {
                  return const Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text('No data available'),
                    ),
                  );
                }

                final tutorName = tutorData['name'] ?? 'Unknown';
                dynamic startTimeStr = (tutorData['startTime'] )?? '00:00'; // Default to '00:00' if null
                dynamic endTimeStr = tutorData['endTime'] ?? '23:59'; // Default to '23:59' if null

                DateTime startOfDay = DateTime.now(); // Adjust as needed

                DateTime? availableStart;
                DateTime? availableEnd;

                try {

                  if (startTimeStr.startsWith("Time") || endTimeStr.startsWith("Time")){
                    startTimeStr = _parseTimeOfDay(startTimeStr);
                    endTimeStr = _parseTimeOfDay(endTimeStr);
                    availableStart = _parseTime(startTimeStr, startOfDay);
                    availableEnd = _parseTime(endTimeStr, startOfDay);
                  }else{

                  availableStart = _parseTime(startTimeStr, startOfDay);
                  availableEnd = _parseTime(endTimeStr, startOfDay);
                  }

                  // Generate time slots
                  List<DateTime> timeSlots = generateTimeSlots(availableStart, availableEnd);
                  //print(timeSlots);

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ExpansionTile(
                      title: Text(
                        tutorName,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Available from $startTimeStr to $endTimeStr',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      leading: const Icon(Icons.school, color: Colors.blue),
                      children: timeSlots.map((slot) {
                        DateTime slotEnd = slot.add(const Duration(hours: 1));
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${slot.hour}:${slot.minute.toString().padLeft(2, '0')} - ${slotEnd.hour}:${slotEnd.minute.toString().padLeft(2, '0')}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              ElevatedButton(
                                onPressed: () async {
                                  try {
                                  
                                    await bookSession(studentId, tutor['id'], slot, slotEnd);
                                  } catch (e) {
                                    // Error handling is already included in bookSession
                                  }
                                },
                                child: const Text('Book'),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white, backgroundColor: Colors.cyan,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  );
                } catch (e) {
                  print('Error parsing time: $e');
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(
                        '$tutorName has no valid available times',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  );
                }
              },
            ),
    );
  }
}
