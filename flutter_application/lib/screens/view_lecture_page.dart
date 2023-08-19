import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../config.dart';

class ViewLecturerPage extends StatefulWidget {
  const ViewLecturerPage({Key? key}) : super(key: key);

  @override
  _ViewLecturerPageState createState() => _ViewLecturerPageState();
}

class _ViewLecturerPageState extends State<ViewLecturerPage> {
  dynamic users;
  dynamic user;

  @override
  void initState() {
    super.initState();
    getUser();
    getLecturerFromLocalStorage();
  }

  void getLecturerFromLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final storedUserlec = prefs.getString('Lec');

    if (storedUserlec != null) {
      final parsedUserlec = jsonDecode(storedUserlec);
      setState(() {
        users = parsedUserlec;
      });
    }
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
    if (users == null || user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final fullName = user['fullName'] ?? 'Unknown Name';
    final lecfullName = users['fullName'] ?? 'Unknown Name';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 11, 182, 229),
        title: Text(
          fullName,
          style: const TextStyle(fontSize: 16),
        ),
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      'https://media.licdn.com/dms/image/C5603AQHV1uGlMl9ViA/profile-displayphoto-shrink_800_800/0/1593104293459?e=1695859200&v=beta&t=b8-haKHKgiPRzuvgjzGHaXv_QkUXNjCyRprxkxNaAy4',
                      //'https://images.unsplash.com/photo-1620523162656-4f968dca355a?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8OHx8YmVhdXRpZnVsJTIwZ2lybHN8ZW58MHx8MHx8&w=1000&q=80',
                    ),
                    radius: 125,
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Card(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Chip(
                          label: Text(
                            'Name: $lecfullName',
                            style: const TextStyle(fontSize: 14),
                          ),
                          backgroundColor: const Color(0xFFC5ECF1),
                          labelPadding: const EdgeInsets.all(4),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Chip(
                          label: Text(
                            'Department: ${users['department'] ?? 'Unknown Name'}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          backgroundColor: const Color(0xFFC5ECF1),
                          labelPadding: const EdgeInsets.all(4),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Chip(
                          label: Text(
                            'Email: ${users['email'] ?? 'Unknown Name'}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          backgroundColor: const Color(0xFFC5ECF1),
                          labelPadding: const EdgeInsets.all(4),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Chip(
                          label: Text(
                            'Contact No: ${users['telephoneNo'] ?? 'Unknown Name'}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          backgroundColor: const Color(0xFFC5ECF1),
                          labelPadding: const EdgeInsets.all(4),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Chip(
                          label: Text(
                            'Registration No: ${users['regNo'] ?? 'Unknown Name'}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          backgroundColor: const Color(0xFFC5ECF1),
                          labelPadding: const EdgeInsets.all(4),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/calendar');
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.cyan[500], // Set the background color to cyan
                    padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 25),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Add Appointment'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

