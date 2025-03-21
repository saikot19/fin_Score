import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://4.194.252.166/credit-scroring/api/v1';

  /// User Login API
  Future<Map<String, dynamic>?> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    debugPrint("Logging in with URL: $url");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        debugPrint("Login Response: $data");

        if (data['success'] == 200 && data.containsKey('data')) {
          return data['data'];
        } else {
          debugPrint("Warning: Login failed or invalid response structure");
        }
      } else if (response.statusCode == 401) {
        debugPrint("Invalid email or password");
      } else {
        debugPrint("Failed to login. Status: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error logging in: $e");
    }

    return null; // Return null if there's an issue
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
  Future<bool> storeSurvey(String jsonData) async {
    final url = Uri.parse('$baseUrl/survey/store');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonData,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        debugPrint("Survey Submission Response: $responseData");
        return true;
      } else {
        debugPrint("Survey Submission Failed: ${response.body}");
      }
    } catch (e) {
      debugPrint("Error storing survey: $e");
    }
    return false;
  }

  /// Fetch Completed Surveys
  Future<List<Map<String, dynamic>>> fetchSurveyList(
      int userId, int branchId) async {
    final url = Uri.parse('$baseUrl/surveyeListByBranchId');
    debugPrint("Fetching Completed Surveys from URL: $url");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"user_id": userId, "branch_id": branchId}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        debugPrint("Fetched Completed Surveys: $data");

        if (data['success'] == 200 &&
            data.containsKey('data') &&
            data['data'].containsKey('survey_list')) {
          return List<Map<String, dynamic>>.from(data['data']['survey_list']);
        } else {
          debugPrint("Warning: No completed surveys found");
        }
      } else {
        debugPrint(
            "Failed to fetch completed surveys. Status: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching completed surveys: $e");
    }

    return []; // Return an empty list if there's an issue
  }

  /// Fetch User Info
  Future<Map<String, dynamic>> fetchUserInfo() async {
    final url = Uri.parse('$baseUrl/userInfo');
    debugPrint("Fetching User Info from URL: $url");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        debugPrint("Fetched User Info: $data");

        if (data['success'] == 200 && data.containsKey('data')) {
          return data['data'];
        } else {
          debugPrint("Warning: No user info found");
        }
      } else {
        debugPrint("Failed to fetch user info. Status: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching user info: $e");
    }

    return {}; // Return an empty map if there's an issue
  }
}
