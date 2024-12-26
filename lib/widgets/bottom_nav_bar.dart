import 'package:flutter/material.dart';
import 'package:doctor_app/screens/profile/profile_screen.dart'; // Import the ProfileScreen

import 'package:flutter/material.dart';
import 'package:doctor_app/screens/profile/profile_screen.dart'; // Import the ProfileScreen

class BottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTabSelected;
  final BuildContext context; // Add context to navigate

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTabSelected,
    required this.context, // Pass context for navigation
  }) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late int currentPage;
  final List<Color> colors = [
    Colors.green,
    Colors.green,
    Colors.green,
  ];

  @override
  void initState() {
    super.initState();
    currentPage = widget.currentIndex;
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      final value = tabController.index;
      if (value != currentPage && mounted) {
        setState(() {
          currentPage = value;
        });
        widget.onTabSelected(value); // Notify the parent about the tab change
      }
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color unselectedColor = colors[currentPage].computeLuminance() < 0.5
        ? Colors.black
        : Colors.white;

    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      child: SizedBox(
        height: 60,
        child: TabBar(
          controller: tabController,
          indicatorPadding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(color: colors[currentPage], width: 1.5),
            insets: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          ),
          tabs: [
            _buildTab(Icons.assignment, "Assignment Shift", 0, unselectedColor),
            _buildTab(Icons.verified, "Verified", 1, unselectedColor),
            _buildTab(Icons.person, "Profile", 2, unselectedColor),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(
      IconData icon, String label, int index, Color unselectedColor) {
    return Tab(
      child: GestureDetector(
        onTap: () {
          widget.onTabSelected(index); // Notify parent to handle navigation
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: currentPage == index ? colors[index] : unselectedColor,
            ),
            const SizedBox(height: 2), // Space between icon and text
            Text(
              label,
              style: TextStyle(
                color: currentPage == index ? colors[index] : unselectedColor,
                fontSize: 12, // Adjust font size if needed
              ),
            ),
          ],
        ),
      ),
    );
  }
}
