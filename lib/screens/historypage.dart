import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'loginpage.dart';
import 'search_department.dart';
import 'event_calendar.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  dynamic user;
  List appointments = [];

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('en', null);
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
      });
    }
  }

  void getAppointments() {
    var url = 'http://192.168.197.109:8080/api/appointments/';
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

  bool isAppointmentBeforeNow(Map<String, dynamic> appointment) {
    final appointmentDate =
        DateFormat('EEE dd MMMM', 'en').parse(appointment['date']);
    final appointmentTime =
        DateFormat('h:mm a').parse(appointment['time'].trim());

    final now = DateTime.now();
    final currentDate = DateTime(now.day, now.month);
    final currentTime = TimeOfDay.fromDateTime(now);

    if (appointmentDate.isBefore(currentDate)) {
      return true;
    } else if (appointmentDate.isAtSameMomentAs(currentDate) &&
        appointmentTime.hour < currentTime.hour) {
      return true;
    } else if (appointmentDate.isAtSameMomentAs(currentDate) &&
        appointmentTime.hour == currentTime.hour &&
        appointmentTime.minute < currentTime.minute) {
      return true;
    }

    return false;
  }

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
        actions: const <Widget>[
          CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(
                'https://img.lovepik.com/element/40128/7461.png_1200.png'),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 100,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 59, 184, 218),
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
                child: Text(isStudent ? 'Search Lecturer' : 'Schedule'),
              ),
              onTap: () {
                if (isStudent) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SearchDepartment()),
                  );
                } else {
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
                        const SizedBox(height: 6),
                        const Padding(
                          padding: EdgeInsets.all(1.0),
                          child: Row(
                            children: [
                              Chip(
                                label: Text('History'),
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
                        Column(
                          children: [
                            // Appointments where the user is a student and is the maker
                            ...appointments
                                .where((item) =>
                                    (item['maker'] == user['regNo'] &&
                                        user['role'] == 'Student') &&
                                    item['status'] == 2 &&
                                    isAppointmentBeforeNow(item))
                                .map((item) => Container(
                                      width: 300,
                                      child: Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('with ${item['seeker']}'),
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
                                    item['status'] == 2 &&
                                    isAppointmentBeforeNow(item))
                                .map((item) => Container(
                                      width: 300,
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
              // Navigator.pushNamed(context, '/historypage');
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
