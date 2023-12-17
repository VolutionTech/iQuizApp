import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imm_quiz_flutter/Application/Constants.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Application/util.dart';
import 'Screens/Home/home.dart';
import 'Screens/login/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://4ae2737d3768de8e1c9f3bc5234304a4@o4505772399984640.ingest.sentry.io/4506410850451456';
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(MyApp(prefs: prefs)),
  );
}

class MyApp extends StatelessWidget {
  var _isInternetAvailable = true.obs;
  var subscription;
  final SharedPreferences prefs;

  MyApp({required this.prefs}) {
    updateNetworkStatus();

    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (!_isInternetAvailable.value && Get.context != null) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: Text('No Internet Connection'),
            duration: Duration(seconds: 100),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  updateNetworkStatus() async {
    var result = await Connectivity().checkConnectivity();
    //_isInternetAvailable.value = result != ConnectivityResult.none;
    //Get.snackbar("No internet", "Please connect Internet and try again.");
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Application.appbarColor,
          appBarTheme: AppBarTheme(
            backgroundColor: Application.appbarColor,
            foregroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.white),
          )),
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
            ),
          ),
        );
      }),
    );
  }
}
