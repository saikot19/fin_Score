import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://4.194.252.166/credit-scroring/api/v1';

  static Future<Map<String, dynamic>?> login(
      String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['user'] != null && data['user']['userDetails'] != null) {
          return data['user']['userDetails'];
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Fetch Survey Questions (Updated to match API structure)
  static Future<List<dynamic>> fetchSurveyQuestions() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/questions'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'success' && data['data'] != null) {
          return data['data']['questions'] ?? [];
        }
      }
    } catch (e) {
      print("Error fetching survey questions: $e");
    }

    return [];
  }

  static Future<bool> storeSurvey(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/survey/store'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
