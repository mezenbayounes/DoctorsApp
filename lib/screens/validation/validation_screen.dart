import 'package:doctor_app/screens/validation/validation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch all users when the screen is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ValidationProvider>(context, listen: false).fetchAllUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final validationProvider = context.watch<ValidationProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Users Not Verified List'),
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
          RefreshIndicator(
            onRefresh: () async {
              // Trigger the method to fetch the users again when pulled down
              await validationProvider.fetchAllUsers();
            },
            child: Consumer<ValidationProvider>(
              builder: (context, validationProvider, child) {
                if (validationProvider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                if (validationProvider.profiles.isEmpty) {
                  return Center(child: Text('No users found.'));
                }

                return ListView.builder(
                  itemCount: validationProvider.profiles.length,
                  itemBuilder: (context, index) {
                    final user = validationProvider.profiles[index];

                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      elevation: 9,
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16),
                        title: Text(user.name,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Email: ${user.email}'),
                            Text('Role: ${user.role}'),
                            Text(
                                'Validated: ${user.isValidated ? 'Yes' : 'No'}'),
                          ],
                        ),
                        trailing: user.isValidated
                            ? Icon(
                                Icons.verified,
                                color: Colors.green, // Green for verified
                              )
                            : TextButton(
                                onPressed: () async {
                                  // Call the function to verify the user account
                                  if (!user.isValidated) {
                                    await validationProvider
                                        .validate(user.email);
                                    setState(() {
                                      // Force a rebuild to update the UI after validation
                                      user.isValidated = true;
                                    });
                                  }
                                },
                                child: Text(
                                  'Verify Account', // Text displayed on the button
                                  style: TextStyle(
                                    color: Colors
                                        .blue, // Change the text color as needed
                                  ),
                                ),
                              ),
                        onTap: () {
                          // Navigate to user details page or show a dialog
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
