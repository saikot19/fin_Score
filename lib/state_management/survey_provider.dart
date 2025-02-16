/*import 'package:flutter/material.dart';
import '../models/question_model.dart';
import '../services/api_service.dart';

class SurveyProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Question> _surveyQuestions = [];
  Map<int, int> _responses = {};
  bool _isLoading = false;

  List<Question> get surveyQuestions => _surveyQuestions;
  Map<int, int> get responses => _responses;
  bool get isLoading => _isLoading;

  get questions => null;

  Future<void> fetchSurveyQuestions(int segmentId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final rawQuestions = await _apiService.fetchSurveyQuestions(segmentId);
      debugPrint("Raw API Response: $rawQuestions");

      _surveyQuestions = rawQuestions.map((q) => Question.fromJson(q)).toList();
    } catch (e) {
      debugPrint("Error fetching questions: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void saveResponse(int questionId, int answerId) {
    _responses[questionId] = answerId;
    notifyListeners();
  }

  int calculateTotalScore() {
    int totalScore = 0;
    for (var question in _surveyQuestions) {
      if (_responses.containsKey(question.id)) {
        totalScore += question.answers
            .firstWhere((a) => a.id == _responses[question.id])
            .score as int;
      }
    }
    return totalScore;
  }

  void submitSurvey() {}

  void selectAnswer(id, String selectedOption) {}
}*/
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

  void selectAnswer(int questionId, String selectedOption) {
    _responses[questionId] = selectedOption;
    notifyListeners();
  }

  int calculateTotalScore() {
    int totalScore = 0;
    for (var question in _surveyQuestions) {
      if (_responses.containsKey(question.id)) {
        totalScore += question.answers
            .firstWhere((a) => a.text == _responses[question.id])
            .score as int;
      }
    }
    return totalScore;
  }

  void submitSurvey() {
    debugPrint("Survey Submitted! Responses: $_responses");
    // Handle survey submission (e.g., send data to API)
  }

  void fetchLinkedQuestion(linkedQuestionId) {}
}
