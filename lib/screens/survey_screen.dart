import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/survey_provider.dart';
import '../widgets/survey_segment.dart';
// ignore: unused_import
import '../models/survey_segment_model.dart';

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({super.key});

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  get segmentmodel => null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final surveyProvider =
          Provider.of<SurveyProvider>(context, listen: false);
      surveyProvider.loadSurveyFromLocal().then((_) {
        if (surveyProvider.questions.isEmpty) {
          surveyProvider.fetchSurvey();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final surveyProvider = Provider.of<SurveyProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Survey Page')),
      body: surveyProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : surveyProvider.errorMessage.isNotEmpty
              ? Center(child: Text('Error: ${surveyProvider.errorMessage}'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    // Main Column
                    children: [
                      TextField(
                        decoration:
                            const InputDecoration(labelText: 'Member ID'),
                        onChanged: (value) => surveyProvider.setMemberId(value),
                      ),
                      TextField(
                        decoration:
                            const InputDecoration(labelText: 'Loan Amount'),
                        keyboardType: TextInputType.number,
                        onChanged: (value) =>
                            surveyProvider.setAppliedLoanAmount(
                                double.tryParse(value) ?? 0.0),
                      ),
                      TextField(
                        decoration: const InputDecoration(
                            labelText: 'Applying Date (YYYY-MM-DD)'),
                        onChanged: (value) =>
                            surveyProvider.setApplyingDate(value),
                      ),
                      const SizedBox(height: 20),

                      Expanded(
                        // Correct placement of Expanded
                        child: surveyProvider.surveySegments.isEmpty
                            ? const Center(
                                child: Text('No survey questions available.'))
                            : ListView.builder(
                                itemCount: surveyProvider.surveySegments.length,
                                itemBuilder: (context, index) {
                                  return SurveySegment(segment: segmentmodel);
                                },
                              ),
                      ), // End of Expanded

                      ElevatedButton(
                        // Next/Submit button
                        onPressed: () {
                          if (surveyProvider.currentSegment <
                              surveyProvider.surveySegments.length - 1) {
                            surveyProvider.nextSegment();
                          } else {
                            // Handle survey submission
                            print("Survey submitted!");
                            print("Member ID: ${surveyProvider.memberId}");
                            print(
                                "Loan Amount: ${surveyProvider.appliedLoanAmount}");
                            print(
                                "Applying Date: ${surveyProvider.applyingDate}");
                            print("Answers: ${surveyProvider.selectedAnswers}");
                          }
                        },
                        child: Text(surveyProvider.currentSegment <
                                surveyProvider.surveySegments.length - 1
                            ? 'Next'
                            : 'Submit'),
                      ),
                    ], // End of Main Column
                  ),
                ),
    );
  }
}
