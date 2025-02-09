import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static Future<void> storeOffline(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> offlineData = prefs.getStringList("offline_surveys") ?? [];
    offlineData.add(jsonEncode(data));
    await prefs.setStringList("offline_surveys", offlineData);
    print("Offline Data Stored: ${jsonEncode(data)}");
  }
}
