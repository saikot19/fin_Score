import 'package:finscore/screens/splash_screen.dart';
import 'package:finscore/screens/survey_screen.dart';
import 'package:finscore/state_management/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'screens/form_screen.dart'; // Added login form screen
import 'state_management/survey_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(
            create: (_) => SurveyProvider()), // ✅ Global Provider
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Survey App',
      initialRoute: '/splash', // Starts with SplashScreen
      routes: {
        '/splash': (context) => const SplashScreen(), // Corrected constructor
        '/login': (context) => LoginScreen(), // Login screen
        '/form': (context) => FormScreen(),
      },
    );
  }
}
