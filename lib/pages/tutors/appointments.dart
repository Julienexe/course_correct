import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

List<Map<String,dynamic>> bookings = [];
// ignore: use_key_in_widget_constructors
class Appointments extends StatelessWidget {
const Appointments({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return FutureBuilder(future: 
    fetchBookings(), 
    builder: (context,index){
      return Scaffold(
        appBar: AppBar(
          title: const Text('Appointments'),
        ),
        body: ListView.builder(
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
                      title: Text('${bookingData['studentName']}'),
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
    );
  }
}

Future<void> fetchBookings() async {
 

    final querySnapshot = await FirebaseFirestore.instance
        .collection('bookings')
        .where('tutorId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    

    List<Map<String, dynamic>> fetchedBookings = [];
    for (var doc in querySnapshot.docs) {
      fetchedBookings.add({
        'id': doc.id,
        'data': doc.data(),
      });
    }
    
    print(fetchedBookings);
    bookings = fetchedBookings;
   
  }