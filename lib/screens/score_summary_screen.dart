import 'package:flutter/material.dart';

class ScoreSummaryScreen extends StatelessWidget {
  final int totalScore;
  final Map<int, int> responses;

  const ScoreSummaryScreen({
    Key? key,
    required this.totalScore,
    required this.responses,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Survey Summary"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Thank you! The survey is successfully submitted.",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              "Total Score: $totalScore",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              "Responses:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: responses.length,
                itemBuilder: (context, index) {
                  final questionId = responses.keys.elementAt(index);
                  final answerId = responses.values.elementAt(index);
                  return ListTile(
                    title: Text("Question ID: $questionId"),
                    subtitle: Text("Answer ID: $answerId"),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
