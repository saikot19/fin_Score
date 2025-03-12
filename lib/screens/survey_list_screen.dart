import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../widgets/survey_card_widget.dart';
import '../state_management/survey_provider.dart';
import 'form_screen.dart';

class SurveyListScreen extends StatelessWidget {
  const SurveyListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final surveyProvider = Provider.of<SurveyProvider>(context);
    final surveys = surveyProvider.surveys;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Survey List",
          style: GoogleFonts.lexendDeca(
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 255, 255, 255)),
        ),
        backgroundColor: const Color.fromARGB(255, 1, 16, 43),
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 153, 182, 160),
        ),
      ),
      body: surveys.isNotEmpty
          ? RefreshIndicator(
              onRefresh: () async {
                await surveyProvider.fetchSurveys();
              },
              child: ListView.builder(
                itemCount: surveys.length,
                itemBuilder: (context, index) {
                  final survey = surveys[index];
                  return SurveyCard(
                    survey: survey,
                    index: index + 1, // SL No
                  );
                },
              ),
            )
          : const Center(
              child: Text(
                "No completed surveys available.",
                style: TextStyle(fontSize: 16),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FormScreen()),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 20, 92, 37),
      ),
    );
  }
}
