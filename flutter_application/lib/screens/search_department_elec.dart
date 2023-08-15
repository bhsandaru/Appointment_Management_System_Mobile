import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'view_elec_lecturers.dart';
import 'view_elec_instructors.dart';

import 'view_lecture_page.dart'; // Make sure to import the correct path to the ViewLecturerPage


class SearchDepartmentElec extends StatefulWidget {
  const SearchDepartmentElec({Key? key}) : super(key: key);

  @override
  _SearchDepartmentElecState createState() => _SearchDepartmentElecState();
}

class _SearchDepartmentElecState extends State<SearchDepartmentElec>
    with SingleTickerProviderStateMixin {
  dynamic user; // Declaring user as a global variable
  late AnimationController _animationController;
  late Animation<Color?> _buttonColorAnimation;
  bool _isButtonHighlighted = false;
  bool _showSearchBar = false;

  List<Map<String, dynamic>> lecturerData = [
    // Your existing lecturer data here
     {
      'fullName': 'Dr. Thilina Weerasinghe',
      'email': 'john.doe@example.com',
      'imageURL':
          'https://media.licdn.com/dms/image/C5603AQHV1uGlMl9ViA/profile-displayphoto-shrink_800_800/0/1593104293459?e=1695859200&v=beta&t=b8-haKHKgiPRzuvgjzGHaXv_QkUXNjCyRprxkxNaAy4',
    },
    {
      'fullName': 'Dr.Kushan Sudheera',
      'email': 'jane.smith@example.com',
      'imageURL':
          'https://media.licdn.com/dms/image/C5103AQGpB_533scU9A/profile-displayphoto-shrink_800_800/0/1530624791993?e=1695859200&v=beta&t=MgAenqrNTNfpWUGsLCPkgZl0po25AFKAfbfTCLYtbg0',
    },
    {
      'fullName': 'Mr.Manuj Wejeyrathne',
      'email': 'jane.smith@example.com',
      'imageURL':
          'https://media.licdn.com/dms/image/C5603AQG5yoaNkgRp0A/profile-displayphoto-shrink_800_800/0/1637057801674?e=1695859200&v=beta&t=yRNAd6_HE60sG0zC17wLF3MjenLSoNwUer36nzJyNSQ',
    },
    {
      'fullName': 'Dr. Jane Smith',
      'email': 'jane.smith@example.com',
      'imageURL':
          'https://media.licdn.com/dms/image/C5103AQGpB_533scU9A/profile-displayphoto-shrink_800_800/0/1530624791993?e=1695859200&v=beta&t=MgAenqrNTNfpWUGsLCPkgZl0po25AFKAfbfTCLYtbg0',
    },
    // Add more lecturer data here
  ];

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    getUser();

    // Initialize the animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Create the button color animation
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
        print(user);
      });
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
        _navigateToViewElecLecturer();
      } else if (index == 1) {
        _navigateToPage2();
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
        backgroundColor: Colors.cyan[700], // Use the same app bar color as in LoginPage
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
        actions: [
          IconButton(
            onPressed: _toggleSearchBar, // Toggle the search bar
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: Colors.cyan[700], // Use the same color for the top section as in LoginPage
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Department of Electrical and Information Engineering',
                      style: TextStyle(fontSize: 18, color: Colors.white), // Use white text color
                    ),
                  ),
                  IconButton(
                    onPressed: _toggleSearchBar, // Toggle the search bar
                    icon: Icon(Icons.search),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.cyan[700], // Use the same color for the button section as in LoginPage
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
                          : Colors.cyan[500],
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
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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
                          ? Colors.cyan[500]
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
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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
                  hintText: 'Search Lecturers',
                  suffixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  // Implement the search functionality here
                },
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: lecturerData.length,
              itemBuilder: (context, index) {
                final lecturer = lecturerData[index];
                return Card(
                  child: SizedBox(
                    width: 250,
                    height: 300,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 8),
                        CircleAvatar(
                          radius: 100, // Adjust the radius to your preference
                          backgroundImage: NetworkImage(lecturer['imageURL']),
                        ),
                        ListTile(
                          title: Text(
                            lecturer['fullName'],
                            textAlign: TextAlign.center,
                          ),
                          subtitle: Text(
                            lecturer['email'],
                            textAlign: TextAlign.center,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Handle view details button click
                          },
                          child: Text('View Details'),
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
      bottomNavigationBar: BottomNavigationBar(
         items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home Page',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
        backgroundColor: Colors.cyan[700],
      ),
    );
  }

  void _navigateToViewElecLecturer() {
    Navigator.pushNamed(context, '/viewElecLecturer');
  }

  void _navigateToPage2() {
    Navigator.pushNamed(context, '/viewElecInstructor');
  }




}
