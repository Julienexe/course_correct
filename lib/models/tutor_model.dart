import 'package:cloud_firestore/cloud_firestore.dart';


class TutorModel {
  String email;
  bool isBooked;
  DateTime startingTime;
  DateTime endingTime;
  String subject;
  String name;
  double availability; // Percentage of available slots (0-1)
  Map<String,int> subtopics; // Subtopic -> Expertise level (1-5)
  int experience;
  List days;

  TutorModel({
    required this.subject,
    required this.email,
    required this.startingTime,
    required this.endingTime,
    required this.name,
    required this.availability,
    required this.subtopics,
    required this.experience,
    required this.isBooked,
    required this.days
  });

  //to firestore
  Map<String, dynamic> toFirestore() => {
        'email': email,
        'isBooked': isBooked,
        'startingTime': startingTime.toString(),
        'endingTime': endingTime.toString(),
        "subjects": subject,
      };

  //from firestore
  static Map fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    //print(data);
    return {
      'email': data['email'],
      'isBooked': data['isBooked'],
      'startingTime': data['startTime'],
      'endingTime': data['endTime'],
      'subject': data['subjects'],
      'name': data['name'],
      'availability': data['availability'],
      'subtopics': data['subtopics'],
      'experience': data['experience'],
      'days': data['days'],
      "id": doc.id
    };
  }

  static List<Map> listFromFirestore(QuerySnapshot snapshot) {
    //print(TutorModel.fromFirestore(snapshot.docs[0]));
    return snapshot.docs.map((doc) {
      return TutorModel.fromFirestore(doc);
    }).toList();
  }
}
