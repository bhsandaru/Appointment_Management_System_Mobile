import 'package:flutter/material.dart';
import 'package:flutter_application/screens/history_page.dart';
import 'package:flutter_application/screens/notification_page.dart';
import 'screens/LectureHome.dart';
import 'screens/LoginPage.dart';
import 'screens/search_department_elec.dart';
import 'screens/search_department.dart';
import 'screens/view_elec_lecturers.dart';
import 'screens/view_lecture_page.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'screens/view_elec_instructors.dart';
import 'package:flutter_application/screens/event_calendar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final TextEditingController _textController = TextEditingController();
  MyApp({super.key});

  void sendMessage(String message) {
    print(message);
    WebSocketChannel channel;
    try {
      channel = WebSocketChannel.connect(Uri.parse('ws://localhost:8080'));
    } catch (e) {
      print(e);
    }
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove the debug banner
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/lechome': (context) => const LectureHome(),
        '/calendar': (context) => EventCalendarScreen(),
        '/searchDepartment': (context) => const SearchDepartment(),
        '/searchDepartmentElec': (context) => const SearchDepartmentElec(),
        '/viewElecLecturer': (context) => ViewElecLecturer(),
        '/viewLecturerPage': (context) => ViewLecturerPage(),
        '/viewElecInstructor': (context) => ViewElecInstructor(),
        '/notificationPage': (context) => NotificationPage(),
        '/historyPage': (context) => HistoryPage(),
      },
    );
  }
}
