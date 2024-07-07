// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  LandingPage({super.key});

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _selectedIndex = 0;
  // String? _selectedCategory;

  // final List<Widget> _pages = [
  // homepage
  //   SecondPage(),

  //   //profile page
  //   ThirdPage(),

  //   //settings page
  //   SettingsPage(),
  // ];

  // void _navigateBottomBar(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

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
                leading: Icon(Icons.category),
                title: Row(
                  children: [
                    Expanded(child: Text("Courses")),
                    DropdownButton<String>(
                      // value: _selectedCategory,
                      onChanged: (String? newValue) {
                        setState(() {
                          // _selectedCategory = newValue;
                        });
                      },
                      items: <String>[
                        'Computer Science',
                        'Law',
                        'Engineering',
                        'Business',
                        'Languages',
                        'Economics',
                        'Architecture',
                        'Humanities'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
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
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black87,
        selectedItemColor: Colors.blueGrey,
        unselectedItemColor: Colors.lightBlueAccent,
        currentIndex: _selectedIndex,
        // onTap: _navigateBottomBar,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
      // body: _pages[_selectedIndex],
    );
  }
}
