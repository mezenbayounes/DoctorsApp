import 'package:doctor_app/firebase_options.dart';
import 'package:doctor_app/routes/app_routes.dart';
import 'package:doctor_app/screens/Shift_Assignment/Shift_Assignment_provider.dart';
import 'package:doctor_app/screens/home/home_provider.dart';
import 'package:doctor_app/screens/login/login_provider.dart';
import 'package:doctor_app/screens/profile/profile_provider.dart';
import 'package:doctor_app/screens/signup/signup_provider.dart';
import 'package:doctor_app/screens/validation/validation_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const DoctorsApp());
}

class DoctorsApp extends StatelessWidget {
  const DoctorsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => SignupProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (context) => ValidationProvider()),
        ChangeNotifierProvider(create: (_) => ShiftAssignmentProvider()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Doctors App',
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}
