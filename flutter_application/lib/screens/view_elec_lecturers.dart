import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';

class ViewElecLecturer extends StatefulWidget {
  @override
  _ViewElecLecturerState createState() => _ViewElecLecturerState();
}

class _ViewElecLecturerState extends State<ViewElecLecturer> {
  List<dynamic> lec = [];
  Map<String, dynamic> users = {};
  dynamic user;

  @override
  void initState() {
    super.initState();
    getUsers();
    getUser();
  }

  void getUsers() async {
    try {
      final response =
          await http.get(Uri.parse("${AppConfig.apiUrl}/api/users/"));
      if (response.statusCode == 200) {
        setState(() {
          lec = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      print(e);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to fetch data. Please try again.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
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

  void getLec(String data) async {
    try {
      final response = await http
          .get(Uri.parse("${AppConfig.apiUrl}/api/users/getOne/$data"));
      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        // Store user data in local storage
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('Lec', json.encode(userData));

        setState(() {
          users = userData;
          Navigator.pushNamed(context, '/viewLecturerPage');
        });
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      print(e);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to fetch data. Please try again.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan[700],
        title: Text(
          user['fullName'] ?? '',
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: ListView.builder(
        itemCount: lec.length,
        itemBuilder: (BuildContext context, int index) {
          final item = lec[index];
          if (item['role'] == 'Lecturer' &&
              item['department'] ==
                  'Department of Electrical and Information Engineering') {
            return GestureDetector(
              onTap: () => getLec(item['email']),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                       CircleAvatar(
      radius: 100,
      backgroundImage: NetworkImage(item['userimage']),
    ),
                      SizedBox(height: 16),
                      Text(
                        item['fullName'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(item['email']),
                      ElevatedButton(
                        onPressed: () => getLec(item['email']),
                        child: Text('View Details'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return SizedBox.shrink();
          }
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
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
        currentIndex: 0, // Set the current index accordingly
        backgroundColor: Colors.cyan[500], // Set the desired bottom navigation bar color
      ),
    );
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      _navigateToViewElecLecturer();
    } else if (index == 1) {
      // Handle navigation to home page
    } else if (index == 2) {
      // Handle navigation to notifications
    }
  }

  void _navigateToViewElecLecturer() {
    Navigator.pushNamed(context, '/viewElecLecturer');
  }
}
