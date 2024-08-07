//change notifier class

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_correct/models/courses_models.dart';
import 'package:course_correct/models/tutor_model.dart';
import 'package:course_correct/models/user_model.dart';
import 'package:course_correct/pages/chat_service.dart';
import 'package:course_correct/pages/landing_page.dart';
import 'package:course_correct/pages/login_page.dart';
import 'package:course_correct/pages/student_homepage.dart';
import 'package:course_correct/pages/Tutors_homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class AppState extends ChangeNotifier {
  //variable to create a chatservice instance
  ChatService chatService = ChatService();
  bool animationcomplete = false;
  String? selectedTutor;

  //variable to store the current user
  User? user;
  UserModel? userProfile;
  //variable to store the current theme
  ThemeData _theme = ThemeData.light();
  //getter to get the current theme
  ThemeData get theme => _theme;
  //function to change the theme

  //course related variables
  String? courseName;
  CoursesModel? course;
  void setTutor(tutor){
    selectedTutor = tutor;
    notifyListeners();
  }
  void changeTheme() {
    if (_theme == ThemeData.light()) {
      _theme = ThemeData.dark();
    } else {
      _theme = ThemeData.light();
    }
    notifyListeners();
  }

  Future<void> initialization() async {
    setUser(FirebaseAuth.instance.currentUser);
    setUserProfile(await readUserProfileFromFirestore());
  }

  //user related functions
  void setUser(User? user) {
    this.user = user;
    notifyListeners();
  }

  void logoutUser(BuildContext context) {
    FirebaseAuth.instance.signOut();
    Navigator.pop(context);
    // go to login page
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  void registerTutorOnFirestore(TutorModel Tutor) {
    FirebaseFirestore.instance
        .collection('Tutors')
        .doc(user!.uid)
        .set(Tutor.toFirestore());
  }

  //function to get all Tutors

  void usertoFirebase(bool isTutor) {
    FirebaseFirestore.instance.collection('users').doc(user!.uid).set({});
  }

  Future<void> loginSequence(
      String email, String password, BuildContext context) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(
        children: [
          Text(
            'Logging you in',
            style: defaultTextStyle.copyWith(color: Colors.white),
          ),
          const Spacer(),
          const CircularProgressIndicator()
        ],
      )));
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      if (user != null) {
        setUser(user);
        userProfile = await readUserProfileFromFirestore();
        notifyListeners();
        if (userProfile!.role == 'Tutor') {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const TutorHomepage()));
        } else if (userProfile!.role == 'student') {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const StudentHomepage()));
        } else {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LandingPage()));
        }
      }
    } catch (e) {
      snackBarMessage(e.toString(), context);
    }
  }

  Future<UserModel?> readUserProfileFromFirestore() async {
    user = FirebaseAuth.instance.currentUser;
    String userUid = user?.uid ?? '';
    if (user != null) {
      final userRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userUid)
          .withConverter(
            fromFirestore: (snapshot, _) =>
                UserModel.fromFirestore(snapshot, _),
            toFirestore: (user, _) => user.toFirestore(),
          );
      final userSnap = await userRef.get();
      final user = userSnap.data();
      return user;
    } else {
      return null;
    }
  }

  Future<void> registerSequence(
      String email, String password, String name, BuildContext context) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(
        children: [
          Text(
            'Registering',
            style: defaultTextStyle.copyWith(color: Colors.white),
          ),
          const Spacer(),
          const CircularProgressIndicator()
        ],
      )));
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'email': email,
          'name': name,
          'created_at': FieldValue.serverTimestamp(),
        });
        setUser(user);
        userProfile = UserModel(name: name);
        notifyListeners();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LandingPage()));
      }
    } catch (e) {
      snackBarMessage(e.toString(), context);
    }
  }

  void setUserProfile(UserModel? userProfile) {
    this.userProfile = userProfile;
    notifyListeners();
  }

  //COURSE RELATED FUNCTIONS
  void setCourseName(String courseName) {
    this.courseName = courseName;
    notifyListeners();
  }

  Future<List<CoursesModel>> fetchCourses(dbRef) async {
    try {
      var snap = await dbRef.get();
      return CoursesModel.listFromFirestore(snap);
    } catch (e) {
      //print("Error fetching courses: $e");
      return [];
    }
  }

  Future<List<CoursesModel>> getCourses() async {
    return await fetchCourses(
        FirebaseFirestore.instance.collection('Courses '));
  }

  Future<List<CoursesModel>> fetchSubs(String? name) {
    return fetchCourses(FirebaseFirestore.instance
        .collection("Courses ")
        .doc(name)
        .collection("subs"));
  }

  Future<List<Map>> fetchTutors() async {
    final db = FirebaseFirestore.instance;
    final ref = db.collection("tutors");
    var snap = await ref.get();
    
    
    return TutorModel.listFromFirestore(snap);
  }

  snackBarMessage(String text, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
    ));
  }

  //chat service functions
  void createChatRoom(String chatroomId, List<String> participants) {
    chatService.createChatRoom(chatroomId, participants);
  }

  void sendMessage(String chatroomId, String senderId, String text) {
    chatService.sendMessage(chatroomId, senderId, text);
  }

  Stream<QuerySnapshot> getMessages(String chatroomId) {
    return chatService.getMessages(chatroomId);
  }

  
}
