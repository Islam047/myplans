import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  // #SAVEUSERID
  static Future<bool> saveUserId(String userId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString('userId', userId);
  }

  // #LOADUSERID
  static Future<String?> loadUserId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString('userId');
    return token;
  }

  // #REMOVEUSERID
  static Future<bool> removeUserId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.remove('userId');
  }
}
