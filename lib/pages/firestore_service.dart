import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addCourse(String courseCode, String courseName) {
    return _db.collection('courses').add({
      'courseCode': courseCode,
      'courseName': courseName,
    });
  }

  Stream<List<Course>> getCourses() {
    return _db.collection('courses').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Course.fromFirestore(doc.data())).toList());
  }
}

class Course {
  final String courseCode;
  final String courseName;

  Course({
    required this.courseCode,
    required this.courseName,
  });

  factory Course.fromFirestore(Map<String, dynamic> data) {
    return Course(
      courseCode: data['courseCode'],
      courseName: data['courseName'],
    );
  }
}
