import 'dart:convert';
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
        seeker = parsedUser['User']['regNo'];
      });
    }
  }

  Future<void> sendData() async {
    try {
      final newAppointment = {
        'subject': subject,
        'time': time,
        'date': DateFormat('EEE dd MMMM')
            .format(selectedDay), // Use selectedDay instead of selectedDate
        'maker': user['regNo'] ?? '',
        'seeker': seeker,
        'notes': notes,
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
          '${AppConfig.apiUrl}/api/appointments/get?date=${DateFormat('EEE dd MMMM').format(date)}'),
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
        backgroundColor: const Color.fromARGB(255, 11, 182, 229),
        title: Text(
          user['fullName'] ?? '',
          style: const TextStyle(fontSize: 16),
        ),
      ),
      body: Column(
        children: [
          TableCalendar(
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

                return ListTile(
                  title: Text(formattedTime),
                  subtitle: Text(matchingAppointments.isNotEmpty
                      ? matchingAppointments[0]['subject']
                      : 'Free'),
                  onTap: () {
                    if (matchingAppointments.isEmpty && isSelectable) {
                      setState(() {
                        time = formattedTime;
                      });

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Appointment for $formattedTime'),
                            backgroundColor: Color.fromARGB(255, 253, 255, 255),
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
                                  decoration:
                                      InputDecoration(labelText: 'Notes'),
                                  onChanged: (value) {
                                    setState(() {
                                      notes = value;
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
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  sendData();
                                },
                                child: Text('Save'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                );
              },
            ),
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
