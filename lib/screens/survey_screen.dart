/*import 'package:flutter/material.dart';
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
}*/
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
            appBar: AppBar(
              title: const Text(
                "Survey Questions",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                  fontFamily: 'LexendDeca',
                ),
              ),
              backgroundColor: const Color.fromARGB(255, 9, 12, 82),
            ),
            body: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: provider.surveyQuestions.length,
              itemBuilder: (context, index) {
                var question = provider.surveyQuestions[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Q${index + 1}: ${question.questionName}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: 'LexendDeca',
                          ),
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<int>(
                          value: provider.responses[question.id],
                          onChanged: (value) =>
                              provider.saveResponse(question.id, value),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          items: question.answers
                              .map(
                                (option) => DropdownMenuItem<int>(
                                  value: option.id,
                                  child: Text(
                                    option.answerBangla,
                                    style: const TextStyle(
                                      fontFamily: 'LexendDeca',
                                      color: Color.fromARGB(255, 65, 122, 84),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                // Submit responses
              },
              backgroundColor: Colors.green.shade800,
              child: const Icon(Icons.send, color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}
