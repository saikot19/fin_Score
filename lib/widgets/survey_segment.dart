import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/survey_provider.dart';

class SurveySegment extends StatelessWidget {
  final SurveySegment segment;

  const SurveySegment({super.key, required this.segment});

  String? get title => null;

  get questions => null;

  @override
  Widget build(BuildContext context) {
    final surveyProvider = Provider.of<SurveyProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 16.0),
          child: Text(
            segment.title ?? 'No Title',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        ...segment.questions.map((question) {
          return Card(
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    question.questionName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<int>(
                    decoration:
                        const InputDecoration(labelText: 'Select Answer'),
                    value: surveyProvider.getSelectedAnswer(question.id),
                    items: question.answers
                        .map((answer) => DropdownMenuItem<int>(
                              value: answer.id,
                              child: Text(answer.answerBangla),
                            ))
                        .toList(),
                    onChanged: (value) {
                      surveyProvider.submitAnswer(question.id, value);
                    },
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}
