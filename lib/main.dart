import 'package:finscore/screens/splash_login_screen.dart';
import 'package:finscore/screens/survey_screen.dart';
import 'package:finscore/screens/dashboard_screen.dart';
import 'package:finscore/screens/profile_screen.dart';
import 'package:finscore/screens/form_screen.dart';
import 'package:finscore/screens/score_summary_screen.dart'; // Added score summary screen
import 'package:finscore/state_management/user_provider.dart';
import 'package:finscore/state_management/survey_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color.fromARGB(255, 5, 9, 34),
        scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      initialRoute: '/splashlogin', // Starts with Splash-Login merged screen
      onGenerateRoute: (settings) {
        if (settings.name == '/dashboard') {
          final args = settings.arguments as Map<String, String>;
          return MaterialPageRoute(
            builder: (context) {
              return DashboardScreen(
                email: args['email']!,
                password: args['password']!,
              );
            },
          );
        }
        // Add other routes here if needed
        return null;
      },
      routes: {
        '/splashlogin': (context) =>
            const SplashLoginScreen(), // Updated screen
        '/profile': (context) => ProfileScreen(),
        '/form': (context) => FormScreen(),
        '/score_summary': (context) =>
            const ScoreSummaryScreen(), // New route for score summary screen
      },
    );
  }
}
