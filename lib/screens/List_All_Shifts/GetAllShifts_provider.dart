import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:doctor_app/constant/constant.dart';
import 'package:doctor_app/screens/List_All_Shifts/GetAllShifts_module.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShiftProvider with ChangeNotifier {
  List<ShiftModel> _shifts = [];
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  List<ShiftModel> get shifts => _shifts;

  void setIsLoading(bool value) {
    // Delay the state change until after the build phase is completed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isLoading = value;
      notifyListeners();
    });
  }

  Future<void> fetchAllShifts() async {
    setIsLoading(true);
    try {
      final Uri url =
          Uri.parse('$baseUrl/GetAllShifts'); // Make sure this URL is correct
      final response =
          await http.post(url, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _shifts = ShiftModel.fromJsonList(data); // Parse the list of shifts
      } else {
        throw Exception(
            'Failed to fetch shifts. Status code: ${response.statusCode}. Response: ${response.body}');
      }
    } catch (e) {
      throw Exception('An error occurred while fetching shifts: $e');
    } finally {
      setIsLoading(false);
    }
  }

  Future<void> fetchShiftsByUserId() async {
  setIsLoading(true);

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? userIdString = prefs.getString('user_id');

  if (userIdString == null) {
    throw Exception('User ID not found in shared preferences');
  }

  // Assuming userIdString is a JSON encoded string, decode it if necessary
  final Map<String, dynamic> userIdMap = json.decode(userIdString);
  final String userId = userIdMap['userId'] ?? userIdString; // Extract userId if it's nested

  final Uri url = Uri.parse('$baseUrl/getShiftsByUserId');
  final Map<String, dynamic> requestBody = {
    'userId': userId, // Correctly assign the userId extracted
  };
  print(userId);
  print("Request body: ${json.encode(requestBody)}");

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      // Check if 'shifts' exists and is not null
      final List<dynamic> shiftsData = data['shifts'] ?? [];
      
      if (shiftsData.isEmpty) {
        print('No shifts found');
        _shifts = []; // Handle empty shift list
      } else {
        // Parse shifts into a List<ShiftModel>
        _shifts = ShiftModel.fromJsonList(shiftsData);
      }
    } else if (response.statusCode == 404) {
      // Handle 404 error explicitly
      print('No shifts found for this user');
      _shifts = []; // Optionally handle empty shift list when 404
    } else {
      throw Exception(
          'Failed to fetch shifts. Status code: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('An error occurred while fetching shifts: $e');
  } finally {
    setIsLoading(false);
  }
}


  Future<void> deleteShift(String shiftId) async {
    try {
      final Uri url =
          Uri.parse('$baseUrl/DeleteShift'); // Replace with your API URL
      final response = await http.delete(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
            {'shiftId': shiftId}), // Send the shiftId in the request body
      );

      if (response.statusCode == 200) {
        // Remove the deleted shift from the list
        _shifts.removeWhere((shift) => shift.id == shiftId);
        notifyListeners(); // Notify listeners that the shift list has been updated
      } else {
        throw Exception(
            'Failed to delete shift. Status code: ${response.statusCode}. Response: ${response.body}');
      }
    } catch (e) {
      throw Exception('An error occurred while deleting the shift: $e');
    }
  }
}
