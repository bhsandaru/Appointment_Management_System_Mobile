import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SearchDepartment extends StatefulWidget {
  const SearchDepartment({Key? key}) : super(key: key);

  @override
  _SearchDepartmentState createState() => _SearchDepartmentState();
}

class _SearchDepartmentState extends State<SearchDepartment>
    with SingleTickerProviderStateMixin {
  dynamic user; // Declaring user as a global variable
  late AnimationController _animationController;
  late Animation<Color?> _buttonColorAnimation;
  bool _isButtonHighlighted = false;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan[700],
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
      body: Padding(
        padding: const EdgeInsets.only(top: 35),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Chip(
                label: const Text(
                  'Departments',
                  style: TextStyle(fontSize: 16),
                ),
                backgroundColor: Colors.cyan[500],
                labelStyle: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 50), // Adding a 50px gap

            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/page1');
                      },
                      onHighlightChanged: (isHighlighted) {
                        setState(() {
                          _isButtonHighlighted = isHighlighted;
                          if (isHighlighted) {
                            _startButtonAnimation();
                          } else {
                            _stopButtonAnimation();
                          }
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: _isButtonHighlighted
                              ? _buttonColorAnimation.value
                              : Colors.cyan[500],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: const Text(
                          'Department of Civil and Environmental Engineering',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/searchDepartmentElec');
                      },
                      onHighlightChanged: (isHighlighted) {
                        setState(() {
                          _isButtonHighlighted = isHighlighted;
                          if (isHighlighted) {
                            _startButtonAnimation();
                          } else {
                            _stopButtonAnimation();
                          }
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: _isButtonHighlighted
                              ? _buttonColorAnimation.value
                              : Colors.cyan[500],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: const Text(
                          'Department of Electrical and Environmental Engineering',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/page3');
                      },
                      onHighlightChanged: (isHighlighted) {
                        setState(() {
                          _isButtonHighlighted = isHighlighted;
                          if (isHighlighted) {
                            _startButtonAnimation();
                          } else {
                            _stopButtonAnimation();
                          }
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: _isButtonHighlighted
                              ? _buttonColorAnimation.value
                              : Colors.cyan[500],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: const Text(
                          'Department of Mechanical and Manufacturing Engineering',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
