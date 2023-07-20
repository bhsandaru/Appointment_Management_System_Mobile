import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
// import 'search_department.dart';

class SearchDepartmentElec extends StatefulWidget {
  const SearchDepartmentElec({Key? key}) : super(key: key);

  @override
  _SearchDepartmentElecState createState() => _SearchDepartmentElecState();
}

class _SearchDepartmentElecState extends State<SearchDepartmentElec> {
  dynamic user; // Declaring user as a global variable

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
        print(user);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 11, 182, 229),
        title: Text(
          user != null ? user['fullName'] : '',
          style: const TextStyle(fontSize: 16),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16), // Adding space above the Chip
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Chip(
              label: Text(
                  'Department of Electrical and Environmental Engineering'),
              backgroundColor: Color(0xFFC5ECF1),
              labelStyle: TextStyle(fontSize: 11),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/viewElecLecturer');
            },
            child: Text('Lecturers'),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/page2');
            },
            child: const Text('Instructors'),
          ),
        ],
      ),
    );
  }
}
