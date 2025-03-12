import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state_management/survey_provider.dart';
import '../models/question_model.dart';

class QuestionAnswerView extends StatelessWidget {
  const QuestionAnswerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SurveyProvider>(
      builder: (context, surveyProvider, child) {
        if (surveyProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (surveyProvider.questions.isEmpty) {
          return const Center(child: Text("No questions available"));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: surveyProvider.questions.length,
          itemBuilder: (context, index) {
            final Question question = surveyProvider.questions[index];
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Q${index + 1}: ${question.text}",
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: question.answers.map<Widget>((option) {
                        bool isSelected =
                            surveyProvider.responses[question.id] ==
                                option.text;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  isSelected ? Colors.amber : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 3,
                            ),
                            onPressed: () {
                              surveyProvider.selectAnswer(
                                  question.id, option.answerBangla);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Text(
                                option.answerBangla,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: isSelected
                                        ? Colors.black
                                        : Colors.green),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
