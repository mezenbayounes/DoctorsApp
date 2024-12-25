import 'package:doctor_app/screens/login/login_screen.dart';
import 'package:doctor_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Home')),
        actions: [
          // Add a logout button to the AppBar
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              await _logout(context); // Call the logout method
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              homeProvider.welcomeMessage,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            // You can also add a button for logout here
            ElevatedButton(
              onPressed: () async {
                await _logout(context);
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }

  // Method to handle logout using AuthService
  Future<void> _logout(BuildContext context) async {
    try {
      // Call signOut method from AuthService
      await AuthService().signOut();

      // After logout, clear any cached authentication state (optional)
      await AuthService().clearAuthCache();

      // Navigate to the login screen after logout
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const LoginScreen()), // Replace with your login screen
      );
    } catch (e) {
      // Handle any errors that occur during logout
      print('Error logging out: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error logging out. Please try again.')),
      );
    }
  }
}
