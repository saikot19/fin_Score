import 'dart:convert';
import 'package:finscore/models/survey_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class SurveyService {
  final String apiUrl = 'http://4.194.252.166/credit-scroring/api/v1/questions';

  Future<List<Question>> fetchSurvey() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      var questionsList = jsonData['data']['questions'] as List;
      List<Question> questions =
          questionsList.map((i) => Question.fromJson(i)).toList();

      // Store the survey data locally
      await storeSurveyLocally(questions);

      return questions;
    } else {
      throw Exception('Failed to load survey');
    }
  }

  Future<void> storeSurveyLocally(List<Question> questions) async {
    final prefs = await SharedPreferences.getInstance();
    String encodedData = jsonEncode(questions.map((q) => q.toJson()).toList());
    await prefs.setString('surveyData', encodedData);
  }

  Future<List<Question>?> loadSurveyFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    String? encodedData = prefs.getString('surveyData');

    if (encodedData != null) {
      List<dynamic> jsonData = jsonDecode(encodedData);
      List<Question> questions =
          jsonData.map((i) => Question.fromJson(i)).toList();
      return questions;
    } else {
      return null;
    }
  }
}
