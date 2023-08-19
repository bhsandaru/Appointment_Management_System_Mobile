import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'loginpage.dart';
import 'search_department.dart';
//import 'notificationpage.dart';
import 'event_calendar.dart';
import '../config.dart';

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
    var url = '${AppConfig.apiUrl}/api/appointments/';
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
        backgroundColor: Color.fromARGB(255, 38, 118, 140),
        title: Text(
          user['fullName'],
          style: const TextStyle(fontSize: 16),
        ),
        // actions: [IconButton(
        //     icon: const Icon(Icons.add_alert),
        //     tooltip: 'Show AccountPage',
        //     onPressed: () {
        //       // ScaffoldMessenger.of(context).showSnackBar(
        //       //     const SnackBar(content: Text('This is a snackbar')));
        //     },
        //   ),],

        actions: <Widget>[
          AspectRatio(
            aspectRatio: 1.0, // Set the desired aspect ratio
            child: CircleAvatar(
              radius: 100,
              backgroundImage: NetworkImage(user['userimage']),
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 130,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 38, 118, 140),
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
              title: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(user['role'] == 'Lecturer'
                    ? 'Schedule'
                    : 'Search Lecturer'),
              ),
              onTap: () {
                if (user['role'] == 'Student') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SearchDepartment()),
                  );
                } else if (user['role'] == 'Lecturer') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EventCalendarScreen()),
                  );
                }
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
          Expanded(
            flex: 2,
            child: ListView.builder(
              itemCount: 1,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Column(
                      children: [
                        // Scheduled Appointments
                        const SizedBox(
                            height: 6), // Adding space above the Chip
                        const Padding(
                          padding: EdgeInsets.all(1.0),
                          child: Row(
                            children: [
                              Chip(
                                label: Text('Scheduled Appointments'),
                                backgroundColor: Color(0xFFC5ECF1),
                                labelStyle: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                          width: 25,
                        ),
// Filtered Appointments
                        Column(
                          children: [
                            // Appointments where the user is a student and is the maker
                            ...appointments
                                .where((item) =>
                                    (item['maker'] == user['regNo'] &&
                                        user['role'] == 'Student') &&
                                    item['status'] == 2)
                                .map((item) => Container(
                                      // Wrap the Card with Container

                                      width: 300, // Set the desired width here
                                      child: Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  'Appointment with ${item['seeker']}'),
                                              Text(
                                                  'Reason: ${item['subject']}'),
                                              Text('Date: ${item['date']}'),
                                              Text('Time: ${item['time']}'),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ))
                                .toList(),
                            // Appointments where the user is a lecturer and is the seeker
                            ...appointments
                                .where((item) =>
                                    item['seeker'] == user['fullName'] &&
                                    user['role'] == 'Lecturer' &&
                                    item['status'] == 2)
                                .map((item) => Container(
                                      // Wrap the Card with Container
                                      width: 300, // Set the desired width here
                                      child: Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('with ${item['maker']}'),
                                              Text(
                                                  'Reason: ${item['subject']}'),
                                              Text('Date: ${item['date']}'),
                                              Text('Time: ${item['time']}'),
                                            ],
                                          ),
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
              // Navigator.pushNamed(context, '/lechome');
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
