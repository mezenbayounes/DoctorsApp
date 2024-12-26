import 'package:doctor_app/screens/List_All_Shifts/GetAllShifts_module.dart';
import 'package:doctor_app/screens/List_All_Shifts/GetAllShifts_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doctor_app/constant/constant.dart'; // Import for baseUrl or necessary constants
import 'package:intl/intl.dart';

class ShiftListScreen extends StatefulWidget {
  const ShiftListScreen({Key? key}) : super(key: key);

  @override
  _ShiftListScreenState createState() => _ShiftListScreenState();
}

class _ShiftListScreenState extends State<ShiftListScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch all shifts when the screen is loaded
    final shiftProvider = Provider.of<ShiftProvider>(context, listen: false);
    shiftProvider.fetchAllShifts();
  }

  Future<void> _refreshShifts() async {
    final shiftProvider = Provider.of<ShiftProvider>(context, listen: false);
    // Call the fetch method again to refresh the shifts
    await shiftProvider.fetchAllShifts();
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
                    child: ListView.builder(
                      itemCount: shiftProvider.shifts.length,
                      itemBuilder: (context, index) {
                        final shift = shiftProvider.shifts[index];
                        return Dismissible(
                          key: Key(shift.id), // Use the shift ID as the key
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) async {
                            // Show confirmation dialog
                            bool? confirmDelete =
                                await _showDeleteConfirmationDialog(context);
                            if (confirmDelete ?? false) {
                              // Proceed with deletion if confirmed
                              await shiftProvider.deleteShift(shift.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        '${shift.userName}\'s shift deleted')),
                              );
                            } else {
                              // Rebuild the widget if the user cancels deletion
                              shiftProvider.fetchAllShifts();
                            }
                          },
                          background: Container(
                            color: Colors.red,
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          child:
                              ShiftCard(shift: shift), // Your ShiftCard widget
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showDeleteConfirmationDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this shift?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancel
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirm
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

class ShiftCard extends StatelessWidget {
  final ShiftModel shift;

  const ShiftCard({Key? key, required this.shift}) : super(key: key);

  String formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    return DateFormat('yyyy-MM-dd').format(dateTime); // Format the date
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person, color: Colors.black54),
                const SizedBox(width: 8),
                Text(
                  'Doctor Name: ${shift.userName}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Shift Day: ${formatDate(shift.day)}', // Formatted date
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black38,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
