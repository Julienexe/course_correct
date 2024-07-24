import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_correct/main.dart';
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
  late final TextEditingController _name; 

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _name = TextEditingController(); 

    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _name.dispose(); 
    super.dispose();
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(15),
          height: double.infinity,
          decoration: const BoxDecoration(color: Colors.white),
          child: ListView(
            shrinkWrap: true,
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(height: 150),
                    const Text(
                      'Course Correct',
                      style: TextStyle(
                        fontSize: 25,
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontFamily: 'Arial',
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Image.asset(
                      'assets/icons/campus_connect_logo.png',
                      height: 100,
                      width: 100,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _name,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  labelStyle: defaultTextStyle,
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 5.0),
                  ),
                ),
              ),
              const SizedBox(height: 10),
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
              const SizedBox(height: 10),
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
              const SizedBox(height: 10),
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
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                  final name = _name.text;
                  //create user exception handling coming in later

                 appState.registerSequence(email, password, name, context);
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                      Color.fromARGB(255, 0, 0, 0)),
                
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
      ),
    );
  }
}
