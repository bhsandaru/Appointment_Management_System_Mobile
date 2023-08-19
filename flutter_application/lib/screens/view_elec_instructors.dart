import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:convert';
import '../config.dart';


class ViewElecInstructor extends StatefulWidget {
  @override
  _ViewElecInstructorState createState() => _ViewElecInstructorState();
}

class _ViewElecInstructorState extends State<ViewElecInstructor> {
  dynamic user;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  void getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final storedUser = prefs.getString('User');

    if (storedUser != null) {
      final parsedUser = jsonDecode(storedUser);

      setState(() {
        user = parsedUser;
      });
    }
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
      ),
      body: ListView.builder(
        itemCount: instructorData.length,
        itemBuilder: (BuildContext context, int index) {
          final instructor = instructorData[index];
          return Card(
            child: SizedBox(
              width: 250,
              height: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 8),
                  CircleAvatar(
                    radius: 100,
                    backgroundImage: NetworkImage(instructor['imageURL']),
                  ),
                  ListTile(
                    title: Text(
                      instructor['fullName'],
                      textAlign: TextAlign.center,
                    ),
                    subtitle: Text(
                      instructor['email'],
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Handle view details button click
                    },
                    child: Text('View Details'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.cyan[500],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
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
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
        backgroundColor: Colors.cyan[700],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        // Handle navigation to the history page
      } else if (index == 1) {
        // Handle navigation to the home page
      } else if (index == 2) {
        // Handle navigation to the notifications page
      }
    });
  }
}

List<Map<String, dynamic>> instructorData = [
  {
    'fullName': 'Instructor 1',
    'email': 'instructor1@example.com',
    'imageURL':
        'https://via.placeholder.com/150', // Replace with actual image URL
  },
  {
    'fullName': 'Instructor 2',
    'email': 'instructor2@example.com',
    'imageURL':
        'https://via.placeholder.com/150', // Replace with actual image URL
  },
  // Add more instructor data here
];
