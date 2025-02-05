// lib/services/survey_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/survey_model.dart'; // Import your models

class SurveyService {
  final String baseUrl;

  SurveyService({this.baseUrl = 'http://4.194.252.166/credit-scroring/api/v1'});

  Future<List<SurveyQuestion>> fetchSurvey() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/questions'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'success') {
          final questionsList = data['data']['questions'] as List;
          List<SurveyQuestion> questions =
              questionsList.map((i) => SurveyQuestion.fromJson(i)).toList();

          await storeSurveyLocally(questions); // Store after successful fetch
          return questions;
        } else {
          throw Exception(
              'API returned error status: ${data['message']}'); // More specific error
        }
      } else {
        throw Exception(
            'Failed to load survey: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error in fetchSurvey: $e'); // Catch and print errors
      rethrow; // Re-throw to be handled by the caller (Provider)
    }
  }

  Future<void> storeSurveyLocally(List<SurveyQuestion> questions) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encodedData =
          jsonEncode(questions.map((q) => q.toJson()).toList());
      await prefs.setString('surveyData', encodedData);
      print('Survey data stored locally.'); // Debugging
    } catch (e) {
      print('Error storing survey locally: $e');
    }
  }

  Future<List<SurveyQuestion>?> loadSurveyFromLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? encodedData = prefs.getString('surveyData');

      if (encodedData != null) {
        final List<dynamic> decodedData = jsonDecode(encodedData);
        List<SurveyQuestion> questions =
            decodedData.map((q) => SurveyQuestion.fromJson(q)).toList();
        print('Survey data loaded from local storage.'); // Debugging
        return questions;
      } else {
        print('No survey data found locally.'); // Debugging
      }
    } catch (e) {
      print("Error loading from local storage: $e");
    }
    return null; // Return null if no data or error
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final bool? isLoggedIn = prefs.getBool('isLoggedIn');
    return isLoggedIn ?? false;
  }

  Future<void> login() async {
    // Your login logic here
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
  }

  Future<void> logout() async {
    // Your logout logic here
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
  }
}
