import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../LandingScreen/LandingScreen.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return LandingScreen();
  }


}

// if (snapshot.data!.docs.isNotEmpty) {
// return LandingScreen();
// } else {
// print(snapshot.data!.docs);
// return OnBoarding(phone: FirebaseAuth.instance.currentUser?.phoneNumber ?? "");
// }



