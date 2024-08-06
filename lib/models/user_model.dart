import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  String name;
  String? role;

  UserModel({
    required this.name, this.role
  });

  //to firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'role': role,
    };
  }

  //from firestore
  factory UserModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return UserModel(
      name: data!['name'],
      role: data['role'],
    );
  }
}