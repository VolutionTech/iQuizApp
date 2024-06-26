import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:imm_quiz_flutter/Application/AppConfiguration.dart';
import 'package:imm_quiz_flutter/Screens/CategoryScreen/CategoryScreen.dart';
import 'package:imm_quiz_flutter/Screens/QuizScreen/QuizAppController.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../MyQuizzes/MyQuizzesScreen.dart';
import '../history/HistoryScreen.dart';
import '../onboarding/onboarding.dart';

class LandingScreen extends StatefulWidget {
  static final title = 'salomon_bottom_bar';
  QuizAppController getcontroller = Get.find();
  SharedPreferences prefs;

  LandingScreen({required this.prefs});

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen>
    with
        WidgetsBindingObserver,
        AutomaticKeepAliveClientMixin,
        TickerProviderStateMixin {
  TabController? controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 4, vsync: this);

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        color: Application.appbarColor,
        child: TabBar(
          indicatorSize: TabBarIndicatorSize.label,
          isScrollable: false,
          labelPadding: EdgeInsets.all(4),
          indicatorPadding: EdgeInsets.only(bottom: 15),
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white,
          indicatorWeight: 3,
          indicatorColor: Colors.white,
          controller: controller,
          tabs: widget.getcontroller.showNavbar.value
              ? <Widget>[
                  Tab(
                    text: "All Quizzes",
                    icon: Icon(Icons.category),
                  ),
                  Tab(
                    text: "My quizzes",
                    icon: Icon(Icons.quiz),
                  ),
                  Tab(
                    text: "History",
                    icon: Icon(Icons.history),
                  ),
                  Tab(
                    text: "Profile",
                    icon: Icon(Icons.person),
                  ),
                ]
              : [SizedBox()],
        ),
      ),
      body: TabBarView(
        controller: controller,
        children: <Widget>[
          CategoryScreen(),
          MyQuizzes(
            moveToCategory: () {
              controller?.index = 0;
            },
          ),
          HistoryScreen(
            moveToCategory: () {
              controller?.index = 0;
            },
            prefs: widget.prefs,
          ),
          OnBoarding(false, widget.prefs)
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
