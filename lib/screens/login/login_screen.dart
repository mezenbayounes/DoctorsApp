import 'package:doctor_app/screens/home/home_screen_doctor.dart';
import 'package:doctor_app/screens/login/login_model.dart';
import 'package:doctor_app/services/auth_service.dart';
import 'package:doctor_app/widgets/CustomElevatedButton.dart';
import 'package:doctor_app/widgets/CustomImageView.dart';
import 'package:doctor_app/widgets/CustomTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home/home_screen.dart';
import 'login_provider.dart';
import '../../routes/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // GlobalKey to manage form state

  @override
  Widget build(BuildContext context) {
    final loginProvider = context.watch<LoginProvider>();

    return WillPopScope(
      onWillPop: () async {
        // Prevent back navigation when logged in
        return !loginProvider.isAuthenticated;
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              // Background Image with opacity
              Opacity(
                opacity: 0.6, // Adjust opacity as needed
                child: Image.asset(
                  'assets/bg.jpeg', // Path to your background image
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              // Main content
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 120),
                        const Center(
                          child: CustomImageView(
                            assetPath:
                                'assets/logo.png', // Pass asset path directly
                            width: 200.0,
                            height: 200.0,
                            borderRadius: 20.0,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Welcome Back!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Email input field
                        CustomTextFormField(
                          hintText: 'Email',
                          onChanged: loginProvider.setEmail,
                          textInputType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value)) {
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
                          onChanged: loginProvider.setPassword,
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
                        const SizedBox(height: 20),

                        // Login Button
                        loginProvider.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : CustomElevatedButton(
                                label: 'Login',
                                onPressed: () async {
                                  print(loginProvider
                                      .email); // Access directly from provider
                                  print(loginProvider
                                      .password); // Access directly from provider

                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    // Call the signIn function from AuthService
                                    var user = await AuthService()
                                        .signInWithEmailPassword(
                                            email: loginProvider
                                                .email, // Use email from provider
                                            password: loginProvider.password,
                                            context: context);

                                    // Check if login was successful
                                    if (user != null) {
                                      // If the user is authenticated, set isAuthenticated to true in the provider
                                      loginProvider.setAuthenticated(true);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text('Login Successful'),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                      final id =
                                          await loginProvider.getUserIdByEmail(
                                              loginProvider.email);
                                      print("id of user $id");
                                      final roleResponse = await loginProvider
                                          .getUserRoleByEmail(
                                              loginProvider.email);

// Assuming the response is a Map with the 'role' key
                                      final role = roleResponse['role'];

                                      print("role of user $role");
                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      await prefs.setString(
                                          'user_id', id.toString());
                                      String? userId =
                                          prefs.getString('user_id');
                                      print("stored user ID: $userId");
                                      // Navigate to the home screen and remove the login screen from the stack
                                      if (role == "manager") {
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const HomeScreen(), // Navigate to HomeScreen for managers
                                          ),
                                          (Route<dynamic> route) =>
                                              false, // This removes all previous routes
                                        );
                                      } else {
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const HomeScreenDoctor(), // Navigate to HomeScreenDoctor for doctors
                                          ),
                                          (Route<dynamic> route) =>
                                              false, // This removes all previous routes
                                        );
                                      }
                                    } else {
                                      // If login failed, show a failure message
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text('Login Failed'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                },
                                primaryColor: Colors.green[500],
                                onPrimaryColor: Colors.white,
                              ),
                        const SizedBox(height: 20),

                        // Sign up link
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.signup);
                          },
                          child: const Text(
                            'Don’t have an account? Sign up',
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
      ),
    );
  }
}
