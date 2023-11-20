import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:imm_quiz_flutter/Application/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Application/util.dart';
import 'Screens/Home/home.dart';
import 'Screens/login/login.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  var _isInternetAvailable = false.obs;
  var subscription;
  final SharedPreferences prefs;

  MyApp({required this.prefs}) {
    updateNetworkStatus();

    subscription = Connectivity().onConnectivityChanged.listen((
        ConnectivityResult result) {
     // _isInternetAvailable.value = result != ConnectivityResult.none;
      Get.snackbar("No internet", "Please connect Internet and try again.");

    });
  }

  updateNetworkStatus() async {
    var result = await Connectivity().checkConnectivity();
    //_isInternetAvailable.value = result != ConnectivityResult.none;
    Get.snackbar("No internet", "Please connect Internet and try again.");

  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primaryColor: Application.appbarColor, // Set your primary color
      ),
      home: Obx(() {
        return IgnorePointer(
          ignoring: !_isInternetAvailable.value,
          child: AnimatedOpacity(
            opacity: _isInternetAvailable.value ? 1 : 0.5,
            duration: Duration(microseconds: 200),
            child: FutureBuilder(
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
            ),),
        );
      }),
    );
  }
}


