import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://4.194.252.166/credit-scroring/api/v1';

  /// User Login API
  Future<Map<String, dynamic>?> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/login');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": username, "password": password}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data.containsKey('user') && data['user']?['userDetails'] != null) {
          return data['user']['userDetails'];
        }
      }
      debugPrint("Login Failed: ${response.body}");
    } catch (e) {
      debugPrint("Login API Error: $e");
    }
    return null;
  }

  /// Fetch Survey Questions based on `segmentId`
  Future<List<Map<String, dynamic>>> fetchSurveyQuestions(int segmentId) async {
    final url = Uri.parse('$baseUrl/questions?segment_id=$segmentId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        debugPrint(
            "Raw API Response: ${jsonEncode(data)}"); // Print full response for debugging

        // Validate if 'data' contains 'questions' as a List
        if (data['status'] == 'success' &&
            data.containsKey('data') &&
            data['data'] is Map<String, dynamic> &&
            data['data'].containsKey('questions') &&
            data['data']['questions'] is List) {
          return List<Map<String, dynamic>>.from(data['data']['questions']);
        } else {
          debugPrint(
              "Warning: No questions found or invalid response structure for segment $segmentId");
        }
      } else {
        debugPrint("Failed to fetch questions. Status: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching survey questions: $e");
    }

    return []; // Return an empty list if there's an issue
  }

  /// Fetch Linked Question based on `linkedQuestionId`
  Future<Map<String, dynamic>> fetchLinkedQuestion(int linkedQuestionId) async {
    final url = Uri.parse('$baseUrl/questions/$linkedQuestionId');
    debugPrint("Fetching Linked Question from URL: $url");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        debugPrint("Fetched Linked Question $linkedQuestionId: $data");

        if (data['status'] == 'success' && data.containsKey('data')) {
          return data['data'];
        } else {
          debugPrint(
              "Warning: No linked question found for ID $linkedQuestionId");
        }
      } else {
        debugPrint(
            "Failed to fetch linked question. Status: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching linked question: $e");
    }

    return {}; // Return an empty map if there's an issue
  }

  /// Store Survey Responses
  Future<bool> storeSurvey(Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/survey/store');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        debugPrint("Survey Submission Failed: ${response.body}");
      }
    } catch (e) {
      debugPrint("Error storing survey: $e");
    }
    return false;
  }
}
