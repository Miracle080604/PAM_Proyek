import 'package:flutter/material.dart';
import 'package:itdel/Autentikasi/Login/login_screen.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     debugShowCheckedModeBanner: false, // This line removes the debug banner
      home: Scaffold(
        body: LoginScreen(), // Your root widget
      ),
    );
  }
}