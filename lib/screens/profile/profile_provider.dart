import 'package:doctor_app/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
}

class ProfileProvider with ChangeNotifier {
  ProfileModel? _profile;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  ProfileModel? get profile => _profile;

  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> fetchUserProfile(String userId) async {
    setIsLoading(true);
    try {
      final Uri url = Uri.parse('$baseUrl/GetUserById');
      final Map<String, dynamic> requestBody = {
        'id': userId,
      };

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        _profile = ProfileModel.fromJson(data);
      } else {
        throw Exception(
            'Failed to fetch user profile. Status code: ${response.body}');
      }
    } catch (e) {
      throw Exception('An error occurred while fetching the user profile: $e');
    } finally {
      setIsLoading(false);
    }
  }

  void clearProfile() {
    _profile = null;
    notifyListeners();
  }
}
