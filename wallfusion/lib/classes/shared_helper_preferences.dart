import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  static const String _emailListKey = 'emailList';

  // Save email list to SharedPreferences
  static Future<void> saveEmailList(List<String> emailList) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_emailListKey, emailList);
  }

  // Load email list from SharedPreferences
  static Future<List<String>> loadEmailList() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_emailListKey) ?? [];
  }
}
