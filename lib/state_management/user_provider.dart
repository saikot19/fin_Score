import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  int? userId;
  int? branchId;
  bool isLoggedIn = false;

  void login(int id, int branch) {
    userId = id;
    branchId = branch;
    isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    userId = null;
    branchId = null;
    isLoggedIn = false;
    notifyListeners();
  }
}
