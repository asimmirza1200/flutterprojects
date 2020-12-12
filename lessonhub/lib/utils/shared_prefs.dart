import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static Future<String> getString(String key,
      [String defaultValue = ""]) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String value = _prefs.getString(key);

    return value != null ? value : defaultValue;
  }

  static setString(String key, String value) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString(key, value);
  }

  static setBool(String key, bool value) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setBool(key, value);
  }

  static Future<bool> getBool(String key, [bool defaultValue = false]) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    bool value = _prefs.getBool(key);

    return value != null ? value : defaultValue;
  }
}
