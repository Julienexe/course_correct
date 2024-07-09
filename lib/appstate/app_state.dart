//change notifier class
import 'package:course_correct/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  bool animationcomplete = false;

  //variable to store the current user 
  dynamic user;
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

  Future<void> iniialization()async{
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
}