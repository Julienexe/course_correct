import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset('assets/animations/course correct.json'),
      ),
    );
  }
}