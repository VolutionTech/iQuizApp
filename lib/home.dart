import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'LandingScreen.dart';
import 'constants.dart';
import 'onboarding/onboarding.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(collectionUser)
          .where(dbKeyPhone, isEqualTo: FirebaseAuth.instance.currentUser?.phoneNumber)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return Text('Error: ${snapshot.error}');
        } else {
          // Get.find<HomeController>().title.value = "Select Paper";
          if (snapshot.data!.docs.isNotEmpty) {
            return LandingScreen();
          } else {
            print(snapshot.data!.docs);
            return OnBoarding(phone: FirebaseAuth.instance.currentUser?.phoneNumber ?? "");
          }
        }
      },
    );
  }


}



