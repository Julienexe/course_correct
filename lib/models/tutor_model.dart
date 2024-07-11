import 'package:cloud_firestore/cloud_firestore.dart';

class TutorModel {
  String email;
  bool isBooked;
  DateTime startingTime;
  DateTime endingTime;
  final List<String>? subjects;

  TutorModel(
      {required this.email,
      this.isBooked = false,
      required this.startingTime,
      required this.endingTime,
      this.subjects
      });

  //to firestore
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'isBooked': isBooked,
      'startingTime': startingTime.toString(),
      'endingTime': endingTime.toString(),
      "subjects" : subjects,
    };
  }

  //from firestore
  factory TutorModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return TutorModel(
      email: data?['email'],
      isBooked: data?['isBooked'],
      startingTime: data?['startingTime'].toDate(),
      endingTime: data?['endingTime'].toDate(),
      subjects: 
        data?["subjects"] is Iterable ? List.from(data?["subjects"]):null,
    );
  }
}
