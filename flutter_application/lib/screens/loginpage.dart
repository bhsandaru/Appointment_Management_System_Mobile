import 'dart:html';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool hidePassword = true;

  void getUser(BuildContext context, String email) async {
    try {
      // Show loading indicator if necessary
      final response = await http
          .get(Uri.parse('${AppConfig.apiUrl}/api/users/getOne/${email}'));

      // Hide loading indicator if necessary

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final user = data['User'];

        if (user != null) {
          // Store user data in local storage
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('User', jsonEncode(user));

          // Handle the retrieved user data
        } else {
          throw Exception('User data is null or invalid');
        }
      } else if (response.statusCode == 404) {
        throw Exception('User not found');
      } else {
        throw Exception('Failed to get user: ${response.statusCode}');
      }
    } catch (error) {
      print(error);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred')),
      );
    }
  }

  String userEmail = '';

  void handleSubmit(BuildContext context) async {
    try {
      final url = Uri.parse('${AppConfig.apiUrl}/api/auth');
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        'email': emailController.text,
        'password': passwordController.text,
      });

      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['data'];
        // Store the token
        //getUser(context, emailController);
        // Navigate to the home page
        Navigator.pushReplacementNamed(context, '/lechome');
      } else {
        throw Exception('Failed to log in');
      }
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Color.fromARGB(255, 11, 182, 229),
              Color.fromARGB(255, 17, 209, 226),
              Color.fromARGB(255, 2, 109, 106),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 80),
            Container(
              padding: const EdgeInsets.all(20),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Text(
                      "Appointment Management System",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Text(
                      "Faculty of Engineering",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 60),
                      TextFormField(
                        controller: emailController,
                        onChanged: (value) {
                          setState(() {
                            userEmail = value;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: const TextStyle(color: Colors.grey),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.cyan),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: passwordController,
                        obscureText: hidePassword,
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: const TextStyle(color: Colors.grey),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.cyan),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                hidePassword = !hidePassword;
                              });
                            },
                            color: const Color.fromARGB(255, 4, 46, 119)
                                .withOpacity(0.7),
                            icon: Icon(
                              hidePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () => {
                          handleSubmit(context),
                          getUser(context, userEmail)
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.cyan[500],
                          padding: const EdgeInsets.symmetric(
                              horizontal: 80, vertical: 25),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text("Login"),
                      ),
                      const SizedBox(height: 20),
                      // Add a Text widget to display the error message
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// class LoginPage extends StatelessWidget {
//   LoginPage({Key? key}) : super(key: key);

//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   void getUser(BuildContext context) async {
//     try {
//       final response = await http.get(Uri.parse(
//           '${AppConfig.apiUrl}/api/users/getOne/${emailController.text}'));
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         final user = data['user'];
//         // Handle the retrieved user data
//       } else {
//         throw Exception('Failed to get user');
//       }
//     } catch (error) {
//       print(error);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('An error occurred')),
//       );
//     }
//   }

//   void handleSubmit(BuildContext context) async {
//     try {
//       const url = '${AppConfig.apiUrl}/api/auth';
//       final response = await http.post(Uri.parse(url), body: {
//         'email': emailController.text,
//         'password': passwordController.text,
//       });
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         final token = data['data'];
//         // Store the token
//         getUser(context);
//         // Navigate to the home page
//         Navigator.pushReplacementNamed(context, '/lechome');
//       } else {
//         throw Exception('Failed to log in');
//       }
//     } catch (error) {
//       print(error);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('An error occurred')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             colors: [
//               Color.fromARGB(255, 11, 182, 229),
//               Color.fromARGB(255, 17, 209, 226),
//               Color.fromARGB(255, 2, 109, 106),
//             ],
//           ),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             const SizedBox(height: 80),
//             Container(
//               padding: const EdgeInsets.all(20),
//               child: const Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Center(
//                     child: Text(
//                       "Appointment Management System",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 30,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   Center(
//                     child: Text(
//                       "Faculty of Engineering",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: Container(
//                 decoration: const BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(60),
//                     topRight: Radius.circular(60),
//                   ),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(30),
//                   child: Column(
//                     children: <Widget>[
//                       const SizedBox(height: 60),
//                       TextFormField(
//                         controller: emailController,
//                         decoration: InputDecoration(
//                           labelText: "Email",
//                           labelStyle: const TextStyle(color: Colors.grey),
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: const BorderSide(color: Colors.grey),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: const BorderSide(color: Colors.cyan),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       TextFormField(
//                         controller: passwordController,
//                         obscureText: true,
//                         decoration: InputDecoration(
//                           labelText: "Password",
//                           labelStyle: const TextStyle(color: Colors.grey),
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: const BorderSide(color: Colors.grey),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: const BorderSide(color: Colors.cyan),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 30),
//                       ElevatedButton(
//                         onPressed: () => handleSubmit(context),
//                         style: ElevatedButton.styleFrom(
//                           foregroundColor: Colors.white,
//                           backgroundColor: Colors.cyan[500],
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 80, vertical: 25),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                         ),
//                         child: const Text("Login"),
//                       ),
//                       const SizedBox(height: 20),
//                       Text(
//                         "error",
//                         style: TextStyle(color: Colors.red),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
