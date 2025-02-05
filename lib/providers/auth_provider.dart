import 'package:flutter/material.dart';
import '../api/auth_service.dart'; // Ensure this import is correct and the AuthService class is defined in this file
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final authService = AuthService();
      final response = await authService.login(email, password);

      if (response['status'] == 200) {
        _user = UserModel.fromJson(response);
        notifyListeners();
      } else {
        throw Exception(response['msg'] ?? 'Login failed');
      }
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

extension on AuthService {
  login(String email, String password) {}
}
