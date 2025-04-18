import 'package:shared_preferences/shared_preferences.dart';

class KeyValueStorageService {
  Future<SharedPreferences> _getSharedPrefs() async {
    return await SharedPreferences.getInstance();
  }

  Future<void> setKeyValue(String key, String value) async {
    final prefs = await _getSharedPrefs();
    await prefs.setString(key, value);
  }

  Future<String?> getValue(String key) async {
    final prefs = await _getSharedPrefs();
    return prefs.getString(key);
  }

  Future<void> removeKey(String key) async {
    final prefs = await _getSharedPrefs();
    await prefs.remove(key);
  }
}