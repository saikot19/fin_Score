import 'package:flutter/material.dart';
import '../api/survey_service.dart';
import '../models/survey_segment.dart';

class SurveyProvider with ChangeNotifier {
  final SurveyService _surveyService = SurveyService();
  List<SurveySegment> _questions = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<SurveySegment> get questions => _questions;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> loadSurvey() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _questions = (await _surveyService.fetchSurvey()).cast<SurveySegment>();
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
