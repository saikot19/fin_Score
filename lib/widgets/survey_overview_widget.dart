import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state_management/survey_provider.dart';
import 'survey_card_widget.dart'; // Import SurveyCard
import '../screens/survey_list_screen.dart'; // Import SurveyListScreen

class SurveyOverviewWidget extends StatelessWidget {
  const SurveyOverviewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final surveyProvider = Provider.of<SurveyProvider>(context);
    final surveys = surveyProvider.surveys;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SurveyListScreen(),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100.0),
        ),
        elevation: 5,
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(255, 44, 104, 67),
                const Color.fromARGB(255, 2, 20, 29)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Survey Overview",
                  style: TextStyle(
                    fontFamily: 'LexendDeca',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Total Surveys: ${surveys.length}",
                  style: TextStyle(
                    fontFamily: 'LexendDeca',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
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
      body: surveyProvider.surveys.isNotEmpty
          ? ListView.builder(
              itemCount: surveyProvider.surveys.length,
              itemBuilder: (context, index) {
                final survey = surveyProvider.surveys[index];
                return SurveyCard(
                  survey: survey,
                  index: index + 1,
                );
              },
            )
          : const Center(
              child: Text(
                "No surveys available.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
    );
  }
}
