import 'package:shared_preferences/shared_preferences.dart';

class PreferenceManager {
  static const String _tokenKey = "auth_token";
  static const String _faceKey = "registered_face";

  static Future<bool> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<bool> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await clearRegisteredFace();
    return prefs.remove(_tokenKey);
  }

  static Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  static Future<bool> saveRegisteredFace(String base64Image) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(_faceKey, base64Image);
  }

  static Future<String?> getRegisteredFace() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_faceKey);
  }

  static Future<bool> clearRegisteredFace() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(_faceKey);
  }
}
