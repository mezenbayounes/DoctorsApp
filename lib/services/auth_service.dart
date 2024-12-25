import 'package:doctor_app/routes/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign up with email and password
  Future<User?> signUpWithEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
     
      return userCredential.user; // Return the user on successful signup
    } on FirebaseAuthException catch (e) {
      _handleAuthError(context, e); // Handle specific Firebase errors
      return null; // Return null on error
    } catch (e) {
      // Log unexpected errors
      print('Unexpected error during signup: $e');
      return null;
    }
  }

  // Sign in with email and password
  Future<User?> signInWithEmailPassword({
    required String email,
    required String password,
    required BuildContext context, // Added BuildContext
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // If sign-in is successful, print user details
      if (userCredential.user != null) {
        print('Login Successful');
        print('User Email: ${userCredential.user?.email}');
        print('User UID: ${userCredential.user?.uid}');
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_email', userCredential.user?.email ?? '');
        String? userEmail = prefs.getString('user_email');

        print('Stored Email: $userEmail');
      }
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      _handleAuthError(context, e); // Pass the FirebaseAuthException
      return null;
    } catch (e) {
      // Log unexpected errors for debugging
      print('Unexpected error during Firebase sign-in: $e');
      return null;
    }
  }

  // Handle FirebaseAuthException errors
  void _handleAuthError(BuildContext context, FirebaseAuthException e) {
    String message;
    switch (e.code) {
      case 'email-already-in-use':
        message = 'This email is already in use. Please try another one.';
        break;
      case 'weak-password':
        message = 'The password is too weak. Please use a stronger password.';
        break;
      case 'invalid-email':
        message = 'The email address is invalid.';
        break;
      case 'user-not-found':
        message = 'No user found for this email.';
        break;
      case 'wrong-password':
        message = 'The password is incorrect.';
        break;
      default:
        message = 'An error occurred. Please try again.';
    }

    // Display the SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  // Sign out (logout)
  Future<void> signOut(
    BuildContext context,
  ) async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, AppRoutes.login);

    print('User logged out');
  }

  // Clear auth cache (optional, in case you want to clear any cached auth data)
  Future<void> clearAuthCache() async {
    try {
      await _auth.signOut();

      print('Auth cache cleared');
    } catch (e) {
      print('Error clearing auth cache: $e');
    }
  }
}
