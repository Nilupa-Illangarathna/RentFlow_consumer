import 'package:shared_preferences/shared_preferences.dart';

class UserCredentials {
  static const String _sessionTokenKey = 'session_token';

  // Save session token in SharedPreferences
  Future<void> saveSessionToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionTokenKey, token);
  }

  // Get session token from SharedPreferences
  Future<String?> getSessionToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_sessionTokenKey);
  }

// Additional methods for user credentials...
}

final UserCredentials userCredentials = UserCredentials();