import 'package:flutter/material.dart';
import '../config.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Text(
              "Appointment Management System",
              style: TextStyle(color: Colors.white, fontSize: 30),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              "Faculty of Engineering",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          )
        ],
      ),
    );
  }
}
