// ignore_for_file: library_private_types_in_public_api

import 'package:finscore/api/survey_service.dart';
import 'package:finscore/models/survey_model.dart';
import 'package:flutter/material.dart';

class SurveyPage extends StatefulWidget {
  const SurveyPage({super.key});

  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  late Future<List<Question>> futureSurvey;
  final SurveyService surveyService = SurveyService();

  @override
  void initState() {
    super.initState();
    futureSurvey = loadSurvey();
  }

  Future<List<Question>> loadSurvey() async {
    // Try to load from local storage
    List<Question>? questions = await surveyService.loadSurveyFromLocal();

    if (questions != null) {
      return questions;
    } else {
      // If not available locally, fetch from API
      return await surveyService.fetchSurvey();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Survey Page'),
      ),
      body: FutureBuilder<List<Question>>(
        future: futureSurvey,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No survey questions available.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final question = snapshot.data![index];
                return ListTile(
                  title: Text(question.questionId.toString()),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: question.answers
                        .map((option) => Text(option.answerBangla))
                        .toList(),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
