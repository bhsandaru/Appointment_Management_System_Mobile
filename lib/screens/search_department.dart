import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SearchDepartment extends StatefulWidget {
  const SearchDepartment({Key? key}) : super(key: key);

  @override
  _SearchDepartmentState createState() => _SearchDepartmentState();
}

class _SearchDepartmentState extends State<SearchDepartment> {
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
              label: Text('Departments'),
              backgroundColor: Color(0xFFC5ECF1),
              labelStyle: TextStyle(fontSize: 16),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/page1');
            },
            child:
                const Text('Department of Civil and Environmental Engineering'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/searchDepartmentElec');
            },
            child: const Text(
                'Department of Electrical and Environmental Engineering'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/page3');
            },
            child: const Text(
                'Department of Mechanical and Manufacturing Engineering'),
          ),
        ],
      ),
    );
  }
}
