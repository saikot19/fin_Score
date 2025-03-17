import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserProvider extends ChangeNotifier {
  Map<String, dynamic>? _userInfo;

  Map<String, dynamic>? get userInfo => _userInfo;

  UserProvider() {
    _loadUser();
  }

  void login(
      int userId, int branchId, String userName, String branchName) async {
    _userInfo = {
      'user_id': userId,
      'branch_id': branchId,
      'user_name': userName,
      'branch_name': branchName,
    };
    notifyListeners();

    // Save user data to SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_info', jsonEncode(_userInfo));
  }

  void logout() async {
    _userInfo = null;
    notifyListeners();

    // Remove user data from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_info');
  }

  Future<void> _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString('user_info');
    if (userData != null) {
      _userInfo = jsonDecode(userData);
      notifyListeners();
    }
  }
}
