import 'package:course_correct/main.dart';
import 'package:course_correct/pages/landing_page.dart';
import 'package:course_correct/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

var _scaffoldKey = GlobalKey<ScaffoldState>();
class TestPage extends StatefulWidget {
  const TestPage({super.key});
  
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () async {
      await appState.initialization();
      //check if user exists
      if (appState.user != null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) =>  LandingPage()));
      }
       else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginPage()));
      }
      appState.animationcomplete = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Lottie.asset('assets/animations/course correct.json'),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "COURSE CORRECT",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Schyler',
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }
}
