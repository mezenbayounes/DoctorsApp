import 'package:doctor_app/screens/List_All_Shifts/GetAllShifts_module.dart';
import 'package:doctor_app/screens/List_All_Shifts/GetAllShifts_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ShiftListScreen extends StatefulWidget {
  const ShiftListScreen({Key? key}) : super(key: key);

  @override
  _ShiftListScreenState createState() => _ShiftListScreenState();
}

class _ShiftListScreenState extends State<ShiftListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final shiftProvider = Provider.of<ShiftProvider>(context, listen: false);
    shiftProvider.fetchAllShifts();

    // Add listener to detect scrolling
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // Automatically refresh when scrolled to the bottom
        shiftProvider.fetchAllShifts();
      }
    });
  }

  Future<void> _refreshShifts() async {
    final shiftProvider = Provider.of<ShiftProvider>(context, listen: false);
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
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 1, 112, 19),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background image with opacity
          Opacity(
            opacity: 0.6,
            child: Image.asset(
              'assets/bg.jpeg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: shiftProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : shiftProvider.shifts.isEmpty
                    ? const Center(
                        child: Text(
                          'No shifts available',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _refreshShifts,
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: shiftProvider.shifts.length,
                          itemBuilder: (context, index) {
                            final shift = shiftProvider.shifts[index];
                            return Dismissible(
                              key: Key(shift.id),
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) async {
                                bool? confirmDelete =
                                    await _showDeleteConfirmationDialog(
                                        context);
                                if (confirmDelete ?? false) {
                                  await shiftProvider.deleteShift(shift.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            '${shift.userName}\'s shift deleted')),
                                  );
                                } else {
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
                              child: ShiftCard(shift: shift),
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
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
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
    return DateFormat('yyyy-MM-dd').format(dateTime);
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
              'Shift Day: ${formatDate(shift.day)}',
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
