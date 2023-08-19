import 'package:flutter/material.dart';
import '../config.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(
          255, 103, 198, 230), // Set the background color to dark blue
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(bottom: 0),
                child: Text(
                  "University of Ruhuna",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      decorationColor: const Color.fromARGB(255, 19, 49, 94),
                      decorationThickness: 3,
                      textBaseline: TextBaseline.alphabetic,
                      color: const Color.fromARGB(255, 251, 251, 251),
                      fontStyle: FontStyle.normal),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  "Faculty of Engineering",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      decorationColor: const Color.fromARGB(255, 19, 49, 94),
                      decorationThickness: 3,
                      textBaseline: TextBaseline.alphabetic,
                      color: const Color.fromARGB(255, 251, 251, 251),
                      fontStyle: FontStyle.normal),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: Image.network(
                  "https://upload.wikimedia.org/wikipedia/en/6/65/LOGO_OF_RUHUNA.jpg",
                  fit: BoxFit.contain,
                  width: 90,
                  height: 90,
//
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  "Appointment Management System",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        decorationColor: const Color.fromARGB(255, 19, 49, 94),
                        decorationThickness: 3,
                        textBaseline: TextBaseline.alphabetic,
                        color: const Color.fromARGB(255, 6, 42, 98),
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
