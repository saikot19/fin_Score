import 'package:flutter/material.dart';
import '../api/survey_service.dart';
import '../models/survey_model.dart';
import '../models/survey_segment_model.dart';

class SurveyProvider with ChangeNotifier {
  final SurveyService _surveyService = SurveyService();
  List<SurveyQuestion> _questions = [];
  List<SurveySegmentModel> _surveySegments = [];
  bool _isLoading = false;
  String _errorMessage = '';
  final Map<int, int?> _selectedAnswers = {};
  int _currentSegment = 0;
  String _memberId = '';
  double _appliedLoanAmount = 0.0;
  String _applyingDate = '';

  List<SurveyQuestion> get questions => _questions;
  List<SurveySegmentModel> get surveySegments => _surveySegments;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  Map<int, int?> get selectedAnswers => _selectedAnswers;
  int get currentSegment => _currentSegment;
  String get memberId => _memberId;
  double get appliedLoanAmount => _appliedLoanAmount;
  String get applyingDate => _applyingDate;

  Future<void> fetchSurvey() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _questions = await _surveyService.fetchSurvey();
      _surveySegments = _organizeQuestionsIntoSegments(_questions);
      _resetSelectedAnswers();
    } catch (e) {
      _errorMessage = e.toString();
      print("Error fetching survey: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadSurveyFromLocal() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final loadedQuestions = await _surveyService.loadSurveyFromLocal();
      if (loadedQuestions != null) {
        _questions = loadedQuestions;
        _surveySegments = _organizeQuestionsIntoSegments(_questions);
        _repopulateSelectedAnswers();
      }
    } catch (e) {
      _errorMessage = e.toString();
      print("Error loading from local: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<SurveySegmentModel> _organizeQuestionsIntoSegments(
      List<SurveyQuestion> questions) {
    Map<int, List<SurveyQuestion>> segmentsMap = {};

    for (var question in questions) {
      if (!segmentsMap.containsKey(question.segmentId)) {
        segmentsMap[question.segmentId] = [];
      }
      segmentsMap[question.segmentId]!.add(question);
    }

    return segmentsMap.entries.map((entry) {
      int segmentId = entry.key;
      List<SurveyQuestion> segmentQuestions = entry.value;
      // You'll likely want to fetch the actual title from an API or configuration
      String segmentTitle =
          "Segment $segmentId"; // Placeholder title – Replace with your logic

      return SurveySegmentModel(segmentId as SurveySegmentModel,
          title: segmentTitle, questions: segmentQuestions);
    }).toList();
  }

  void submitAnswer(int questionId, int? answerId) {
    _selectedAnswers[questionId] = answerId;
    notifyListeners();
  }

  int? getSelectedAnswer(int questionId) {
    return _selectedAnswers[questionId];
  }

  void _resetSelectedAnswers() {
    _selectedAnswers.clear();
  }

  void _repopulateSelectedAnswers() {
    _selectedAnswers.clear();
    for (var question in _questions) {
      for (var answer in question.answers) {
        if (answer.score > 0) {
          _selectedAnswers[question.id] = answer.id;
          break;
        }
      }
    }
  }

  void nextSegment() {
    _currentSegment++;
    notifyListeners();
  }

  void setMemberId(String memberId) {
    _memberId = memberId;
    notifyListeners();
  }

  void setAppliedLoanAmount(double appliedLoanAmount) {
    _appliedLoanAmount = appliedLoanAmount;
    notifyListeners();
  }

  void setApplyingDate(String applyingDate) {
    _applyingDate = applyingDate;
    notifyListeners();
  }
}
