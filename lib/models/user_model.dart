import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  bool isTutor;

  UserModel({
    required this.isTutor
  });

  //to firestore
  Map<String, dynamic> toFirestore() {
    return {
      'isTutor': isTutor,
    };
  }

  //from firestore
  factory UserModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return UserModel(
      isTutor: data?['isTutor'],
    );
  }
}