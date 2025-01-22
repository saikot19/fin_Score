import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(FinScoreApp());
}

class FinScoreApp extends StatelessWidget {
  const FinScoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FinScore',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xFF4CAF50),
        scaffoldBackgroundColor: Colors.black,
        textTheme: TextTheme(
          displayLarge: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          bodyLarge: TextStyle(fontSize: 16, color: Colors.white),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF4CAF50),
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      home: SplashScreen(),
    );
  }
}
