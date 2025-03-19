import 'package:finscore/screens/splash_login_screen.dart';
import 'package:finscore/screens/survey_screen.dart';
import 'package:finscore/screens/dashboard_screen.dart';
import 'package:finscore/screens/profile_screen.dart';
import 'package:finscore/screens/form_screen.dart';
import 'package:finscore/screens/score_summary_screen.dart'; // Score summary screen
import 'package:finscore/state_management/user_provider.dart';
import 'package:finscore/state_management/survey_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Check login status before starting the app
  final bool isLoggedIn = await checkLoginStatus();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(
            create: (_) => SurveyProvider()), // ✅ Global Provider
      ],
      child: MyApp(isLoggedIn: isLoggedIn),
    ),
  );
}

// Function to check if the user is logged in
Future<bool> checkLoginStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isLoggedIn') ?? false;
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

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
      initialRoute: isLoggedIn
          ? '/dashboard'
          : '/splashlogin', // Redirects based on login status
      onGenerateRoute: (settings) {
        if (settings.name == '/dashboard') {
          final args = settings.arguments as Map<String, String>?;
          return MaterialPageRoute(
            builder: (context) {
              return DashboardScreen(
                email: args?['email'] ?? '',
                password: args?['password'] ?? '',
              );
            },
          );
        }
        return null;
      },
      routes: {
        '/splashlogin': (context) => const SplashLoginScreen(),
        '/profile': (context) => ProfileScreen(),
        '/form': (context) => FormScreen(),
        '/score_summary': (context) => const ScoreSummaryScreen(),
      },
    );
  }
}
