import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

import 'Constants.dart';


updateUser(String? name, String? token, String? imageName) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  if (token != null) {
    pref.setString(SharedPrefKeys.KEY_TOKEN, token);
  }
  if (name != null) {
    pref.setString(SharedPrefKeys.KEY_NAME, name);
  }
  if (imageName != null) {
    pref.setString(SharedPrefKeys.KEY_IMAGE, imageName);
  }
}

List<Color> getRandomColorsList() {
  return [

    Color(0xFFF44336),
    Color(0xFFE91E63),
    Color(0xFF9C27B0),
    Color(0xFF673AB7),
    Color(0xFF3F51B5),
    Color(0xFF2196F3),
    Color(0xFF03A9F4),
    Color(0xFF00BCD4),
    Color(0xFF009688),
    Color(0xFF4CAF50),
    Color(0xFF8BC34A),
    Color(0xFFCDDC39),
    Color(0xFFFFEB3B),
    Color(0xFFFFC107),
    Color(0xFFFF9800),
    Color(0xFFFF5722),
    Color(0xFF795548),
    Color(0xFF9E9E9E),
    Color(0xFF607D8B),
    Color(0xFF78909C),
    Color(0xFFC62828),
    Color(0xFFAD1457),
    Color(0xFF6A1B9A),
    Color(0xFF4527A0),
    Color(0xFF283593),
    Color(0xFF1565C0),
    Color(0xFF0277BD),
    Color(0xFF00838F),
    Color(0xFF00695C),
    Color(0xFF2E7D32),
    Color(0xFF558B2F),
    Color(0xFF9E9D24),
    Color(0xFFF9A825),
    Color(0xFFF57F17),
    Color(0xFFFF6F00),
    Color(0xFFE65100),
    Color(0xFFBF360C),
    Color(0xFF3E2723),
    Color(0xFF607D8B),
    Color(0xFF90A4AE),
    Color(0xFFD32F2F),
    Color(0xFFC2185B),
    Color(0xFF7B1FA2),
    Color(0xFF512DA8),
    Color(0xFF303F9F),
    Color(0xFF1976D2),
    Color(0xFF0288D1),
    Color(0xFF0097A7),
    Color(0xFF00796B),
    Color(0xFF388E3C),
    Color(0xFF689F38),
    Color(0xFFAFB42B),
    Color(0xFFFBC02D),
    Color(0xFFFFA000),
    Color(0xFFFF6F40),
    Color(0xFFF4511E),
    Color(0xFF8D6E63),
    Color(0xFF757575),
    Color(0xFF546E7A),
    Color(0xFF607D8B),
    Color(0xFFB71C1C),
    Color(0xFF880E4F),
    Color(0xFF4A148C),
    Color(0xFF311B92),
    Color(0xFF1A237E),
    Color(0xFF0D47A1),
    Color(0xFF01579B),
    Color(0xFF006064),
    Color(0xFF004D40),
    Color(0xFF1B5E20),
    Color(0xFF33691E),
    Color(0xFF827717),
    Color(0xFFF57C00),
    Color(0xFFFF6F61),
    Color(0xFFE64A19),
    Color(0xFF5D4037),
    Color(0xFF616161),
    Color(0xFF455A64),
    Color(0xFF546E7A),
    Color(0xFF607D8B),
    Color(0xFF880E4F),
    Color(0xFF4A148C),
    Color(0xFFB71C1C),
    Color(0xFF4A148C),
    Color(0xFF0D47A1),
    Color(0xFF01579B),
    Color(0xFF006064),
    Color(0xFF004D40),
    Color(0xFF1B5E20),
    Color(0xFF33691E),
    Color(0xFF827717),
    Color(0xFFF57C00),
    Color(0xFFFF6F61),
    Color(0xFFE64A19),
    Color(0xFF5D4037),
    Color(0xFF616161),
    Color(0xFF455A64),
    Color(0xFF546E7A),
    Color(0xFF607D8B),
    Color(0xFF9E9E9E)];


}