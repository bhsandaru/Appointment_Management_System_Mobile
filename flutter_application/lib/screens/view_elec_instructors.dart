import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ViewElecInstructors extends StatefulWidget {
  @override
  _ViewElecInstructorsState createState() => _ViewElecInstructorsState();
}

class _ViewElecInstructorsState extends State<ViewElecInstructors> {
  List<dynamic> instructors = [];
  Map<String, dynamic> users = {};
  dynamic user;

  @override
  void initState() {
    super.initState();
    getInstructors();
    getUser();
  }

  void getInstructors() async {
    try {
      final response =
          await http.get(Uri.parse("http://localhost:8080/api/users/"));
      if (response.statusCode == 200) {
        setState(() {
          instructors = json.decode(response.body);
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

  void getInstructor(String data) async {
    try {
      final response = await http
          .get(Uri.parse("http://localhost:8080/api/users/getOne/$data"));
      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        // Store user data in local storage
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('Instructor', json.encode(userData));

        setState(() {
          users = userData;
          Navigator.pushNamed(context, '/viewElecInstructorPage');
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
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 11, 182, 229),
        title: Text(
          user['fullName'] ?? '',
          style: const TextStyle(fontSize: 16),
        ),
      ),
      body: ListView.builder(
        itemCount: instructors.length,
        itemBuilder: (BuildContext context, int index) {
          final item = instructors[index];
          if (item['role'] == 'Instructor' &&
              item['department'] ==
                  'Department of Electrical and Information Engineering') {
            return GestureDetector(
              onTap: () => getInstructor(item['email']),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          'https://media.licdn.com/dms/image/C5603AQHV1uGlMl9ViA/profile-displayphoto-shrink_800_800/0/1593104293459?e=1695859200&v=beta&t=b8-haKHKgiPRzuvgjzGHaXv_QkUXNjCyRprxkxNaAy4',
                        ),
                        radius: screenHeight * 0.13,
                      ),
                      SizedBox(height: 16),
                      Text(
                        item['fullName'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(item['email']),
                      ElevatedButton(
                        onPressed: () => getInstructor(item['email']),
                        child: Text('View Details'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }
}
