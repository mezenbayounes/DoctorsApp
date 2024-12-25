import 'package:doctor_app/constant/constant.dart';
import 'package:doctor_app/routes/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'signup_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupProvider with ChangeNotifier {
  final SignupModel _signupModel = SignupModel(
    username: '',
    role: '',
    email: '',
    password: '',
  );

  bool _isLoading = false;

  bool get isLoading => _isLoading;
  SignupModel get signupModel => _signupModel;

  void setUsername(String value) {
    _signupModel.username = value;
    notifyListeners();
  }

  void setRole(String value) {
    _signupModel.role = value;
    notifyListeners();
  }

  void setEmail(String value) {
    _signupModel.email = value;
    notifyListeners();
  }

  void setPassword(String value) {
    _signupModel.password = value;
    notifyListeners();
  }

  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
Future<bool> signup() async {
  setIsLoading(true);

  try {
    final Uri url = Uri.parse('$baseUrl/signup');
    final Map<String, dynamic> requestBody = {
      'name': _signupModel.username,
      'email': _signupModel.email,
      'role': _signupModel.role,
      'password': _signupModel.password,
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(requestBody),
    );

    if (response.statusCode == 201) {
      // User successfully created in the backend
      return true;
    } else if (response.statusCode == 400) {
      // Handle "User already exists" error
      return false;
    } else {
      throw Exception('Backend error: ${response.body}');
    }
  } catch (e) {
    throw Exception('Backend error: $e');
  } finally {
    setIsLoading(false);
  }
}


}
