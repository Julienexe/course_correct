import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

class CoursesModel {
  String name;

  CoursesModel({
    required this.name,
  });

  //from firestore
  CoursesModel.fromSnapshot(DocumentSnapshot snapshot)
  : name = snapshot['name'];

  //list of courses from firestore
  static List<CoursesModel> fromSnapshotList(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) => CoursesModel.fromSnapshot(doc)).toList();
    }
}