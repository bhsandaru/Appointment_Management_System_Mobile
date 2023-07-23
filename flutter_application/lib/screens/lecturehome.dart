import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'loginpage.dart';
import 'search_department.dart';
// import 'event_calendar.dart';

class LectureHome extends StatefulWidget {
  const LectureHome({Key? key}) : super(key: key);

  @override
  _LectureHomeState createState() => _LectureHomeState();
}

class _LectureHomeState extends State<LectureHome> {
  dynamic user; // Declaring user as a global variable
  List appointments = [];

  @override
  void initState() {
    super.initState();
    getUser();
    getAppointments();
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

  void getAppointments() {
    var url = 'http://localhost:8080/api/appointments/';
    http.get(Uri.parse(url)).then((response) {
      if (response.statusCode == 200) {
        setState(() {
          appointments = jsonDecode(response.body);
        });
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Failed to fetch appointments.'),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }).catchError((error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(error.toString()),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    });
  }

  bool get isStudent => user != null && user['role'] == 'Student';

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Text('Loading');
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 8, 127, 161),
        title: Text(
          user['fullName'],
          style: const TextStyle(fontSize: 16),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 100,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 33, 120, 141),
              ),
              child: const Center(
                child: Text(
                  'Appointment Management System',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            ListTile(
              title: const Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text('Acedemic Staff'),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchDepartment()),
                );
              },
            ),
            ListTile(
              title: const Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text('Logout'),
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const Expanded(
            flex: 1,
            child: Row(
              children: [],
            ),
          ),
          Expanded(
            flex: 2,
            child: ListView.builder(
              itemCount: 1,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Scheduled Appointments
                        const SizedBox(height: 20),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Chip(
                                label: Text('Scheduled Appointments'),
                                backgroundColor: Color(0xFFE1F4F8),
                                labelStyle: TextStyle(fontSize: 16),
                              ),
                              // if (isStudent)
                              //   ElevatedButton(
                              //     onPressed: () {
                              //       Navigator.pushNamed(
                              //           context, '/StaffDetailsElec');
                              //     },
                              //     child: Text('VIEW'),
                              //     style: ButtonStyle(
                              //       backgroundColor:
                              //           MaterialStateProperty.all<Color>(
                              //               Color(0xFF46B7C7)),
                              //     ),
                              //   ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Filtered Appointments
                        Column(
                          children: [
                            // Appointments where the user is a student and is the maker
                            ...appointments
                                .where((item) =>
                                    (item['maker'] == user['regNo'] &&
                                        user['role'] == 'Student') &&
                                    item['status'] == 2)
                                .map((item) => Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('with ${item['seeker']}'),
                                            Text('Reason: ${item['subject']}'),
                                            Text('Date: ${item['date']}'),
                                            Text('Time: ${item['time']}'),
                                          ],
                                        ),
                                      ),
                                    ))
                                .toList(),
                            // Appointments where the user is a lecturer and is the seeker
                            ...appointments
                                .where((item) =>
                                    item['seeker'] == user['regNo'] &&
                                    user['role'] == 'Lecturer')
                                .map((item) => Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('with ${item['maker']}'),
                                            Text('Reason: ${item['subject']}'),
                                            Text('Date: ${item['date']}'),
                                            Text('Time: ${item['time']}'),
                                          ],
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
