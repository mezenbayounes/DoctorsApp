import 'package:doctor_app/screens/List_All_Shifts/GetAllShifts_module.dart';
import 'package:doctor_app/screens/List_All_Shifts/GetAllShifts_provider.dart';
import 'package:doctor_app/screens/List_All_Shifts/GetAllShifts_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doctor_app/constant/constant.dart'; // Import for baseUrl or necessary constants
import 'package:intl/intl.dart';

class ShiftListScreenDoctor extends StatefulWidget {
  const ShiftListScreenDoctor({Key? key}) : super(key: key);

  @override
  _ShiftListScreenState createState() => _ShiftListScreenState();
}

class _ShiftListScreenState extends State<ShiftListScreenDoctor> {
  @override
  void initState() {
    super.initState();
    // Fetch all shifts when the screen is loaded
    final shiftProvider = Provider.of<ShiftProvider>(context, listen: false);
    shiftProvider.fetchShiftsByUserId();
  }

  Future<void> _refreshShifts() async {
    final shiftProvider = Provider.of<ShiftProvider>(context, listen: false);
    // Call the fetch method again to refresh the shifts
    await shiftProvider.fetchShiftsByUserId();
  }

  @override
  Widget build(BuildContext context) {
    final shiftProvider = Provider.of<ShiftProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Shift List",
          style: TextStyle(
            fontSize: 40,
            fontFamily: 'Roboto', // Use your custom font
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 1, 112, 19),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background image with opacity
          Opacity(
            opacity: 0.6, // Adjust opacity as needed
            child: Image.asset(
              'assets/bg.jpeg', // Path to your background image
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: shiftProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _refreshShifts, // Refresh function when pulled
                    child: shiftProvider.shifts.isEmpty
                        ? Center(
                            child: Text(
                              'No shifts available.',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: shiftProvider.shifts.length,
                            itemBuilder: (context, index) {
                              final shift = shiftProvider.shifts[index];
                              return ShiftCard(
                                      shift: shift) // Your ShiftCard widget
                                  ;
                            },
                          ),
                  ),
          ),
        ],
      ),
    );
  }
}