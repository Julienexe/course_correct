// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:course_correct/main.dart';
import 'package:course_correct/pages/initial_selection_page.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Course ",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            Text(
              "Correct ",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.black87,
        elevation: 50,
        iconTheme: IconThemeData(color: Colors.lightBlueAccent),
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.grey[100],
          child: Column(
            children: [
              DrawerHeader(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    iconColor: Colors.blueAccent, // background color
                    backgroundColor: Colors.white, // foreground color
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/profilepage');
                  },
                  child: Icon(
                    Icons.person,
                    size: 45,
                  ),
                ),
              ),
              // Categories with Dropdown
              
              ListTile(
                leading: Icon(Icons.settings),
                title: Text("Settings"),
                onTap: () {
                  Navigator.pop(context);
                  // go to settings page
                  Navigator.pushNamed(context, '/settingspage');
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text("Logout"),
                onTap: () {
                  //log user out
                 appState.logoutUser(context);
                },
              ),
            ],
          ),
        ),
      ),
      
      body: RoleSelectionPage(),
    );
  }
}
