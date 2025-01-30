import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl;

  AuthService({this.baseUrl = 'http://4.194.252.166/credit-scroring/api/v1'});

  /// Sign in method
  Future<Map<String, dynamic>> signIn(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({'email': email, 'password': password}),
      );

      log('Status Code: ${response.statusCode}', name: 'AuthService');
      log('Headers: ${response.headers}', name: 'AuthService');
      log('Raw Response: ${response.body}', name: 'AuthService');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          await _saveUserEmail(email);
          return data;
        } else {
          throw Exception("Login failed: ${data['message']}");
        }
      } else {
        throw Exception(
            'Login failed: Status Code ${response.statusCode}, Response: ${response.body}');
      }
    } on SocketException {
      throw Exception(
          "Network error: Unable to connect to the server. Check your internet connection.");
    } on HttpException {
      throw Exception("Invalid response from the server.");
    } on FormatException {
      throw Exception("Unexpected response format. Server might be down.");
    } catch (e) {
      throw Exception("Error during sign-in: $e");
    }
  }

  /// Saves user email for future authentication
  Future<void> _saveUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userEmail', email);
  }

  /// Logs out the user
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userEmail');
  }

  /// Checks if the user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userEmail') != null;
  }
}
