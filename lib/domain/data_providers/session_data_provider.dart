import 'package:shared_preferences/shared_preferences.dart';

abstract class _Keys {
  static const sessionId = 'session_id';
}

class SessionDataProvider {
  static final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<String?> getSessionId() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(_Keys.sessionId);
  }

  Future<void> setSessionId(String? value) async {
    final SharedPreferences prefs = await _prefs;
    if (value != null) {
      await prefs.setString(_Keys.sessionId, value);
    } else {
      await prefs.remove(_Keys.sessionId);
    }
  }
}