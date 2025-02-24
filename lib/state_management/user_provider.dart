import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  Map<String, dynamic> _userInfo = {};

  Map<String, dynamic> get userInfo => _userInfo;

  void login(int userId, int branchId, String userName, String branchName) {
    _userInfo = {
      'user_id': userId,
      'branch_id': branchId,
      'user_name': userName,
      'branch_name': branchName,
    };
    notifyListeners();
  }

  void logout() {
    _userInfo = {};
    notifyListeners();
  }
}
