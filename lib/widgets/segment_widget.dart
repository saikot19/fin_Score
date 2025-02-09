import 'package:flutter/material.dart';
import '../models/question_model.dart';

class SegmentWidget extends StatelessWidget {
  final Question question;

  SegmentWidget({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(question.questionName),
          ...question.answers.map((answer) {
            return ListTile(
              title: Text(answer.answerBangla),
              onTap: () {
                // Handle answer selection
              },
            );
          }).toList(),
        ],
      ),
    );
  }
}
