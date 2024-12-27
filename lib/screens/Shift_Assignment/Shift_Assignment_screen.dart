import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doctor_app/screens/Shift_Assignment/Shift_Assignment_provider.dart';

class ShiftAssignmentScreen extends StatefulWidget {
  const ShiftAssignmentScreen({Key? key}) : super(key: key);

  @override
  _ShiftAssignmentScreenState createState() => _ShiftAssignmentScreenState();
}

class _ShiftAssignmentScreenState extends State<ShiftAssignmentScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch doctors when the screen is loaded
    final shiftProvider =
        Provider.of<ShiftAssignmentProvider>(context, listen: false);
    shiftProvider.fetchAllDoctors();
  }

  @override
  Widget build(BuildContext context) {
    final shiftProvider = Provider.of<ShiftAssignmentProvider>(context);

    return Scaffold(
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
          // Centered container with shadow effect for form elements

          Padding(
            padding: const EdgeInsets.only(top: 80, left: 60),
            child: Text(
              'Assign Shift',
              style: TextStyle(
                fontSize: 50,
                fontFamily: 'Roboto', // Use your custom font
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 1, 112, 19),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 100),
              child: SizedBox(
                width: 350,
                height: 350, // Set the width of the container
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white
                        .withOpacity(0.8), // Background color with some opacity
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10.0,
                        offset: const Offset(0, 4), // Shadow position
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Dropdown for Doctor Names
                      const Text(
                        'Select Doctor :',
                        style: TextStyle(
                          color: Color.fromARGB(255, 1, 112, 19), // Black color
                          fontSize: 18, // You can specify the font size
                          fontWeight:
                              FontWeight.bold, // Optional: Makes the text bold
                          fontFamily:
                              'Arial', // Optional: Specifies the font family
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Consumer<ShiftAssignmentProvider>(
                        builder: (context, shiftProvider, child) {
                          // Show loading indicator while fetching data
                          if (shiftProvider.isLoading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          // Show error message if no doctors are found (404 error)
                          if (shiftProvider.hasError) {
                            return Center(
                              child: Text(
                                'No doctors found',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }

                          // Show Dropdown if doctors are available
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 5.0,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: DropdownButton<String>(
                              value: shiftProvider
                                      .shiftAssignmentModel.userId.isEmpty
                                  ? null
                                  : shiftProvider.shiftAssignmentModel.userId,
                              isExpanded: true,
                              hint: const Text(
                                'Select Doctor',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0)),
                              ),
                              items: shiftProvider.doctors.map((doctor) {
                                return DropdownMenuItem<String>(
                                  value: doctor.id,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.person,
                                        color: Colors.green,
                                      ),
                                      const SizedBox(width: 8.0),
                                      Text(doctor.name),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (selectedUserId) {
                                if (selectedUserId != null) {
                                  shiftProvider.setUserId(selectedUserId);
                                }
                              },
                              dropdownColor: Colors.white,
                              elevation: 2,
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),

                      // Date Picker (TextField Style)
                      const Text(
                        'Select Date:',
                        style: TextStyle(
                          color: Color.fromARGB(255, 1, 112, 19), // Black color
                          fontSize: 18, // You can specify the font size
                          fontWeight:
                              FontWeight.bold, // Optional: Makes the text bold
                          fontFamily:
                              'Arial', // Optional: Specifies the font family
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () async {
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate:
                                shiftProvider.shiftAssignmentModel.date,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                            builder: (BuildContext context, Widget? child) {
                              // Customize the theme of the DatePicker
                              return Theme(
                                data: ThemeData.light().copyWith(
                                  primaryColor: Colors
                                      .green, // Set the primary color to green
                                  colorScheme:
                                      ColorScheme.light(primary: Colors.green),
                                  buttonTheme: ButtonThemeData(
                                      textTheme: ButtonTextTheme.primary),
                                ),
                                child:
                                    child!, // Return the child widget of DatePicker
                              );
                            },
                          );
                          if (pickedDate != null) {
                            shiftProvider.setDate(pickedDate);
                            // Debug log for date
                            print(
                                'Selected Date: ${pickedDate.toIso8601String()}');
                          }
                        },
                        child: AbsorbPointer(
                          child: TextField(
                            controller: TextEditingController(
                              text:
                                  "${shiftProvider.shiftAssignmentModel.date.toLocal()}"
                                      .split(' ')[0],
                            ),
                            decoration: InputDecoration(
                              hintText: 'Select Date',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 16.0),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 45),

                      // Stylish Text before Assign Button

                      // Assign Button
                      Center(
                          child: ElevatedButton(
                        onPressed: shiftProvider.isLoading
                            ? null
                            : () async {
                                // Debug log before assignment
                                print(
                                    'Submitting User ID: ${shiftProvider.shiftAssignmentModel.userId}, Date: ${shiftProvider.shiftAssignmentModel.date.toIso8601String()}');

                                final success =
                                    await shiftProvider.assignShift();
                                if (success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Shift assigned successfully'),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Failed to assign shift'),
                                    ),
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Color.fromARGB(255, 1, 112,
                              19), // Text color when button is pressed
                          shadowColor: Colors.black, // Shadow color
                          elevation:
                              8, // Amount of shadow (higher means bigger shadow)
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                8), // Optional: Rounded corners
                          ),
                        ),
                        child: shiftProvider.isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'Assign Shift',
                                style: TextStyle(
                                  color: Color.fromARGB(
                                      255, 255, 255, 255), // Black color
                                  fontSize: 18, // You can specify the font size
                                  fontWeight: FontWeight
                                      .bold, // Optional: Makes the text bold
                                  fontFamily:
                                      'Arial', // Optional: Specifies the font family
                                ),
                              ),
                      )),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
