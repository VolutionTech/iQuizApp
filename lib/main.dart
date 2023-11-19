import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:imm_quiz_flutter/Application/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Application/contectivity.dart';
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
  final ConnectivityService _connectivityService = ConnectivityService();

  final SharedPreferences prefs;
  MyApp({required this.prefs}){
    _checkInternet();
    _connectivityService.connectivityStream().listen((result) {
      _hasInternet.value = result != ConnectivityResult.none;
    });
  }

  var _hasInternet = true.obs;

  Future<void> _checkInternet() async {
    bool isConnected = await _connectivityService.checkConnection();
    _hasInternet.value = isConnected;
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primaryColor: Application.appbarColor, // Set your primary color
      ),
      home: AnimatedOpacity(
        opacity: _hasInternet.value ? 0.0 : 0.1,
        duration: Duration(milliseconds: 500),
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
        ),
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



