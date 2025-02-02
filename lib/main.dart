import 'package:finscore/screens/components/log_in_form.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api/auth_service.dart';
import 'screens/splash_screen.dart';
import '../screens/survey_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  final authService = AuthService();
  final isLoggedIn = await authService.isLoggedIn(); // Check if logged in
  runApp(FinScoreApp(isLoggedIn: isLoggedIn));
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
      home: SplashScreen(isLoggedIn: isLoggedIn),
      routes: {
        '/login': (context) => LogInForm(),
        '/survey': (context) => SurveyPage(),
      },
    );
  }
}
