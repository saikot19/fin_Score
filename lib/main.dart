import 'package:finscore/screens/splash_login_screen.dart';
import 'package:finscore/screens/survey_screen.dart';
import 'package:finscore/screens/dashboard_screen.dart';
import 'package:finscore/screens/profile_screen.dart';
import 'package:finscore/state_management/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: const Color.fromARGB(255, 5, 9, 34),
          scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255)),
      initialRoute: '/splashlogin', // Starts with Splash-Login merged screen
      routes: {
        '/splashlogin': (context) =>
            const SplashLoginScreen(), // Updated screen

        '/dashboard': (context) => DashboardScreen(),
        '/profile': (context) => ProfileScreen(),
        '/form': (context) => FormScreen(),
      },
    );
  }
}
