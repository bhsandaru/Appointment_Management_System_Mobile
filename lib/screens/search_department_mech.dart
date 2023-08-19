import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';
//import '../navigationBar.dart'; // Import the NavigationBar widget

class SearchDepartmentMech extends StatefulWidget {
  const SearchDepartmentMech({Key? key}) : super(key: key);

  @override
  _SearchDepartmentMechState createState() => _SearchDepartmentMechState();
}

class _SearchDepartmentMechState extends State<SearchDepartmentMech>
    with SingleTickerProviderStateMixin {
  List<dynamic> lec = [];
  Map<String, dynamic> users = {};
  dynamic user; // Declaring user as a global variable
  late AnimationController _animationController;
  late Animation<Color?> _buttonColorAnimation;
  bool _isButtonHighlighted = false;
  bool _showSearchBar = false;

  int _selectedIndex = 0;
  int pageshift = 0;
  int state = 0;

  @override
  void initState() {
    super.initState();
    getUsers();
    getUser();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _buttonColorAnimation = ColorTween(
      begin: Colors.cyan[500],
      end: Colors.cyan[700],
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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

  void getUsers() async {
    try {
      final response =
          await http.get(Uri.parse("${AppConfig.apiUrl}/api/users/"));
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

  void getLec(String data, int page) async {
    try {
      final response = await http
          .get(Uri.parse("${AppConfig.apiUrl}/api/users/getOne/$data"));
      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('Lec', json.encode(userData));

        setState(() {
          users = userData;
          if (page == 0) {}
          if (page == 1) {
            Navigator.pushNamed(context, '/viewLecturerPage');
          }
          if (page == 2) {
            Navigator.pushNamed(context, '/calendar');
          }
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

  void _startButtonAnimation() {
    _animationController.forward();
  }

  void _stopButtonAnimation() {
    _animationController.reverse();
  }

  void _toggleSearchBar() {
    setState(() {
      _showSearchBar = !_showSearchBar;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        state = 0;
      } else if (index == 1) {
        state = 1;
      } else if (index == 2) {
        // Handle navigation to the home page
        // For example, Navigator.pushNamed(context, '/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 38, 118, 140),
        title: Text(
          user != null ? user['fullName'] : '',
          style: const TextStyle(fontSize: 16),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: const Color.fromARGB(255, 177, 212, 219),
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Department of Mechanical and Manufacturing Engineering',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 12, 8, 8),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _toggleSearchBar,
                    icon: Icon(Icons.search),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: const Color.fromARGB(255, 177, 212, 219),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isButtonHighlighted = true;
                      });
                      _onItemTapped(0);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: _isButtonHighlighted
                          ? _buttonColorAnimation.value
                          : const Color.fromARGB(255, 177, 212, 219),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      'Lecturers',
                      style: TextStyle(
                        color: Color.fromARGB(255, 11, 10, 10),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isButtonHighlighted = false;
                      });
                      _onItemTapped(1);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: _isButtonHighlighted
                          ? const Color.fromARGB(255, 177, 212, 219)
                          : _buttonColorAnimation.value,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      'Instructors',
                      style: TextStyle(
                        color: Color.fromARGB(255, 16, 12, 12),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_showSearchBar)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  suffixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  // Implement the search functionality here
                },
              ),
            ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: lec.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = lec[index];
                      if (item['role'] == 'Lecturer' &&
                          item['department'] ==
                              'Department of Mechanical and Manufacturing Engineering' &&
                          state == 0) {
                        return GestureDetector(
                          onTap: () => getLec(item['email'], 0),
                          child: SizedBox(
                            width: 250,
                            height: 380, // Increased card height
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 8),
                                CircleAvatar(
                                  radius: 100,
                                  backgroundImage:
                                      NetworkImage(item['userimage']),
                                ),
                                ListTile(
                                  title: Text(
                                    item['fullName'],
                                    textAlign: TextAlign.center,
                                  ),
                                  subtitle: Text(
                                    item['email'],
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: ElevatedButton(
                                        onPressed: () =>
                                            getLec(item['email'], 1),
                                        child: const Text('View Details'),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Flexible(
                                      child: ElevatedButton(
                                        onPressed: () =>
                                            getLec(item['email'], 2),
                                        child: const Text('Add Appointment'),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      if (item['role'] == 'Instructor' &&
                          item['department'] ==
                              'Department of Mechanical and Manufacturing Engineering' &&
                          state == 1) {
                        return GestureDetector(
                          onTap: () => getLec(item['email'], 0),
                          child: SizedBox(
                            width: 250,
                            height: 380, // Increased card height
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 8),
                                CircleAvatar(
                                  radius: 100,
                                  backgroundImage:
                                      NetworkImage(item['userimage']),
                                ),
                                ListTile(
                                  title: Text(
                                    item['fullName'],
                                    textAlign: TextAlign.center,
                                  ),
                                  subtitle: Text(
                                    item['email'],
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: ElevatedButton(
                                        onPressed: () =>
                                            getLec(item['email'], 1),
                                        child: const Text('View Details'),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Flexible(
                                      child: ElevatedButton(
                                        onPressed: () =>
                                            getLec(item['email'], 2),
                                        child: const Text('Add Appointment'),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
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

  // ... Rest of your methods remain the same
}
