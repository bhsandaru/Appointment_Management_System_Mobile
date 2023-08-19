import 'package:flutter/material.dart';
import '../config.dart';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 38, 118, 140),
        title: Text(
          'History',
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: ListView.builder(
              itemCount: 0, // Replace with the actual number of history items
              itemBuilder: (BuildContext context, int index) {
                // Replace with your history item card widgets
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('History Item Title'),
                        Text('History Item Details'),
                        // Add more history item details here
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
        backgroundColor: Color.fromARGB(255, 38, 118, 140),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.history, color: Colors.white),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.white),
            label: 'Home Page',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications, color: Colors.white),
            label: 'Notifications',
          ),
        ],
        onTap: (int index) {
          if (index == 1) {
            Navigator.pushNamed(context, '/lechome');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/notificationpage');
          }
          // Stay on the history page for index 0
        },
      ),
    );
  }
}
