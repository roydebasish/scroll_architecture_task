import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const _key = "token";

  static Future<void> save(String token) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString(_key, token);
  }

  static Future<String?> get() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(_key);
  }

  static Future<void> clear() async {
    final pref = await SharedPreferences.getInstance();
    await pref.remove(_key);
  }
}