// import 'package:flutter/material.dart';
// import 'package:flutter_application/screens/loginpage.dart';
// import 'package:flutter_application/screens/event_calendar.dart';

// class LectureHome extends StatelessWidget {
//   const LectureHome({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color.fromARGB(255, 11, 182, 229),
//         title: const Text(
//           'Appointment Management System',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 18,
//           ),
//         ),
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: <Widget>[
//             Container(
//               height: 100,
//               decoration: BoxDecoration(
//                 color: Color.fromARGB(255, 59, 184, 218),
//               ),
//               child: Center(
//                 child: Text(
//                   'Appointment Management System',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ),
//             ListTile(
//               title: Padding(
//                 padding: const EdgeInsets.only(left: 16),
//                 child: Text('View Calendar'),
//               ),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => EventCalendarScreen()),
//                 );
//               },
//             ),
//             ListTile(
//               title: Padding(
//                 padding: const EdgeInsets.only(left: 16),
//                 child: Text('Logout'),
//               ),
//               onTap: () {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => LoginPage()),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           width: double.infinity,
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               colors: [
//                 Color.fromARGB(255, 11, 182, 229),
//                 Color.fromARGB(255, 17, 209, 226),
//                 Color.fromARGB(255, 13, 209, 203),
//               ],
//             ),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               const SizedBox(height: 10),
//               Container(
//                 padding: const EdgeInsets.all(20),
//                 child: const Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Center(
//                       child: Text(
//                         "Faculty of Engineering",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 30,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                     Center(
//                       child: Text(
//                         "University of Ruhuna",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 15,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 decoration: const BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(60),
//                     topRight: Radius.circular(60),
//                   ),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.only(top: 10),
//                   child: Center(
//                     child: Container(
//                       width: 150,
//                       height: 150,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         border: Border.all(
//                           color: Colors.white,
//                           width: 2,
//                         ),
//                       ),
//                       child: ProfileImage(),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Scaffold.of(context).openDrawer();
//         },
//         child: Icon(Icons.menu),
//         backgroundColor: Color.fromARGB(255, 224, 235, 238),
//       ),
//     );
//   }
// }

// class ProfileImage extends StatefulWidget {
//   @override
//   _ProfileImageState createState() => _ProfileImageState();
// }

// class _ProfileImageState extends State<ProfileImage>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _animation;

//   @override
//   void initState() {
//     super.initState();

//     // Create the animation controller
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     );

//     // Create the animation
//     _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _animationController,
//         curve: Curves.easeInOut,
//       ),
//     );

//     // Start the animation
//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _animationController,
//       builder: (BuildContext context, Widget? child) {
//         return ClipRRect(
//           borderRadius: BorderRadius.circular(75),
//           child: Container(
//             color: Colors.white.withOpacity(_animation.value),
//             child: Image.asset(
//               'images/default_profile.jpg',
//               fit: BoxFit.cover,
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
