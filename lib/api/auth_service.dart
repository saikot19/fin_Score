import 'dart:convert';
import 'dart:async';
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
        if (data['status'] == 200) {
          // Check the status
          await _saveUserDetails(data['user']['userDetails']);
          return data;
        } else {
          throw Exception("Login failed: ${data['msg']}");
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

  /// Saves user details for future authentication
  Future<void> _saveUserDetails(Map<String, dynamic> userDetails) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', userDetails['id']); // Save user ID
    await prefs.setInt('branchId', userDetails['branch_id']); // Save branch ID
  }

  /// Logs out the user
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('branchId');
  }

  /// Checks if the user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId') != null; // Check if user ID is saved
  }
}
