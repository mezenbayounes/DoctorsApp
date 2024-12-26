import 'package:doctor_app/screens/Shift_Assignment/Shift_Assignment_screen.dart';
import 'package:doctor_app/screens/validation/validation_screen.dart';
import 'package:flutter/material.dart';
import '../screens/home/home_screen.dart';
import '../screens/login/login_screen.dart';
import '../screens/signup/signup_screen.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/profile/profile_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String profile = '/profile';
  static const String usersList = '/usersList';
  static const String shiftAssignmentScreen = '/shiftAssignmentScreen';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case signup:
        return MaterialPageRoute(builder: (_) => SignupScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => ProfileScreen());
      case usersList:
        return MaterialPageRoute(builder: (_) => UserListScreen());
      case shiftAssignmentScreen:
        return MaterialPageRoute(builder: (_) => ShiftAssignmentScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
