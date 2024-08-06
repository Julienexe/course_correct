import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: use_key_in_widget_constructors
class AppointmentsPage extends StatefulWidget {
  @override
  _AppointmentsPageState createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  List<Map<String, dynamic>> bookings = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    setState(() {
      _isLoading = true;
    });

    final querySnapshot = await FirebaseFirestore.instance
        .collection('bookings')
        .where('studentId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    List<Map<String, dynamic>> fetchedBookings = [];
    for (var doc in querySnapshot.docs) {
      fetchedBookings.add({
        'id': doc.id,
        'data': doc.data(),
      });
    }

    setState(() {
      bookings = fetchedBookings;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                final bookingData = booking['data'] as Map<String, dynamic>;

                final startTime = bookingData['startTime'] as Timestamp;
                final endTime = bookingData['endTime'] as Timestamp;

                final startDateTime = DateTime.fromMillisecondsSinceEpoch(startTime.millisecondsSinceEpoch);
                final endDateTime = DateTime.fromMillisecondsSinceEpoch(endTime.millisecondsSinceEpoch);

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text('${bookingData['tutorName']}'),
                    subtitle: Text(
                      'From: ${startDateTime.hour}:${startDateTime.minute.toString().padLeft(2, '0')} ${startDateTime.hour < 12 ? 'AM' : 'PM'}'
                      '\nTo: ${endDateTime.hour}:${endDateTime.minute.toString().padLeft(2, '0')} ${endDateTime.hour < 12 ? 'AM' : 'PM'}'
                      '\nDate: ${startDateTime.day}/${startDateTime.month}/${startDateTime.year}',
                    ),
                  ),
                );
              },
            ),
    );
  }
}