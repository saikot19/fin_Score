import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl;

  AuthService(
      {this.baseUrl = 'http://4.194.252.166/credit-scroring/api/v1/login'});

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl), // Ensure the URL is correct
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },

        body: jsonEncode({'email': email, 'password': password}),
      );

      // Log response details for debugging
      log('Response Code: ${response.statusCode}', name: 'AuthService');
      log('Response Headers: ${response.headers}', name: 'AuthService');
      log('Raw Response: ${response.body}', name: 'AuthService');

      // Check if response is JSON
      if (response.statusCode == 200) {
        try {
          return jsonDecode(response.body); // Parse JSON
        } catch (e) {
          throw Exception('Invalid JSON response from server.');
        }
      } else {
        throw Exception('Sign-in failed: ${response.body}');
      }
    } catch (e) {
      log('Error during sign-in: $e', name: 'AuthService');
      throw Exception('An error occurred while signing in.');
    }
  }
}
