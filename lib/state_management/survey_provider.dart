import 'package:flutter/material.dart';
import 'dart:convert'; // Import the dart:convert library for JSON encoding
import '../models/question_model.dart';
import '../services/api_service.dart';

class SurveyProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Question> _surveyQuestions = [];
  List<Map<String, dynamic>> _surveys = [];
  Map<int, String> _responses =
      {}; // Stores responses as (questionId -> selected option)
  bool _isLoading = false;
  int _totalCompletedSurveys = 0;

  List<Question> get questions => _surveyQuestions;
  List<Map<String, dynamic>> get surveys => _surveys;
  Map<int, String> get responses => _responses;
  bool get isLoading => _isLoading;
  int get totalCompletedSurveys => _totalCompletedSurveys;

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

  Future<void> fetchSurveys(int branchId, int userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response =
          await _apiService.fetchCompletedSurveys(branchId, userId);
      _surveys = response;
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching surveys: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchSurveyCount(int branchId, int userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _totalCompletedSurveys =
          await _apiService.fetchTotalSurveyCount(branchId);
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching survey count: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectAnswer(int questionId, String selectedOption) {
    _responses[questionId] = selectedOption;
    notifyListeners();
  }

  void setResponses(Map<int, String> responses) {
    _responses = responses;
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

  Future<void> submitSurvey(String memberId, String memberName, int branchId,
      double loanAmount, String startDate, String completionDate) async {
    Map<String, dynamic> surveyResponse = {
      "member_id": memberId,
      "member_name": memberName,
      "branch_id": branchId,
      "applied_loan_amount": loanAmount,
      "start_date": startDate,
      "completion_date": completionDate,
      "status": 1, // Set status to 1
      "questions": {
        for (var entry in _responses.entries)
          entry.key.toString(): {
            "question_id": entry.key,
            "answer_id": _surveyQuestions
                .firstWhere((q) => q.id == entry.key)
                .answers
                .firstWhere((a) => a.answerBangla == entry.value)
                .id,
            "score": _surveyQuestions
                .firstWhere((q) => q.id == entry.key)
                .answers
                .firstWhere((a) => a.answerBangla == entry.value)
                .score,
          }
      },
    };

    // Convert survey response to JSON string
    String surveyResponseJson = jsonEncode(surveyResponse);

    debugPrint("Survey Response JSON: $surveyResponseJson");

    final success = await _apiService.storeSurvey(surveyResponseJson);

    if (success) {
      debugPrint("Survey submitted successfully.");
    } else {
      debugPrint("Failed to submit survey.");
    }
  }
}
