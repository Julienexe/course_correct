import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

class CoursesModel {
  String name;

  CoursesModel({
    required this.name,
  });

  //factory method to create a new instance of the model from firestore
  factory CoursesModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return CoursesModel(
      name: data['name'],
    );
  }

  //method to create a list of model instances from firestore
  static List<CoursesModel> listFromFirestore(QuerySnapshot snapshot) {

    return snapshot.docs.map((doc) {
      return CoursesModel.fromFirestore(doc);
    }).toList();
  }
}