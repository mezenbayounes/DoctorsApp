import 'dart:async';
import 'package:doctor_app/screens/List_All_Shifts/GetAllShifts_screen.dart';
import 'package:doctor_app/screens/Shift_Assignment/Shift_Assignment_screen.dart';
import 'package:doctor_app/screens/validation/validation_screen.dart';
import 'package:doctor_app/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:doctor_app/screens/profile/profile_screen.dart';
import 'package:doctor_app/widgets/bottom_nav_bar.dart';
import 'package:simple_drawer/simple_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const ShiftAssignmentScreen(), // Home screen
    UserListScreen(), // Search screen
    const ShiftListScreen(), // Profile screen
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
        color: Colors.green,
        height: MediaQuery.of(context).size.height,
        width: 200,
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
          padding: EdgeInsets.only(left: 180),
          child: Text("Doctors App"),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            SimpleDrawer.activate("leftDrawer");
          },
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTabSelected: _onTabSelected,
        context: context, // Pass context for navigation
      ),
    );
  }
}
