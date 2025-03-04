import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state_management/survey_provider.dart';
import 'survey_card_widget.dart'; // Import SurveyCard

class SurveyOverviewWidget extends StatelessWidget {
  const SurveyOverviewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final surveyProvider = Provider.of<SurveyProvider>(context);
    final surveys = surveyProvider.surveys;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Survey Overview",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            surveys.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: surveys.length,
                    itemBuilder: (context, index) {
                      final survey = surveys[index];
                      return SurveyCard(
                        survey: survey,
                        index: index + 1,
                      );
                    },
                  )
                : const Center(
                    child: Text(
                      "No completed surveys available.",
                      style: TextStyle(fontSize: 16),
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
        backgroundColor: const Color.fromARGB(255, 1, 16, 43),
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
