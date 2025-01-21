// Packages
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onInitializationComplete;

  const SplashScreen({
    super.key,
    required this.onInitializationComplete,
  });

  @override
  State<StatefulWidget> createState() {
    return _SplashPageState();
  }
}

class _SplashPageState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      widget.onInitializationComplete();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Finscore",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white, // Standard white background
      ),
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              const Spacer(), // Push content to the top
              // App Logo
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/logo/finscore.jpeg'),
                  ),
                ),
              ),
              const SizedBox(height: 20), // Spacer between logo and text
              const Spacer(), // Push content below the logo upwards
              // Version Text at the Bottom
              const Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: Text(
                  "V.1.0.1",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Black text for readability
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
