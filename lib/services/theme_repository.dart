import 'package:shared_preferences/shared_preferences.dart';

const String _storageKey = "matrix_";
Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

class ThemeRepository {
  Future<Null> init(String type) async {
    await setPreferredTheme(type);
    return null;
  }


  getPreferredTheme() async {
    String type = await _getApplicationSavedInformation();
    print("GET PREFS $type");
    return type;
  }

  setPreferredTheme(String type) async {
    print(type);
    return _setApplicationSavedInformation(type);
  }

  Future<String> _getApplicationSavedInformation() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(_storageKey + "theme") ?? '';
  }
  
  Future<bool> _setApplicationSavedInformation(String type) async {
    final SharedPreferences prefs = await _prefs;
    print("SET PERS $type");
    return prefs.setString(_storageKey + "theme", type);
  }
}

ThemeRepository themeRepository = new ThemeRepository();
