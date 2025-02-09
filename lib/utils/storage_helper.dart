import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  static Future<void> storeOfflineResponse(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> offlineData = prefs.getStringList("offline_surveys") ?? [];
    offlineData.add(jsonEncode(data));
    await prefs.setStringList("offline_surveys", offlineData);
    print("Offline Data Stored: ${jsonEncode(data)}");
  }

  static Future<List<Map<String, dynamic>>> getOfflineResponses() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> offlineData = prefs.getStringList("offline_surveys") ?? [];
    return offlineData
        .map((e) => jsonDecode(e) as Map<String, dynamic>)
        .toList();
  }
}
