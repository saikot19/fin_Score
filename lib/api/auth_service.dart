import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl;

  AuthService(
      {this.baseUrl = 'http://4.194.252.166/credit-scroring/api/v1/login'});

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    final url = Uri.parse(baseUrl);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Successful response
    } else {
      throw Exception('Failed to sign in: ${response.body}');
    }
  }
}
