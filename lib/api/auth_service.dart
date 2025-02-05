import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Renamed class to AuthService
  final String baseUrl;

  AuthService(
      {this.baseUrl =
          'http://4.194.252.166/credit-scroring/api/v1'}); // Replace with your auth API URL

  Future<bool> isLoggedIn(String email, String password) async {
    try {
      final url = Uri.parse('$baseUrl/login'); // Or your login endpoint
      final response = await http.post(url, body: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Assuming your API returns a success indicator (e.g., 'token', 'success')
        if (data['token'] != null || data['success'] == true) {
          // Adapt to your API response
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(
              'auth_token', data['token'] ?? ''); // Store the token
          return true;
        } else {
          return false; // Login failed
        }
      } else {
        print('Login failed: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error during login: $e');
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(''); // Remove the auth token
  }

  Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('');
  }

  Future<bool> isAuthenticated() async {
    final token = await getAuthToken();
    return token != null && token.isNotEmpty;
  }
}
