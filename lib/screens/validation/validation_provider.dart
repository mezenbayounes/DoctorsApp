import 'dart:convert';
import 'package:doctor_app/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfileModel {
  String id;
  String name;
  String email;
  String role;
  bool isValidated;

  ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.isValidated,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      isValidated: json['isValidated'],
    );
  }

  static List<ProfileModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((item) => ProfileModel.fromJson(item)).toList();
  }
}

class ValidationProvider with ChangeNotifier {
  List<ProfileModel> _profiles = [];
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  List<ProfileModel> get profiles => _profiles;

  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> fetchAllUsers() async {
    setIsLoading(true);
    try {
      final Uri url =
          Uri.parse('$baseUrl/GetAllUsers'); // Changed URL to GetAllUsers
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _profiles = ProfileModel.fromJsonList(data); // Parse the list of users
      } else {
        throw Exception(
            'Failed to fetch users. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('An error occurred while fetching users: $e');
    } finally {
      setIsLoading(false);
    }
  }

  Future<bool> validate(String email) async {
    try {
      final Uri url = Uri.parse('$baseUrl/validate-account');
      final Map<String, dynamic> requestBody = {
        'email': email,
      };

      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        return true; // User successfully validated
      } else if (response.statusCode == 400) {
        return false; // User already exists or validation failed
      } else {
        throw Exception('Backend error: ${response.body}');
      }
    } catch (e) {
      throw Exception('Backend error: $e');
    }
  }
}
