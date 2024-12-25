import 'package:doctor_app/services/auth_service.dart';
import 'package:doctor_app/widgets/CustomElevatedButton.dart';
import 'package:doctor_app/widgets/CustomTextFormField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'signup_provider.dart';
import '../../routes/app_routes.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final signupProvider = context.watch<SignupProvider>();

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true, // Adjust layout when keyboard appears
        body: Stack(
          children: [
            // Background Image with Opacity
            Positioned.fill(
              child: Image.asset(
                'assets/bg.jpeg', // Background image from assets
                fit: BoxFit.cover,
              ),
            ),

            // Main content
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/register.png', // Path to your image in the assets folder
                          width: 300.0, // Specify width
                          height: 320.0, // Specify height
                        ),
                      ),

                      // Title Text for Signup Screen
                      Text(
                        'Create an Account',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Full Name input field
                      CustomTextFormField(
                        hintText: 'Full Name',
                        onChanged: signupProvider.setUsername,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Full Name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),

                      // Email input field
                      CustomTextFormField(
                        hintText: 'Email',
                        onChanged: signupProvider.setEmail,
                        textInputType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),

                      // Password input field
                      CustomTextFormField(
                        hintText: 'Password',
                        obscureText: true,
                        onChanged: signupProvider.setPassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),

                      // Role dropdown input field
                      DropdownButtonFormField<String>(
                        value: signupProvider.signupModel.role.isEmpty
                            ? null
                            : signupProvider.signupModel.role,
                        onChanged: (String? newValue) {
                          signupProvider.setRole(newValue ?? '');
                        },
                        decoration: const InputDecoration(
                          labelText: 'Role',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                              value: 'senior', child: Text('Senior')),
                          DropdownMenuItem(
                              value: 'resident', child: Text('Resident')),
                          DropdownMenuItem(
                              value: 'intern', child: Text('Intern')),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a role';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Sign Up Button
                      signupProvider.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : CustomElevatedButton(
                              label: 'Sign Up',
                              onPressed: signupProvider.isLoading
                                  ? null
                                  : () async {
                                      signupProvider.setIsLoading(true);

                                      try {
                                        // Try to sign up the user with the email and password
                                        var signupUser = await AuthService()
                                            .signUpWithEmailPassword(
                                          email:
                                              signupProvider.signupModel.email,
                                          password: signupProvider
                                              .signupModel.password,
                                          context: context,
                                        );

                                        if (signupUser != null) {
                                          // After sign-up, immediately sign in the user
                                          var user = await AuthService()
                                              .signInWithEmailPassword(
                                            email: signupProvider
                                                .signupModel.email,
                                            password: signupProvider
                                                .signupModel.password,
                                            context: context,
                                          );

                                          // If sign-in is successful, call backend API and navigate
                                          if (user != null) {
                                            // Save user in your backend
                                            await signupProvider.signup();

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'Signup and login successful! Please log in.'),
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                backgroundColor: Colors.green,
                                              ),
                                            );

                                            Navigator.pushReplacementNamed(
                                                context, AppRoutes.login);
                                          }
                                        }
                                      } on FirebaseAuthException catch (e) {
                                        // Handle specific FirebaseAuthException errors
                                        if (e.code == 'email-already-in-use') {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'This email is already in use. Please try another one.'),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        } else if (e.code == 'weak-password') {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'The password is too weak. Please use a stronger one.'),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'An error occurred: ${e.message}'),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      } catch (error) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'An unexpected error occurred: $error'),
                                            behavior: SnackBarBehavior.floating,
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      } finally {
                                        signupProvider.setIsLoading(false);
                                      }
                                    },
                            ),

                      const SizedBox(height: 50),

                      // Login link
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.login);
                        },
                        child: const Text(
                          'Already have an account? Log in',
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
