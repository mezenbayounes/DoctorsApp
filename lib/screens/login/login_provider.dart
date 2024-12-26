import 'dart:convert';

import 'package:doctor_app/constant/constant.dart';
import 'package:doctor_app/screens/login/login_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginProvider with ChangeNotifier {
  final LoginModel _loginModel = LoginModel(
    email: '',
    password: '',
  );
  String _email = '';
  String _password = '';
  bool _isLoading = false;
  bool _isAuthenticated = false;
  String? _errorMessage;

  String get email => _email;
  String get password => _password;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String? get errorMessage => _errorMessage;

  // Update the email and password directly instead of _loginModel
  void setEmail(String email) {
    _email = email;
    notifyListeners(); // Notify listeners to trigger UI update
  }

  void setPassword(String password) {
    _password = password;
    notifyListeners(); // Notify listeners to trigger UI update
  }

  void setAuthenticated(bool value) {
    _isAuthenticated = value;
    notifyListeners(); // Notify listeners to update UI
  }

  Future<void> login() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
  }

  Future<Object> getUserIdByEmail(String email) async {
    final Uri url = Uri.parse('$baseUrl/GetIdByEmail');
    final Map<String, dynamic> requestBody = {
      'email':email,
    };
    print("Request body: ${json.encode(requestBody)}");
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        // Return the response body if successful
        return response.body;
      } else {
        // Handle error response, return a custom error message or throw
        throw Exception(
            'Failed to fetch user data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exception (e.g., network error)
      throw Exception('An error occurred: $e');
    }
  }

  Future<Map<String, dynamic>> getUserRoleByEmail(String email) async {
  final Uri url = Uri.parse('$baseUrl/getUserRoleByEmail');
  final Map<String, dynamic> requestBody = {
    'email': email,
  };
  print("Request body: ${json.encode(requestBody)}");

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      // Return the response body as a Map
      return json.decode(response.body);  // Return as Map<String, dynamic>
    } else {
      // Handle error response
      throw Exception(
          'Failed to fetch user data. Status code: ${response.statusCode}');
    }
  } catch (e) {
    // Handle any exception (e.g., network error)
    throw Exception('An error occurred: $e');
  }
}

}
