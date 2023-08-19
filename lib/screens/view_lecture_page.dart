import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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
        print(users);
        print("Lecturer");
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
        print(user);
        print("Sandaru");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty || user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    //final fullName = users['fullName'] ?? 'Unknown Name';
    String userDetails = "Full Name: ${users["User"]["fullName"]}\n"
        // "Department: if(${users["User"]["department"]}\n"
        "Email: ${users["User"]["email"]}\n"
        "Contact No: ${users["User"]["telephoneNo"]}";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 11, 182, 229),
        title: Text(
          user['fullName'],
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
                  SizedBox(height: 16),
                  CircleAvatar(
                    radius: 100,
                    backgroundImage:
                        NetworkImage(users["User"]["userimage"] ?? ""),
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
                    color:
                        const Color(0xFFC5ECF1), // Light blue background color
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Text(
                          userDetails,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),

                // const SizedBox(height: 10),
                // Card(
                //   child: Container(
                //     padding: const EdgeInsets.all(16),
                //     child: Row(
                //       children: [
                //         Chip(
                //           label: Text(
                //             'Department: ${users['department'] ?? 'Unknown Name'}',
                //             style: const TextStyle(fontSize: 14),
                //           ),
                //           backgroundColor: const Color(0xFFC5ECF1),
                //           labelPadding: const EdgeInsets.all(4),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // const SizedBox(height: 10),
                // Card(
                //   child: Container(
                //     padding: const EdgeInsets.all(16),
                //     child: Row(
                //       children: [
                //         Chip(
                //           label: Text(
                //             'Email: ${users['email'] ?? 'Unknown Name'}',
                //             style: const TextStyle(fontSize: 14),
                //           ),
                //           backgroundColor: const Color(0xFFC5ECF1),
                //           labelPadding: const EdgeInsets.all(4),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // const SizedBox(height: 10),
                // Card(
                //   child: Container(
                //     padding: const EdgeInsets.all(16),
                //     child: Row(
                //       children: [
                //         Chip(
                //           label: Text(
                //             'Contact No: ${users['telephoneNo'] ?? 'Unknown Name'}',
                //             style: const TextStyle(fontSize: 14),
                //           ),
                //           backgroundColor: const Color(0xFFC5ECF1),
                //           labelPadding: const EdgeInsets.all(4),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // const SizedBox(height: 10),
                // Card(
                //   child: Container(
                //     padding: const EdgeInsets.all(16),
                //     child: Row(
                //       children: [
                //         Chip(
                //           label: Text(
                //             'Registration No: ${users['regNo'] ?? 'Unknown Name'}',
                //             style: const TextStyle(fontSize: 14),
                //           ),
                //           backgroundColor: const Color(0xFFC5ECF1),
                //           labelPadding: const EdgeInsets.all(4),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/calendar');
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor:
                        Colors.cyan[500], // Set the background color to cyan
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 25),
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
