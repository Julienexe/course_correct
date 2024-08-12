import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_correct/main.dart';
import 'package:flutter/material.dart';

class AppointmentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments'),
      ),
      body: FutureBuilder(
          future: getBookings(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('Appointment'),
                      subtitle: Column(
                        children: [
                          Text(snapshot.data?[index]['startTime']),
                          Text(snapshot.data?[index]['endTime']),
                        ],
                      ),
                    );
                  });
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}

Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getBookings() async {
  final db = FirebaseFirestore.instance;
  var bookings = await db
      .collection('bookings')
      .where('tutorId', isEqualTo: appState.user?.uid)
      .get();
  return bookings.docs;
}
