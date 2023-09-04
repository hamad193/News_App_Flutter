import 'package:flutter/material.dart';
import 'package:news_app/ui/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NEWS',
      theme: ThemeData(
        primaryColor: Colors.white, // AppBar background color
        scaffoldBackgroundColor:
            Colors.white, // Background color for all screens
        appBarTheme: const AppBarTheme(
          color: Colors.white, // AppBar background color
          iconTheme: IconThemeData(color: Colors.black), // AppBar icon color
          titleTextStyle: TextStyle(color: Colors.black),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
