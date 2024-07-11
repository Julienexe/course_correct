//change notifier class
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_correct/models/tutor_model.dart';
import 'package:course_correct/models/user_model.dart';
import 'package:course_correct/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  bool animationcomplete = false;

  //variable to store the current user 
  User? user;
  //variable to store the current theme
  ThemeData _theme = ThemeData.light();
  //getter to get the current theme
  ThemeData get theme => _theme;
  //function to change the theme
  void changeTheme() {
    if (_theme == ThemeData.light()) {
      _theme = ThemeData.dark();
    } else {
      _theme = ThemeData.light();
    }
    notifyListeners();
  }

  Future<void> initialization()async{
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    user = FirebaseAuth.instance.currentUser;
  }

  void logoutUser(BuildContext context) {
     FirebaseAuth.instance.signOut();
    Navigator.pop(context);
    // go to login page
    Navigator.pushReplacement(context, 
    MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  void registerTutorOnFirestore(TutorModel tutor){
    FirebaseFirestore.instance.collection('tutors').doc(user!.uid).set(tutor.toFirestore());
  }

  Future<TutorModel?> getTutor()async{
    final tutorRef = FirebaseFirestore.instance.collection('tutors').doc(user!.uid).withConverter(fromFirestore:TutorModel.fromFirestore , toFirestore: (TutorModel tutor, _) =>tutor.toFirestore());
    final tutorSnap = await tutorRef.get();
    final tutor = tutorSnap.data();
    return tutor;
  }

  //function to get all tutors
  Future<List<TutorModel>> getAllTutors() async {
    final tutorsRef = FirebaseFirestore.instance.collection('tutors').withConverter(
      fromFirestore: (snapshot, _) => TutorModel.fromFirestore(snapshot.data()! as DocumentSnapshot<Map<String, dynamic>>,_),
      toFirestore: (tutor, _) => tutor.toFirestore(),
    );
    final tutorsSnap = await tutorsRef.get();
    final tutors = tutorsSnap.docs.map((doc) => doc.data()).toList();
    return tutors;
  }

  void usertoFirebase(bool isTutor){
    FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
      'isTutor': isTutor,
    });
  }

  Future<bool> isUserTutor() async {
    var user = FirebaseAuth.instance.currentUser;
    final userRef = FirebaseFirestore.instance.collection('users').doc(user!.uid).withConverter(fromFirestore: UserModel.fromFirestore, toFirestore: (user, _) => user.toFirestore());
    final userSnap = await userRef.get();
    final userModel = userSnap.data();
    return userModel!.isTutor;
  }
}