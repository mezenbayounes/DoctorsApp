import 'dart:convert';

import 'package:doctor_app/widgets/CustomImageView.dart';
import 'package:doctor_app/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);

    try {
      // Retrieve the user_id from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final userIdJson = prefs.getString('user_id');

      if (userIdJson != null) {
        // Decode the JSON string if it's stored as JSON
        final Map<String, dynamic> userIdMap = json.decode(userIdJson);
        final userId = userIdMap['userId'];

        if (userId != null) {
          print('Extracted User ID: $userId');
          // Fetch the profile using the extracted userId
          await profileProvider.fetchUserProfile(userId);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Invalid User ID in SharedPreferences')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('User ID not found in SharedPreferences')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);

    if (profileProvider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final profile = profileProvider.profile;

    return Scaffold(
      body: Stack(
        children: [
          // Background image with opacity
          Opacity(
            opacity: 0.6,
            child: Image.asset(
              'assets/bg.jpeg', // Replace with the path to your background image
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          // Centered profile container
          SingleChildScrollView(
            child: Center(
              child: profile == null
                  ? const Text(
                      'No Profile Data',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                      ),
                    )
                  : Column(
                      children: [
                        // Custom ImageView before the profile container
                        SizedBox(height: 60),
                        Image.asset(
                          'assets/profile.png', // Path to your image in the assets folder
                          width: 300.0, // Specify width
                          height: 320.0, // Specify height
                        ),
                        // Adjust space between image and profile info
                        // Profile container
                        Container(
                          width: MediaQuery.of(context).size.width *
                              0.9, // Adjust width
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                spreadRadius: 5,
                                blurRadius: 10,
                                offset: const Offset(0, 5), // Shadow position
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.person,
                                      size: 50, color: Colors.green),
                                  const SizedBox(width: 15),
                                  Text(
                                    profile.name,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Roboto',
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(thickness: 1, color: Colors.grey),
                              const SizedBox(height: 15),
                              ProfileInfoRow(
                                icon: Icons.email,
                                title: "Email",
                                value: profile.email,
                              ),
                              const SizedBox(height: 15),
                              ProfileInfoRow(
                                icon: Icons.work,
                                title: "Role",
                                value: profile.role,
                              ),
                              const SizedBox(height: 15),
                              ProfileInfoRow(
                                icon: Icons.verified,
                                title: "Validated",
                                value: profile.isValidated ? "Yes" : "No",
                              ),
                            ],
                          ),
                        ),
                        // Buttons below the profile container
                        const SizedBox(height: 60),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Update Button (Gray)
                            ElevatedButton(
                              onPressed: () {
                                // Handle update action here
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey, // Gray color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 10),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize
                                    .min, // Adjusts the button size to fit content
                                children: [
                                  Icon(
                                    Icons.update, // Use an appropriate icon
                                    color: Colors.white, // Icon color
                                    size: 24, // Icon size
                                  ),
                                  const SizedBox(
                                      width:
                                          10), // Add spacing between icon and text
                                  const Text(
                                    'Update Profile',
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Save Button (Green)
                          ],
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileInfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const ProfileInfoRow({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 28, color: Colors.green),
        const SizedBox(width: 15),
        Expanded(
          flex: 2, // This makes the title take more space
          child: Text(
            '$title ',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 75, 70, 70),
              fontFamily: 'Roboto',
            ),
          ),
        ),
        Expanded(
          flex: 3, // This makes the value take up more space
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.normal,
              color: Colors.black87,
              fontFamily: 'Roboto',
            ),
          ),
        ),
      ],
    );
  }
}
