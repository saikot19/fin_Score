import 'package:finscore/screens/components/sign_in_form.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api/auth_service.dart';
import 'screens/splash_screen.dart'; // Import SplashScreen
// Import SignInScreen
import '../screens/survey_page.dart'; // Adjust path if needed

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized
  await SharedPreferences.getInstance(); // Initialize SharedPreferences
  final authService = AuthService(); // Initialize AuthService
  final isLoggedIn =
      await authService.isLoggedIn(); // Check if the user is logged in
  runApp(
      FinScoreApp(isLoggedIn: isLoggedIn)); // Pass the login state to the app
}

class FinScoreApp extends StatelessWidget {
  final bool isLoggedIn;

  const FinScoreApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FinScore',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF4CAF50),
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(
          displayLarge: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          bodyLarge: TextStyle(fontSize: 16, color: Colors.white),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4CAF50),
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      home:
          SplashScreen(isLoggedIn: isLoggedIn), // Navigate based on login state
      routes: {
        '/signin': (context) => SignInForm(), // Route for SignInScreen
        '/survey': (context) => SurveyPage(), // Route for SurveyPage
      },
    );
  }
}
