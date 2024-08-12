import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_correct/main.dart';
import 'package:flutter/material.dart';

class AppointmentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
      ),
      body: FutureBuilder(
          future: getBookings(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: const Text('Appointment'),
                      subtitle: Column(
                        children: [
                          Text(snapshot.data?[index]['startTime']),
                          Text(snapshot.data?[index]['endTime']),
                        ],
                      ),
                    );
                  });
            } else if (snapshot.data == null || snapshot.data!.isEmpty) {
              return const Center(child: Text('No appointments for you yet'));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}

Future<List<Map<String, dynamic>>> getBookings() async {
  final db = FirebaseFirestore.instance;
  var bookings = await db
      .collection('bookings')
      .where('tutorId', isEqualTo: appState.user?.uid)
      .get()
      .then((value) => value.docs.map((e) => e.data()).toList());
  //print(bookings);
  return bookings;
}
