import 'package:flutter/material.dart';
import '../models/question_model.dart';
import '../services/api_service.dart';

class SurveyProvider extends ChangeNotifier {
  List<Question> _surveyQuestions = [];
  bool _isLoading = false;
  Map<int, int?> _responses = {};

  List<Question> get surveyQuestions => _surveyQuestions;
  bool get isLoading => _isLoading;
  Map<int, int?> get responses => _responses;

  get questions => null;

  /// Fetch survey questions from API
  Future<void> fetchSurveyQuestions() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.fetchSurveyQuestions();

      debugPrint("API Response: $response");

      if (response.isNotEmpty) {
        _surveyQuestions = response.map((q) => Question.fromJson(q)).toList();
        debugPrint("Survey Questions Loaded: ${_surveyQuestions.length}");
      } else {
        debugPrint("Invalid API response format or empty list.");
        _surveyQuestions = [];
      }
    } catch (e) {
      debugPrint("Error fetching survey questions: $e");
      _surveyQuestions = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Save survey response
  void saveResponse(int questionId, int? selectedAnswerId) {
    _responses[questionId] = selectedAnswerId;
    notifyListeners();
  }
}
