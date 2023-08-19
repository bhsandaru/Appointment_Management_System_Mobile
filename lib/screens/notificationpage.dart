// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'loginpage.dart';
// import 'search_department.dart';
// import 'event_calendar.dart';
// import 'package:http/http.dart' as http;

// class NotificationPage extends StatefulWidget {
//   const NotificationPage({Key? key}) : super(key: key);

//   @override
//   _NotificationPageState createState() => _NotificationPageState();
// }

// class _NotificationPageState extends State<NotificationPage> {
//   dynamic user; // Declaring user as a global variable
//   List appointments = [];
//   String status = "1";

//   @override
//   void initState() {
//     super.initState();
//     getUser();
//     getAppointments();
//   }

//   void getUser() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     final storedUser = prefs.getString('User');

//     if (storedUser != null) {
//       final parsedUser = jsonDecode(storedUser);

//       setState(() {
//         user = parsedUser;
//         print(user);
//       });
//     }
//   }

// Future<void> updateStatus() async {
//   try {
//     final updatedData = {
//       'status': status,
//     };

//     final response = await http.put(
//       Uri.parse('${AppConfig.apiUrl}/api/appointments//update/:id'),
//       body: jsonEncode(updatedData),
//       headers: {'Content-Type': 'application/json'},
//     );

//     if (response.statusCode == 200) {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text('Success'),
//             backgroundColor: Color.fromARGB(255, 144, 218, 227),
//             content: Text('Status Updated'),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Text('OK'),
//               ),
//             ],
//           );
//         },
//       );
//     } else {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text('Error'),
//             content: Text('Failed to update status'),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Text('OK'),
//               ),
//             ],
//           );
//         },
//       );
//     }
//   } catch (error) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Error'),
//           content: Text('An error occurred: $error'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

//   void getAppointments() {
//     var url = '${AppConfig.apiUrl}/api/appointments/';
//     http.get(Uri.parse(url)).then((response) {
//       if (response.statusCode == 200) {
//         setState(() {
//           appointments = jsonDecode(response.body);
//         });
//       } else {
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: const Text('Error'),
//               content: const Text('Failed to fetch appointments.'),
//               actions: [
//                 TextButton(
//                   child: const Text('OK'),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                 ),
//               ],
//             );
//           },
//         );
//       }
//     }).catchError((error) {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Text('Error'),
//             content: Text(error.toString()),
//             actions: [
//               TextButton(
//                 child: const Text('OK'),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           );
//         },
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (user == null) {
//       return const Text('Loading');
//     }
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color.fromARGB(255, 38, 118, 140),
//         title: Text(
//           user['fullName'],
//           style: const TextStyle(fontSize: 16),
//         ),
//         actions: const <Widget>[
//           CircleAvatar(
//             radius: 16,
//             backgroundImage: NetworkImage(
//                 'https://img.lovepik.com/element/40128/7461.png_1200.png'), // Replace with your image path
//           ),
//         ],
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: <Widget>[
//             Container(
//               height: 100,
//               decoration: const BoxDecoration(
//                 color: Color.fromARGB(255, 59, 184, 218),
//               ),
//               child: const Center(
//                 child: Text(
//                   'Appointment Management System',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ),
//             ListTile(
//               title: Padding(
//                 padding: const EdgeInsets.only(left: 16),
//                 child: Text(user['role'] == 'Lecturer'
//                     ? 'Schedule'
//                     : 'Search Lecturer'),
//               ),
//               onTap: () {
//                 if (user['role'] == 'Student') {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const SearchDepartment()),
//                   );
//                 } else if (user['role'] == 'Lecturer') {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => EventCalendarScreen()),
//                   );
//                 }
//               },
//             ),
//             ListTile(
//               title: const Padding(
//                 padding: EdgeInsets.only(left: 16),
//                 child: Text('Logout'),
//               ),
//               onTap: () {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => const LoginPage()),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             flex: 2,
//             child: ListView.builder(
//               itemCount: 1,
//               itemBuilder: (BuildContext context, int index) {
//                 return Card(
//                   child: Padding(
//                     padding: const EdgeInsets.all(3.0),
//                     child: Column(
//                       children: [
//                         // Scheduled Appointments
//                         const SizedBox(
//                             height: 6), // Adding space above the Chip
//                         const Padding(
//                           padding: EdgeInsets.all(1.0),
//                           child: Row(
//                             children: [
//                               Chip(
//                                 label: Text('Notifications'),
//                                 backgroundColor: Color(0xFFC5ECF1),
//                                 labelStyle: TextStyle(fontSize: 16),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 10,
//                           width: 25,
//                         ),
// // Filtered Appointments
//                         Column(
//                           children: [
//                             // Appointments where the user is a student and is the maker
//                             ...appointments
//                                 .where((item) =>
//                                     (item['maker'] == user['regNo'] &&
//                                         user['role'] == 'Student') &&
//                                     ((item['status'] == 2) ||
//                                         (item['status'] == 3) ||
//                                         (item['status'] == 4)))
//                                 .map((item) => Container(
//                                       // Wrap the Card with Container

//                                       width: 300, // Set the desired width here
//                                       child: Card(
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Text('with ${item['seeker']}'),
//                                               Text(
//                                                   'Reason: ${item['subject']}'),
//                                               Text('Date: ${item['date']}'),
//                                               Text('Time: ${item['time']}'),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ))
//                                 .toList(),
//                             // Appointments where the user is a lecturer and is the seeker
//                             ...appointments
//                                 .where((item) =>
//                                     item['seeker'] == user['regNo'] &&
//                                     user['role'] == 'Lecturer' &&
//                                     item['status'] == 1)
//                                 .map((item) => Container(
//                                       // Wrap the Card with Container
//                                       width: 300, // Set the desired width here
//                                       child: Card(
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Text('with ${item['maker']}'),
//                                               Text(
//                                                   'Reason: ${item['subject']}'),
//                                               Text('Date: ${item['date']}'),
//                                               Text('Time: ${item['time']}'),
//                                               Row(
//                                                 mainAxisAlignment: MainAxisAlignment
//                                                     .spaceEvenly, // Adjust the alignment as needed
//                                                 children: [
//                                                   ElevatedButton(
//                                                     onPressed: () {
//                                                       Navigator.of(context)
//                                                           .pop();
//                                                       setState(() {
//                                                         item['status'] = "2";
//                                                       });
//                                                     },
//                                                     child: const Text('Accept'),
//                                                   ),
//                                                   ElevatedButton(
//                                                     onPressed: () {
//                                                       Navigator.of(context)
//                                                           .pop();
//                                                       setState(() {
//                                                         item['status'] = "3";
//                                                       });
//                                                     },
//                                                     child:const Text('Reject'),
//                                                   ),
//                                                 ],
//                                               )
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ))
//                                 .toList(),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: NavigationBar(
//         height: 50,
//         backgroundColor: Color.fromARGB(255, 38, 118, 140),
//         destinations: <Widget>[
//           IconButton(
//             icon: Icon(Icons.history),
//             color: Colors.white,
//             tooltip: 'History',
//             onPressed: () {
//               Navigator.pushNamed(context, '/historypage');
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.home),
//             color: Colors.white,
//             tooltip: 'Home Page',
//             onPressed: () {
//               Navigator.pushNamed(context, '/lechome');
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.notifications),
//             color: Colors.white,
//             tooltip: 'Notifications',
//             onPressed: () {
//               // Navigator.pushNamed(context, '/notificationpage');
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'loginpage.dart';
import 'search_department.dart';
import 'event_calendar.dart';
import 'package:http/http.dart' as http;
import '../config.dart';

class Appointment {
  String id; // Make the id property nullable
  String status;

  Appointment({required this.id, required this.status});

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(id: json['id'], status: json['status']);
  }
}

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
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
        // print(user);
      });
    }
  }

  void handleUpdate2(String appointmentId) async {
    const status = "2";
    print(user);
    try {
      final response = await http.patch(
        Uri.parse("${AppConfig.apiUrl}/api/appointments/update/$appointmentId"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"status": status}),
      );

      if (response.statusCode == 200) {
        print(response.body); // Handle successful update
        getAppointments(); // Refresh the appointments list
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (error) {
      print("Error: $error");
    }
  }

  void handleUpdate3(String appointmentId) async {
    const status = "3";
    print(user);
    try {
      final response = await http.patch(
        Uri.parse("${AppConfig.apiUrl}/api/appointments/update/$appointmentId"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"status": status}),
      );

      if (response.statusCode == 200) {
        print(response.body); // Handle successful update
        getAppointments(); // Refresh the appointments list
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (error) {
      print("Error: $error");
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
                'https://img.lovepik.com/element/40128/7461.png_1200.png'), // Replace with your image path
          ),
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
                                label: Text('Notifications'),
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
                                    ((item['status'] == 2) ||
                                        (item['status'] == 3) ||
                                        (item['status'] == 4)))
                                .map((item) {
                              String message = '';
                              if (item['status'] == 2) {
                                message =
                                    'Appointment with ${item['seeker']} is accepted.';
                              } else if (item['status'] == 3) {
                                message =
                                    'Appointment with ${item['seeker']} is rejected.';
                              } else if (item['status'] == 4) {
                                message =
                                    'Scheduled Appointment with ${item['seeker']} is canceled.';
                              }

                              return Container(
                                width: 300,
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            message), // Display the appropriate message
                                        Text('Reason: ${item['subject']}'),
                                        Text('Date: ${item['date']}'),
                                        Text('Time: ${item['time']}'),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),

                            // Appointments where the user is a lecturer and is the seeker
                            ...appointments
                                .where((item) =>
                                    item['seeker'] == user['fullName'] &&
                                    user['role'] == 'Lecturer' &&
                                    item['status'] == 1)
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
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .spaceEvenly, // Adjust the alignment as needed
                                                children: [
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      handleUpdate2(
                                                          item['_id']);
                                                    },
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty.all<
                                                                  Color>(
                                                              const Color
                                                                  .fromARGB(
                                                                  255,
                                                                  9,
                                                                  99,
                                                                  37)), // Set the button color to red
                                                    ),
                                                    child: const Text('Accept'),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      handleUpdate3(
                                                          item['_id']);
                                                    },
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty.all<
                                                                  Color>(
                                                              const Color
                                                                  .fromARGB(
                                                                  255,
                                                                  191,
                                                                  22,
                                                                  10)), // Set the button color to red
                                                    ),
                                                    child: const Text('Reject'),
                                                  )
                                                ],
                                              )
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
              Navigator.pushNamed(context, '/lechome');
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications),
            color: Colors.white,
            tooltip: 'Notifications',
            onPressed: () {
              // Navigator.pushNamed(context, '/notificationpage');
            },
          ),
        ],
      ),
    );
  }
}
