import 'package:doctor_app/constant/constant.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ShiftAssignmentModel {
  String userId;
  DateTime date;

  ShiftAssignmentModel({
    required this.userId,
    required this.date,
  });
}

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

class ShiftAssignmentProvider with ChangeNotifier {
  final ShiftAssignmentModel _shiftAssignmentModel = ShiftAssignmentModel(
    userId: '',
    date: DateTime.now(),
  );

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  ShiftAssignmentModel get shiftAssignmentModel => _shiftAssignmentModel;

  // Add a list of doctors to store fetched data
  List<ProfileModel> _doctors = [];
  List<ProfileModel> get doctors => _doctors;

  void setUserId(String value) {
    _shiftAssignmentModel.userId = value;
    notifyListeners();
  }

  void setDate(DateTime value) {
    _shiftAssignmentModel.date = value;
    notifyListeners();
  }

  void setIsLoading(bool value) {
  _isLoading = value;
  // Ensure the UI doesn't update during the build phase.
  Future.delayed(Duration.zero, () {
    notifyListeners();
  });
}


  Future<bool> assignShift() async {
    setIsLoading(true);
    try {
      final Uri url = Uri.parse('$baseUrl/create_shift');
      final Map<String, dynamic> requestBody = {
        'userId': _shiftAssignmentModel.userId,
        'day': _shiftAssignmentModel.date.toIso8601String(),
      };

      print('Request Body: ${json.encode(requestBody)}');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      print('Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 201) {
        // Shift successfully assigned
        return true;
      } else if (response.statusCode == 400) {
        // Log backend error for debugging
        print('Error 400: ${response.body}');
        return false;
      } else {
        throw Exception(
            'Unexpected error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error assigning shift: $e');
      throw Exception('Error assigning shift: $e');
    } finally {
      setIsLoading(false);
    }
  }

  // Fetch all doctors and update the state
  Future<void> fetchAllDoctors() async {
    setIsLoading(true);

    try {
      final Uri url = Uri.parse('$baseUrl/get_doctors'); // Corrected URL
      final response = await http.get(url, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _doctors = ProfileModel.fromJsonList(data); // Update the list of doctors
        notifyListeners(); // Notify UI to update with new data
      } else {
        throw Exception(
            'Failed to fetch users. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching doctors: $e');
      throw Exception('An error occurred while fetching doctors: $e');
    } finally {
      setIsLoading(false);
    }
  }
}
