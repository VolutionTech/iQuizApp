import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../CategoryScreen/CategoryScreen.dart';
import '../MyQuizzes/MyQuizzesScreen.dart';
import '../history/HistoryScreen.dart';
import '../onboarding/onboarding.dart';

class LandingScreen extends StatefulWidget {
  static final title = 'salomon_bottom_bar';
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
        color: Colors.black,
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
          tabs: <Widget>[
            Tab(
              text: "Categories",
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
          ],
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
