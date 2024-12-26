import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:doctor_app/constant/constant.dart';
import 'package:doctor_app/screens/List_All_Shifts/GetAllShifts_module.dart';

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
    final Uri url = Uri.parse('$baseUrl/GetAllShifts'); // Make sure this URL is correct
    final response = await http.post(url, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      _shifts = ShiftModel.fromJsonList(data); // Parse the list of shifts
    } else {
      throw Exception('Failed to fetch shifts. Status code: ${response.statusCode}. Response: ${response.body}');
    }
  } catch (e) {
    throw Exception('An error occurred while fetching shifts: $e');
  } finally {
    setIsLoading(false);
  }
}
Future<void> deleteShift(String shiftId) async {
    try {
      final Uri url = Uri.parse('$baseUrl/DeleteShift'); // Replace with your API URL
      final response = await http.delete(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'shiftId': shiftId}), // Send the shiftId in the request body
      );

      if (response.statusCode == 200) {
        // Remove the deleted shift from the list
        _shifts.removeWhere((shift) => shift.id == shiftId);
        notifyListeners(); // Notify listeners that the shift list has been updated
      } else {
        throw Exception('Failed to delete shift. Status code: ${response.statusCode}. Response: ${response.body}');
      }
    } catch (e) {
      throw Exception('An error occurred while deleting the shift: $e');
    } 
  }



}
