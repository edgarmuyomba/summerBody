import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  void saveStringValue(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('stringValue', value);
  }

  void saveIntValue(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('intValue', value);
  }

  void saveBoolValue(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('boolValue', value);
  }

  Future<String?> getStringValue(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<int?> getIntValue(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  Future<bool?> getBoolValue(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }
}
