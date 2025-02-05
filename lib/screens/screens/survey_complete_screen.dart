import 'package:flutter/material.dart';

class SurveyCompleteScreen extends StatelessWidget {
  const SurveyCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Survey Complete'),
      ),
      body: const Center(
        child: Text(
          'Thank you for completing the survey!',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
