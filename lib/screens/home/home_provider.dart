import 'package:flutter/material.dart';

class HomeProvider with ChangeNotifier {
  final String _welcomeMessage = 'Welcome to the Doctors App!';

  String get welcomeMessage => _welcomeMessage;
}
