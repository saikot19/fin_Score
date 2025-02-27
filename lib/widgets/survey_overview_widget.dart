import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state_management/survey_provider.dart';
import 'survey_card_widget.dart';

class SurveyOverviewWidget extends StatelessWidget {
  const SurveyOverviewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final surveyProvider = Provider.of<SurveyProvider>(context);
    final totalSurveys = surveyProvider.surveys.length;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SurveyListScreen(),
          ),
        );
      },
      child: CircleAvatar(
        radius: 50,
        backgroundColor: const Color.fromARGB(255, 209, 238, 216),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "$totalSurveys",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const Text(
              "Surveys",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SurveyListScreen extends StatelessWidget {
  const SurveyListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final surveyProvider = Provider.of<SurveyProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("All Surveys"),
      ),
      body: ListView.builder(
        itemCount: surveyProvider.surveys.length,
        itemBuilder: (context, index) {
          final survey = surveyProvider.surveys[index];
          return SurveyCard(
            survey: survey,
            index: index + 1,
          );
        },
      ),
    );
  }
}
