import 'package:course_correct/pages/login_page.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(15),
        height: double.infinity,
        decoration: const BoxDecoration(color: Colors.white),
        child: ListView(
          children: [
            const Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: 50,
                ),
                Text(
                  'Course Correct',
                  style: TextStyle(
                    fontSize: 25,
                    color: Color.fromARGB(255, 64, 120, 166),
                    fontFamily: 'Arial',
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  'Learn Anew',
                  style: TextStyle(
                    fontSize: 15,
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontFamily: 'Arial',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _email,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                labelStyle: defaultTextStyle,
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 5.0),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                  labelText: 'Password',
                  labelStyle: defaultTextStyle,
                  prefixIcon: Icon(Icons.password),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 5.0),
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
            const TextField(
              decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  labelStyle: defaultTextStyle,
                  prefixIcon: Icon(Icons.password),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 5.0),
                  )),
              obscureText: true,
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                //create user exception handling coming in later
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: email, password: password);
                Navigator.pushNamed(context, '/landingpage');
                // //print(userCredential);
                // //sending a verification email
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                    const Color.fromARGB(255, 64, 120, 166)),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              child: const Text(
                'Register',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Arial',
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have an account?'),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ));
                  },
                  child: const Text('Login'),
                ),
              ],
            ),
            const Center(
                child: Text(
              'By signing up to Course Correct, you agree to our terms and Privacy Policy',
              style: TextStyle(
                fontSize: 10,
              ),
            ))
          ],
        ),
      ),
    );
  }

  //function to show a pop up date picker
}
