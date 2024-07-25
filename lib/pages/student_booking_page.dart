import 'package:course_correct/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TutorBookingPage extends StatefulWidget {
  @override
  _TutorBookingPageState createState() => _TutorBookingPageState();
}

class _TutorBookingPageState extends State<TutorBookingPage> {
  List<Map<String, dynamic>> tutors = [];
  bool _isLoading = false; // Add this variable

  @override
  void initState() {
    super.initState();
    fetchTutors();
  }

  Future<void> fetchTutors() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'tutor')
        .get();
    List<Map<String, dynamic>> fetchedTutors = [];
    for (var doc in querySnapshot.docs) {
      fetchedTutors.add({
        'id': doc.id,
        'data': doc.data(),
      });
    }
    setState(() {
      tutors = fetchedTutors;
    });
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
        .collection('users')
        .doc(tutorId)
        .get();

    final availableStartTime = DateTime(
      now.year, now.month, now.day,
      int.parse(tutorData['startTime'].split(':')[0]),
      int.parse(tutorData['startTime'].split(':')[1].split(' ')[0]),
    );

    final availableEndTime = DateTime(
      now.year, now.month, now.day,
      int.parse(tutorData['endTime'].split(':')[0]),
      int.parse(tutorData['endTime'].split(':')[1].split(' ')[0]),
    );

    if (startTime.isBefore(availableStartTime) || endTime.isAfter(availableEndTime)) {
      throw Exception('Selected time slot is out of the tutor\'s available hours.');
    }

    // Check if the student has reached the monthly booking limit for this tutor
    if (await canBookSessionThisMonth(studentId, tutorId)) {
      await FirebaseFirestore.instance.collection('bookings').add({
        'studentId': studentId,
        'tutorId': tutorId,
        'startTime': startTime,
        'endTime': endTime,
      });

      // Show custom floating notification
      CustomFloatingNotification.show(context, 'Session booked successfully!');

      // Show status bar notification
      NotificationService().showNotification(
        id: 1,
        title: 'Booking Confirmed',
        body: 'Your session with tutor $tutorId has been booked successfully.',
      );

    } else {
      throw Exception('Booking limit reached for this month');
    }
  } catch (e) {
    // Show custom floating notification for errors
    CustomFloatingNotification.show(context, 'Error: $e');

    // Optionally, show a status bar notification for errors
    NotificationService().showNotification(
      id: 2,
      title: 'Booking Error',
      body: 'Failed to book session: $e',
    );
  } finally {
    setState(() {
      _isLoading = false; // Set loading state to false after booking
    });
  }
}


  // Function to generate one-hour slots
  List<DateTime> generateTimeSlots(DateTime start, DateTime end) {
    List<DateTime> slots = [];
    DateTime slotStart = start;
    while (slotStart.add(Duration(hours: 1)).isBefore(end) || slotStart.add(Duration(hours: 1)).isAtSameMomentAs(end)) {
      slots.add(slotStart);
      slotStart = slotStart.add(Duration(hours: 1));
    }
    return slots;
  }

  // Helper function to parse time strings
  DateTime _parseTime(String timeStr, DateTime referenceDate) {
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
        title: Text('Select and Book a Tutor'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: tutors.length,
              itemBuilder: (context, index) {
                final tutor = tutors[index];
                final tutorData = tutor['data'] as Map<String, dynamic>?;

                if (tutorData == null) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text('No data available'),
                    ),
                  );
                }

                final tutorName = tutorData['name'] ?? 'Unknown';
                final startTimeStr = tutorData['startTime'] ?? '00:00'; // Default to '00:00' if null
                final endTimeStr = tutorData['endTime'] ?? '23:59'; // Default to '23:59' if null

                DateTime startOfDay = DateTime.now(); // Adjust as needed

                DateTime? availableStart;
                DateTime? availableEnd;

                try {
                  availableStart = _parseTime(startTimeStr, startOfDay);
                  availableEnd = _parseTime(endTimeStr, startOfDay);

                  // Generate time slots
                  List<DateTime> timeSlots = generateTimeSlots(availableStart, availableEnd);

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ExpansionTile(
                      title: Text(
                        tutorName,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Available from $startTimeStr to $endTimeStr',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      leading: Icon(Icons.school, color: Colors.blue),
                      children: timeSlots.map((slot) {
                        DateTime slotEnd = slot.add(Duration(hours: 1));
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${slot.hour}:${slot.minute.toString().padLeft(2, '0')} - ${slotEnd.hour}:${slotEnd.minute.toString().padLeft(2, '0')}',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              SizedBox(width: 8.0),
                              ElevatedButton(
                                onPressed: () async {
                                  try {
                                    await bookSession(studentId, tutor['id'], slot, slotEnd);
                                  } catch (e) {
                                    // Error handling is already included in bookSession
                                  }
                                },
                                child: Text('Book'),
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
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(
                        '$tutorName has no valid available times',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  );
                }
              },
            ),
    );
  }
}
