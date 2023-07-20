// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Faculty of Engineering-Appointment Management System',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF13C1DC)),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(title: 'University of Ruhuna'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     final ButtonStyle style = TextButton.styleFrom(
//       foregroundColor: Theme.of(context).colorScheme.onPrimary,
//     );
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(
//           widget.title,
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 21, // Set the text color to white
//           ),
//         ),
//         leading: Container(
//           padding:
//               const EdgeInsets.only(right: 8), // Adjust the padding as desired
//           child: Image.network(
//             "https://upload.wikimedia.org/wikipedia/en/6/65/LOGO_OF_RUHUNA.jpg",
//             width: 20,
//             height: 20,
//           ),
//         ),
//         actions: <Widget>[
//           Container(
//             padding: const EdgeInsets.only(left: 8),
//             child: TextButton(
//               style: style,
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => NewPage()),
//                 );
//               },
//               child: const Text('LogIn'),
//             ),
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.only(top: 10),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Container(
//                 padding: const EdgeInsets.only(bottom: 16),
//                 child: Text(
//                   "Appointment Management System - Faculty of Engineering",
//                   textAlign: TextAlign.center,
//                   style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                         fontSize: 14,
//                         // decoration: TextDecoration.combine([
//                         //   TextDecoration.underline,
//                         // ]),
//                         decorationColor: const Color.fromARGB(255, 19, 49, 94),
//                         decorationThickness: 3,
//                         textBaseline: TextBaseline.alphabetic,
//                         color: const Color.fromARGB(255, 19, 49, 94),
//                       ),
//                 ),
//               ),
//               Container(
//                 margin: const EdgeInsets.all(10), // Add margin around the image
//                 child: Image.network(
//                     'https://scontent.fcmb11-1.fna.fbcdn.net/v/t1.6435-9/48371852_1927523070888246_4299477295128641536_n.jpg?_nc_cat=111&ccb=1-7&_nc_sid=e3f864&_nc_ohc=Cn3jsWUmtk8AX9TzaQc&_nc_ht=scontent.fcmb11-1.fna&oh=00_AfBuSrpbM1cQxXHZzyw5zHF0MlrcErsCJuX4VqwH_ubwpA&oe=64AAE739',
//                     fit: BoxFit.contain),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
