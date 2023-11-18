import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:imm_quiz_flutter/Application/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Application/util.dart';
import 'Screens/Home/home.dart';
import 'Screens/login/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp( MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {

  final SharedPreferences prefs;
  MyApp({required this.prefs});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primaryColor: Application.appbarColor, // Set your primary color
      ),
      home: FutureBuilder(
        future: isAlreadySignin(),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.data == true) {
            return HomeScreen(prefs: prefs);
          } else {
            return Login();
          }
        },
      ),
    );
  }
}
//
// if (snapshot.connectionState == ConnectionState.waiting) {
// return const CircularProgressIndicator(); // You can show a loading indicator here
// } else if (snapshot.hasData) {
//
// return HomeScreen(prefs: prefs);
// } else {
// return Login(); // Navigate to LoginScreen if user is not logged in
// }



