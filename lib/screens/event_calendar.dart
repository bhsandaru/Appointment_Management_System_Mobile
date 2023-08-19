import 'dart:convert';
// import 'dart:ffi';
// import 'dart:ffi';
//import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:table_calendar/table_calendar.dart';
import '../config.dart';

class EventCalendarScreen extends StatefulWidget {
  @override
  _TestingState createState() => _TestingState();
}

class _TestingState extends State<EventCalendarScreen> {
  DateTime selectedDate = DateTime.now();
  dynamic user;
  List<Map<String, dynamic>> appointments = [];
  String subject = '';
  String notes = '';
  String time = '';
  // String maker = '';
  String seeker = '';
  String status = "1";
  String category = '';

  String isbooked = " ";

  List<String> subjects = [
    'Advisor Meeting',
    'Project Evaluation',
    'One-on-One Meetings',
    'Group Meetings'
    // Add more subjects as needed
  ];

  CalendarFormat calendarFormat = CalendarFormat.month;
  DateTime focusedDay = DateTime.now();
  DateTime selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    getUser();
    getSeekerId();
    fetchAppointments(selectedDate);
  }

  void handleUpdate3(String appointmentId) async {
    const status = "4";
    print(user);
    try {
      final response = await http.patch(
        Uri.parse("${AppConfig.apiUrl}/api/appointments/update/$appointmentId"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"status": status}),
      );

      if (response.statusCode == 200) {
        print(response.body); // Handle successful update
        fetchAppointments(selectedDate); // Refresh the appointments list
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (error) {
      print("Error: $error");
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

  void getSeekerId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final storedUser = prefs.getString('Lec');
    if (storedUser != null) {
      final parsedUser = jsonDecode(storedUser);
      setState(() {
        seeker = parsedUser['User']['fullName'];
      });
    }
  }

  Future<void> sendData() async {
    try {
      final newAppointment = {
        'subject': subject,
        'time': time,
        'date': DateFormat('EEE,M/d/y')
            .format(selectedDay), // Use selectedDay instead of selectedDate
        'maker': user['regNo'] ?? '',
        'seeker': seeker,
        'notes': notes,
        'status': status,
        'category': category,
      };

      final response = await http.post(
        Uri.parse('${AppConfig.apiUrl}/api/appointments/add'),
        body: jsonEncode(newAppointment),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              backgroundColor: Color.fromARGB(255, 144, 218, 227),
              content: Text('Appointment Added'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to add appointment'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred: $error'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> fetchAppointments(DateTime date) async {
    final result = await http.get(
      Uri.parse(
          '${AppConfig.apiUrl}/api/appointments/get?date=${DateFormat('EEE,M/d/y').format(date)}'),
    );

    final data = jsonDecode(result.body);
    setState(() {
      appointments =
          (data['Appointment'] as List<dynamic>).cast<Map<String, dynamic>>();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 38, 118, 140),
        title: Text(
          user['fullName'] ?? '',
          style: const TextStyle(fontSize: 16),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.grey[200],
            child: TableCalendar(
              firstDay: DateTime.utc(2000),
              lastDay: DateTime.utc(2100),
              focusedDay: focusedDay,
              selectedDayPredicate: (day) {
                return isSameDay(selectedDay, day);
              },
              calendarFormat: calendarFormat,
              onFormatChanged: (format) {
                setState(() {
                  calendarFormat = format;
                });
              },
              onPageChanged: (focusedDay) {
                setState(() {
                  this.focusedDay = focusedDay;
                });
                fetchAppointments(focusedDay);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  this.selectedDay = selectedDay;
                  this.focusedDay = focusedDay;
                });
                fetchAppointments(selectedDay);
              },
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: 12,
              itemBuilder: (context, index) {
                final startTime = TimeOfDay(hour: 8, minute: 00);
                final currentTime = startTime.replacing(
                  hour: startTime.hour + (index * 30) ~/ 60,
                  minute: (startTime.minute + (index * 30)) % 60,
                );
                final formattedTime = DateFormat.jm().format(DateTime(
                  selectedDay.year,
                  selectedDay.month,
                  selectedDay.day,
                  currentTime.hour,
                  currentTime.minute,
                ));

                final matchingAppointments = appointments.where((appointments) {
                  return appointments['seeker'] == seeker &&
                      appointments['time'] == formattedTime;
                }).toList();

                bool isSelectable = true;
                final currentDate = DateTime.now();
                final selectedDateTime = DateTime(
                  selectedDay.year,
                  selectedDay.month,
                  selectedDay.day,
                  currentTime.hour,
                  currentTime.minute,
                );
                if (selectedDateTime.isBefore(currentDate)) {
                  // Prevent selection for previous days
                  isSelectable = false;
                }

                // if (matchingAppointments[0]['status'] == 1) {
                //   isbooked = "Pending...";
                // } else if (matchingAppointments[0]['status'] == 2) {
                //   isbooked = matchingAppointments[0]['subject'];
                // }

                return ListTile(
                    title: Text(formattedTime),
                    subtitle: Text(
                      matchingAppointments.isNotEmpty
                          ? matchingAppointments[0]['status'] == 1
                              ? "Pending..."
                              : matchingAppointments[0]['status'] == 2
                                  ? matchingAppointments[0]['subject']
                                  : "free"
                          : "free",
                    ),
                    tileColor: const Color.fromARGB(255, 157, 225, 227),
                    selectedTileColor: const Color.fromARGB(255, 135, 192, 208),
                    shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(28.0),
                    ),
                    onTap: () {
                      if (matchingAppointments.isEmpty && isSelectable) {
                        setState(() {
                          time = formattedTime;
                        });

                        if (user['role'] == 'Student') {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Appointment for $formattedTime'),
                                backgroundColor:
                                    const Color.fromARGB(255, 253, 255, 255),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                        'Please enter the details of your appointment:'),
                                    TextField(
                                      decoration: const InputDecoration(
                                          labelText: 'Subject'),
                                      onChanged: (value) {
                                        setState(() {
                                          subject = value;
                                        });
                                      },
                                    ),
                                    TextField(
                                      decoration: const InputDecoration(
                                          labelText: 'Notes'),
                                      onChanged: (value) {
                                        setState(() {
                                          notes = value;
                                        });
                                      },
                                    ),
                                    TextField(
                                      decoration: const InputDecoration(
                                          labelText: 'category'),
                                      onChanged: (value) {
                                        setState(() {
                                          category = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      setState(() {
                                        subject = '';
                                        notes = '';
                                      });
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      sendData();
                                    },
                                    child: const Text('Save'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                        ///////
                        ///
                        ///
                      }
                      ////////////////////////
                      ///
                      if (matchingAppointments.isNotEmpty && isSelectable) {
                        setState(() {
                          time = formattedTime;
                        });

                        if (((user['role'] == 'Lecturer') ||
                                (user['role'] == 'Instructor')) &&
                            (matchingAppointments[0]['status']) == 2) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Appointment at $formattedTime'),
                                backgroundColor:
                                    const Color.fromARGB(255, 253, 255, 255),
                                content: const Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                        'Do you want to cancel the appointment?'),
                                  ],
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      handleUpdate3(
                                          matchingAppointments[0]['_id']);
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty
                                          .all<Color>(const Color.fromARGB(
                                              255,
                                              191,
                                              22,
                                              10)), // Set the button color to red
                                    ),
                                    child: const Text('Yes'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Navigator.of(context)
                                      //     .pop();
                                      // handleUpdate3(
                                      //     item['_id']);
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty
                                          .all<Color>(const Color.fromARGB(
                                              255,
                                              9,
                                              99,
                                              37)), // Set the button color to red
                                    ),
                                    child: const Text('No'),
                                  )
                                ],
                              );
                            },
                          );
                        }
                      }
                    });
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        height: 50,
        backgroundColor: const Color.fromARGB(255, 38, 118, 140),
        destinations: <Widget>[
          IconButton(
            icon: const Icon(Icons.history),
            color: Colors.white,
            tooltip: 'History',
            onPressed: () {
              Navigator.pushNamed(context, '/historypage');
            },
          ),
          IconButton(
            icon: const Icon(Icons.home),
            color: Colors.white,
            tooltip: 'Home Page',
            onPressed: () {
              Navigator.pushNamed(context, '/lechome');
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
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

void main() {
  runApp(MaterialApp(
    title: 'Appointment Scheduler',
    home: EventCalendarScreen(),
  ));
}
