import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
//import 'history_page.dart';
//import 'notification_page.dart';
//import '../config.dart';

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
       // print(user);
      });
    }
  }

  void _startButtonAnimation() {
    _animationController.forward();
  }

  void _stopButtonAnimation() {
    _animationController.reverse();
  }

  Widget buildDepartmentButton(String departmentName, String routeName) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
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
            constraints: BoxConstraints(minWidth: double.infinity),
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
        backgroundColor: const Color.fromARGB(255, 11, 182, 229),
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
        padding: const EdgeInsets.only(top: 35, left: 8, right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16), // Adding 50px vertical spacing
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Chip(
              label: Text('Departments'),
              backgroundColor: Color(0xFFC5ECF1),
              labelStyle: TextStyle(fontSize: 16),
            ),
            ),
            SizedBox(height: 30), // Adding 30px vertical spacing
            
            buildDepartmentButton(
              'Department of Civil and Environmental Engineering',
              '/searchDepartmentCivil',
            ),
            buildDepartmentButton(
              'Department of Electrical and Environmental Engineering',
              '/searchDepartmentElec',
            ),
            buildDepartmentButton(
              'Department of Mechanical and Manufacturing Engineering',
              '/searchDepartmentMech',
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        height: 50,
        backgroundColor: Color.fromARGB(255, 38, 118, 140),
        destinations: <Widget>[
          IconButton(
            icon: Icon(Icons.history),
            color: Colors.white,
            tooltip: 'History',
            onPressed: () {
              Navigator.pushNamed(context, '/historypage');
            },
          ),
          IconButton(
            icon: Icon(Icons.home),
            color: Colors.white,
            tooltip: 'Home Page',
            onPressed: () {
              Navigator.pushNamed(context, '/lechome');
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications),
            color: Colors.white,
            tooltip: 'Notifications',
            onPressed: () {
              Navigator.pushNamed(context, '/notificationpage');
            },
          ),
        ],
      ),
    );
  }
    }