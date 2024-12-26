import 'dart:async';
import 'package:doctor_app/screens/List_All_Shifts/GetAllShifts_screen.dart';
import 'package:doctor_app/screens/List_All_Shifts/GetAllShifts_screen_doctor.dart';
import 'package:doctor_app/screens/Shift_Assignment/Shift_Assignment_screen.dart';
import 'package:doctor_app/screens/validation/validation_screen.dart';
import 'package:doctor_app/services/auth_service.dart';
import 'package:doctor_app/widgets/bottom_nav_bar_doctor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:doctor_app/screens/profile/profile_screen.dart';
import 'package:doctor_app/widgets/bottom_nav_bar.dart';
import 'package:simple_drawer/simple_drawer.dart';

class HomeScreenDoctor extends StatefulWidget {
  const HomeScreenDoctor({super.key});

  @override
  _HomeScreenStateHomeScreenDoctor createState() =>
      _HomeScreenStateHomeScreenDoctor();
}

class _HomeScreenStateHomeScreenDoctor extends State<HomeScreenDoctor> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    ShiftListScreenDoctor(), // Search screen
    const ProfileScreen(), // Profile screen
  ];

  void _onTabSelected(int index) {
    if (index == _currentIndex) return; // Prevent redundant navigation

    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget leftDrawer = SimpleDrawer(
      childWidth: 200,
      direction: Direction.left,
      id: "leftDrawer",
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: 200,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.green, // Start color
              Colors.white, // End color
            ],
            begin: Alignment.topCenter, // Start from the top
            end: Alignment.bottomCenter, // End at the bottom
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // User profile section
              ListTile(
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          AssetImage('assets/logo.png'), // Path to your image
                      radius: 40, // Adjust the size of the circle
                    ),
                    SizedBox(height: 8), // Space between the image and the name
                    Text(
                      'DoctorsApp', // Replace with actual user name
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                onTap: () {
                  // Do something when tapped (Optional, you can leave it empty or add an action)
                },
              ),

              // Logout button
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () async {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Logging out...')),
                  );
                  await AuthService().signOut(context);
                },
              ),
            ],
          ),
        ),
      ),
    );

    return Scaffold(
      body: Stack(
        children: [
          _pages[_currentIndex], // Display the selected page
          leftDrawer,
        ],
      ),
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 154),
          child: Text("Doctors App"),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            SimpleDrawer.activate("leftDrawer");
          },
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              // Handle menu item selection
              if (value == 'Profile') {
                setState(() {
                  _currentIndex = 1; // Navigate to ProfileScreen
                });
              } else if (value == 'LogOut') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logging out...')),
                );
                await AuthService().signOut(context);
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'Profile',
                child: ListTile(
                  leading: Icon(Icons.person_4),
                  title: Text('Profile'),
                ),
              ),
              const PopupMenuItem(
                value: 'LogOut',
                child: ListTile(
                  leading: Icon(Icons.logout_rounded),
                  title: Text('LogOut'),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBarDoctor(
        currentIndex: _currentIndex,
        onTabSelected: _onTabSelected,
        context: context, // Pass context for navigation
      ),
    );
  }
}
