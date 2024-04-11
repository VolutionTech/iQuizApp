import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Screens/login/login.dart';
import 'Constants.dart';
import 'DBhandler.dart';

updateUser(
    String? name, String? token, String? imageName, bool? islogin) async {
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
  if (islogin != null) {
    pref.setBool(SharedPrefKeys.KEY_ISLOGIN, islogin);
  }
}

removeUser() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.remove(SharedPrefKeys.KEY_TOKEN);
  pref.remove(SharedPrefKeys.KEY_NAME);
  pref.remove(SharedPrefKeys.KEY_IMAGE);
  pref.remove(SharedPrefKeys.KEY_ISLOGIN);
}

void logout() async {
  DatabaseHandler().deleteAll();
  await removeUser();
  Get.offAll(() => Login());
  print('User logged out');
}

Future<bool> isAlreadySignin() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getString(SharedPrefKeys.KEY_TOKEN) != null &&
      prefs.getString(SharedPrefKeys.KEY_TOKEN)!.isNotEmpty) {
    return true;
  } else {
    return false;
  }
}
