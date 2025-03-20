import 'package:flutter/material.dart';
import 'dart:convert'; // Import the dart:convert library for JSON encoding
import 'package:shared_preferences/shared_preferences.dart';
import '../models/question_model.dart';
import '../services/api_service.dart';

class SurveyProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Question> _surveyQuestions = [];
  List<Map<String, dynamic>> _surveys = [];
  Map<int, String> _responses =
      {}; // Stores responses as (questionId -> selected option)
  bool _isLoading = false;
  Map<String, dynamic>? _userInfo; // Store user info
  bool _hasIncompleteSurvey = false; // Tracks if there is an incomplete survey

  List<Question> get questions => _surveyQuestions;
  List<Map<String, dynamic>> get surveys => _surveys;
  Map<int, String> get responses => _responses;
  bool get isLoading => _isLoading;
  bool get hasIncompleteSurvey => _hasIncompleteSurvey;
  int get totalCompletedSurveys => _surveys.length;
  ApiService get apiService => _apiService; // Add getter for ApiService
  Map<String, dynamic>? get userInfo => _userInfo; // Add getter for userInfo

  SurveyProvider() {
    _loadUser(); // Auto-load user on app start
    _checkIncompleteSurvey(); // Check for incomplete surveys on app start
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.login(email, password);
      if (response != null) {
        _userInfo = response;
        _clearSessionData(); // Clear session data when a new user logs in
        await _saveUser(); // Save user info for auto-login
        notifyListeners();
      } else {
        debugPrint("Login failed.");
      }
    } catch (e) {
      debugPrint("Error during login: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _saveUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_info', jsonEncode(_userInfo));
  }

  Future<void> _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString('user_info');
    if (userData != null) {
      _userInfo = jsonDecode(userData);
      notifyListeners();
    }
  }

  void logout() async {
    _userInfo = null;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_info');
  }

  void _clearSessionData() {
    _surveyQuestions = [];
    _surveys = [];
    _responses = {};
    _hasIncompleteSurvey = false;
  }

  Future<void> fetchSurveyQuestions(int segmentId) async {
    _isLoading = true;
    Future.microtask(() => notifyListeners()); // ✅ Prevent build-phase error

    try {
      final rawQuestions = await _apiService.fetchSurveyQuestions(segmentId);
      debugPrint("Fetched Questions for Segment $segmentId: $rawQuestions");

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
      Future.microtask(() => notifyListeners()); // ✅ Prevent error
    }
  }

  Future<void> fetchLinkedQuestion(int linkedQuestionId) async {
    try {
      final rawQuestion =
          await _apiService.fetchLinkedQuestion(linkedQuestionId);
      debugPrint("Fetched Linked Question $linkedQuestionId: $rawQuestion");

      final linkedQuestion = Question.fromJson(rawQuestion);
      _surveyQuestions.add(linkedQuestion);

      Future.microtask(() => notifyListeners()); // ✅ Fix
    } catch (e) {
      debugPrint("Error fetching linked question: $e");
    }
  }

  Future<void> fetchSurveys() async {
    if (_userInfo == null) {
      debugPrint("User info is not available.");
      return;
    }

    final branchId = _userInfo!['branch_id'];
    final userId = _userInfo!['user_id'];

    _isLoading = true;
    Future.microtask(() => notifyListeners()); // ✅ Fix

    try {
      final response = await _apiService.fetchSurveyList(userId, branchId);
      _surveys = response;
    } catch (e) {
      debugPrint("Error fetching surveys: $e");
    } finally {
      _isLoading = false;
      Future.microtask(() => notifyListeners()); // ✅ Fix
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

  Future<void> submitSurvey(String memberId, String memberName,
      double loanAmount, String startDate, String completionDate) async {
    if (_userInfo == null) {
      debugPrint("User info is not available.");
      return;
    }

    final branchId = _userInfo!['branch_id'];

    Map<String, dynamic> surveyResponse = {
      "member_id": memberId,
      "member_name": memberName,
      "branch_id": branchId,
      "applied_loan_amount": loanAmount,
      "start_date": startDate,
      "completion_date": completionDate,
      "status": 1, // Set status to 1
      "questions": [
        for (var entry in _responses.entries)
          {
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
      ],
    };

    // Convert survey response to JSON string
    String surveyResponseJson = jsonEncode(surveyResponse);

    debugPrint("Survey Response JSON: $surveyResponseJson");

    final success = await _apiService.storeSurvey(surveyResponseJson);

    if (success) {
      debugPrint("Survey submitted successfully.");
      await clearIncompleteSurvey(); // Clear incomplete survey after submission
    } else {
      debugPrint("Failed to submit survey.");
    }
  }

  Future<void> refreshSurveys() async {
    await fetchSurveys();
  }

  Future<void> saveIncompleteSurvey() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'incompleteSurvey',
        jsonEncode({
          'responses': _responses.map((key, value) =>
              MapEntry(key.toString(), value)), // Convert keys to strings
          'questions': _surveyQuestions.map((q) => q.toJson()).toList(),
        }));
    _hasIncompleteSurvey = true;
    notifyListeners();
  }

  Future<void> loadIncompleteSurvey() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('incompleteSurvey')) {
      final data = jsonDecode(prefs.getString('incompleteSurvey')!);
      _responses = Map<String, String>.from(data['responses']).map(
          (key, value) =>
              MapEntry(int.parse(key), value)); // Convert keys back to integers
      _surveyQuestions =
          (data['questions'] as List).map((q) => Question.fromJson(q)).toList();
      _hasIncompleteSurvey = true;
      notifyListeners();
    }
  }

  Future<void> clearIncompleteSurvey() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('incompleteSurvey'); // Remove incomplete survey data
    _responses.clear(); // Clear responses
    _surveyQuestions.clear(); // Clear survey questions
    _hasIncompleteSurvey = false; // Update the flag
    notifyListeners();
  }

  void clearResponses() {
    _responses.clear();
    notifyListeners();
  }

  Future<void> _checkIncompleteSurvey() async {
    final prefs = await SharedPreferences.getInstance();
    _hasIncompleteSurvey = prefs.containsKey('incompleteSurvey');
    notifyListeners();
  }
}
