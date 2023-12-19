import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imm_quiz_flutter/Application/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../LandingScreen/LandingScreen.dart';
import '../onboarding/onboarding.dart';

class HomeScreen extends StatelessWidget {
  SharedPreferences prefs;
  HomeScreen({required this.prefs});
  @override
  Widget build(BuildContext context) {
    print(prefs.getString(SharedPrefKeys.KEY_NAME));
    return (prefs.getString(SharedPrefKeys.KEY_NAME) == null ||
                prefs.getString(SharedPrefKeys.KEY_NAME)?.isEmpty == true) &&
            prefs.getBool(SharedPrefKeys.KEY_ISLOGIN) == true
        ? OnBoarding(true, prefs)
        : LandingScreen(
            prefs: prefs,
          );
  }
}
