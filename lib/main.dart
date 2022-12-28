import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/homepage.dart';
import 'package:flutter_application_1/pages/login_screen.dart';
import 'package:flutter_application_1/pages/signup_screen.dart';
import 'package:flutter_application_1/pages/splash_screen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    routes: {
      '/': (context) => SplashScreen(),
      // '/': (context) => MyApp(),
      '/login': (context) => LoginScreen(),
      '/register': (context) => SignUpScreen(),
      '/homepage': (context) => HomePage(),
    },
  ));
}
