import 'package:flutter/material.dart';
import '../models/question_model.dart';
import '../services/api_service.dart';

class SurveyProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Question> _surveyQuestions = [];
  Map<int, String> _responses =
      {}; // Stores responses as (questionId -> selected option)
  bool _isLoading = false;

  List<Question> get questions => _surveyQuestions;
  Map<int, String> get responses => _responses;
  bool get isLoading => _isLoading;

  Future<void> fetchSurveyQuestions(int segmentId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final rawQuestions = await _apiService.fetchSurveyQuestions(segmentId);
      debugPrint("Fetched Questions for Segment $segmentId: $rawQuestions");

      // Ensure _surveyQuestions is always a valid list
      _surveyQuestions = rawQuestions.isNotEmpty
          ? rawQuestions.map((q) => Question.fromJson(q)).toList()
          : [];

      if (_surveyQuestions.isEmpty) {
        debugPrint("No questions found for Segment $segmentId");
      }
    } catch (e) {
      debugPrint("Error fetching questions: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchLinkedQuestion(int linkedQuestionId) async {
    try {
      final rawQuestion =
          await _apiService.fetchLinkedQuestion(linkedQuestionId);
      debugPrint("Fetched Linked Question $linkedQuestionId: $rawQuestion");

      final linkedQuestion = Question.fromJson(rawQuestion);
      _surveyQuestions.add(linkedQuestion);
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching linked question: $e");
    }
  }

  void selectAnswer(int questionId, String selectedOption) {
    _responses[questionId] = selectedOption;
    notifyListeners();
  }

  int calculateTotalScore() {
    int totalScore = 0;
    for (var question in _surveyQuestions) {
      if (_responses.containsKey(question.id)) {
        totalScore += question.answers
            .firstWhere((a) => a.answerBangla == _responses[question.id])
            .score
            .toInt(); // Ensure the score is cast to int
      }
    }
    return totalScore;
  }

  void submitSurvey() {
    debugPrint("Survey Submitted! Responses: $_responses");
    // Handle survey submission (e.g., send data to API)
  }
}
