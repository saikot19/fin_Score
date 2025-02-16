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
        title: const Text("Score Summary"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 1, 16, 43)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Total Score: $totalScore",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              "Responses:",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: responses.length,
                itemBuilder: (context, index) {
                  final questionId = responses.keys.elementAt(index);
                  final response = responses[questionId];
                  return ListTile(
                    title: Text("Question $questionId: $response"),
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
