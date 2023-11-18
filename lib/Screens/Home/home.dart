import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imm_quiz_flutter/Application/Constants.dart';
import 'package:imm_quiz_flutter/Screens/login/login.dart';
import 'package:imm_quiz_flutter/Services/UserService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../LandingScreen/LandingScreen.dart';
import '../onboarding/onboarding.dart';

class HomeScreen extends StatelessWidget {
  SharedPreferences prefs;
  HomeScreen({required this.prefs});
  @override
  Widget build(BuildContext context) {
    print(prefs.getString(SharedPrefKeys.KEY_NAME));
    return prefs.getString(SharedPrefKeys.KEY_NAME) == null ||
        prefs.getString(SharedPrefKeys.KEY_NAME)?.isEmpty == true ?
    OnBoarding(true) :
    LandingScreen();

  }


}

// if (snapshot.data!.docs.isNotEmpty) {
// return LandingScreen();
// } else {
// print(snapshot.data!.docs);
// return OnBoarding(phone: FirebaseAuth.instance.currentUser?.phoneNumber ?? "");
// }



