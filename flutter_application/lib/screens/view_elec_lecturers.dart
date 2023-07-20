

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ViewElecLecturer extends StatefulWidget {
  @override
  _ViewElecLecturerState createState() => _ViewElecLecturerState();
}

class _ViewElecLecturerState extends State<ViewElecLecturer> {
  List<dynamic> lec = [];
  Map<String, dynamic> users = {};
  dynamic user;

  @override
  void initState() {
    super.initState();
    getUsers();
    getUser();
  }

  void getUsers() async {
    try {
      final response =
          await http.get(Uri.parse("http://localhost:8080/api/users/"));
      if (response.statusCode == 200) {
        setState(() {
          lec = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      print(e);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to fetch data. Please try again.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
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
      });
    }
  }

  void getLec(String data) async {
    try {
      final response = await http
          .get(Uri.parse("http://localhost:8080/api/users/getOne/$data"));
      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        // Store user data in local storage
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('Lec', json.encode(userData));

        setState(() {
          users = userData;
          Navigator.pushNamed(context, '/viewLecturerPage');
        });
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      print(e);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to fetch data. Please try again.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
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
      body: ListView.builder(
        itemCount: lec.length,
        itemBuilder: (BuildContext context, int index) {
          final item = lec[index];
          if (item['role'] == 'Lecturer' &&
              item['department'] ==
                  'Department of Electrical and Information Engineering') {
            return GestureDetector(
                onTap: () => getLec(item['email']),
                child: Center(
                  child: Card(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.blue,
                          width: 2,
                        ),
                      ),
                      child: SizedBox(
                        width: 250,
                        height: 300,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 8),
                              Image.network(
                                'http://eie.eng.ruh.ac.lk/wp-content/uploads/2020/03/6.jpg',
                                width: 200,
                                height: 200,
                              ),
                              ListTile(
                                title: Text(item['fullName']),
                                subtitle: Text(item['email']),
                              ),
                              ElevatedButton(
                                onPressed: () => getLec(item['email']),
                                child: Text('View Details'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ));
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }
}