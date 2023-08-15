import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'history_page.dart';
import 'notification_page.dart';

class SearchDepartment extends StatefulWidget {
  const SearchDepartment({Key? key}) : super(key: key);

  @override
  _SearchDepartmentState createState() => _SearchDepartmentState();
}

class _SearchDepartmentState extends State<SearchDepartment>
    with SingleTickerProviderStateMixin {
  dynamic user; // Declaring user as a global variable
  late AnimationController _animationController;
  late Animation<Color?> _buttonColorAnimation;
  bool _isButtonHighlighted = false;

  @override
  void initState() {
    super.initState();
    getUser();

    // Initialize the animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Create the button color animation
    _buttonColorAnimation = ColorTween(
      begin: Colors.cyan[500],
      end: Colors.cyan[700],
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final storedUser = prefs.getString('User');

    if (storedUser != null) {
      final parsedUser = jsonDecode(storedUser);

      setState(() {
        user = parsedUser;
        print(user);
      });
    }
  }

  void _startButtonAnimation() {
    _animationController.forward();
  }

  void _stopButtonAnimation() {
    _animationController.reverse();
  }

  Widget buildDepartmentButton(String departmentName, String routeName, double minWidth) {
    return Expanded(
      child: Align(
        alignment: Alignment.centerLeft,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, routeName);
          },
          onHighlightChanged: (isHighlighted) {
            setState(() {
              _isButtonHighlighted = isHighlighted;
              if (isHighlighted) {
                _startButtonAnimation();
              } else {
                _stopButtonAnimation();
              }
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: [
                  Color.fromARGB(245, 4, 239, 235),
                  Color.fromARGB(255, 17, 209, 226),
                  Color.fromARGB(255, 44, 249, 242),
                ],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            constraints: BoxConstraints(minWidth: minWidth),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              departmentName,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan[700],
        title: Text(
          user != null ? user['fullName'] : '',
          style: const TextStyle(fontSize: 16),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 35),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Chip(
                  label: const Text(
                    'Academic Staff',
                    style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: const Color.fromARGB(255, 5, 101, 114),
                  labelStyle: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 15), // Adding 15px vertical spacing

            buildDepartmentButton(
              'Department of Civil and Environmental Engineering',
              '/page1',
              600,
            ),
            const SizedBox(height: 15), // Adding 15px vertical spacing
            buildDepartmentButton(
              'Department of Electrical and Environmental Engineering',
              '/searchDepartmentElec',
              600,
            ),
            const SizedBox(height: 15), // Adding 15px vertical spacing
            buildDepartmentButton(
              'Department of Mechanical and Manufacturing Engineering',
              '/page3',
              600,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 38, 118, 140),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: 0, // Set the index of the currently selected item here
        onTap: (index) {
          // Handle navigation when a bottom navigation bar item is tapped
          if (index == 0) {
            Navigator.pushNamed(context, '/historypage'); // Navigate to the HistoryPage
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/lechome');
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotificationPage()), // Navigate to the NotificationPage
            );
          }
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home Page',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
        ],
      ),
    );
  }
}
