import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state_management/survey_provider.dart';

class SurveyScreen extends StatelessWidget {
  final String memberId;
  final int branchId;
  final double loanAmount;

  const SurveyScreen({
    super.key,
    required this.memberId,
    required this.branchId,
    required this.loanAmount,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SurveyProvider()..fetchSurveyQuestions(),
      child: Consumer<SurveyProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.surveyQuestions.isEmpty) {
            return const Center(child: Text("No questions available"));
          }

          return Scaffold(
            appBar: AppBar(title: const Text("Survey Questions")),
            body: ListView.builder(
              itemCount: provider.surveyQuestions.length,
              itemBuilder: (context, index) {
                var question = provider.surveyQuestions[index];
                return ListTile(
                  title: Text(question.questionName),
                  subtitle: DropdownButton<int>(
                    value: provider.responses[question.id],
                    onChanged: (value) =>
                        provider.saveResponse(question.id, value),
                    items: question.answers
                        .map((option) => DropdownMenuItem<int>(
                              value: option.id,
                              child: Text(option.answerBangla),
                            ))
                        .toList(),
                  ),
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                // Submit responses
              },
              child: const Icon(Icons.send),
            ),
          );
        },
      ),
    );
  }
}
