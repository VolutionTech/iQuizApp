import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imm_quiz_flutter/Category/CategoryScreen.dart';
import 'package:imm_quiz_flutter/onboarding/onboarding.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';


class LandingScreen extends StatefulWidget {
  static final title = 'salomon_bottom_bar';

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen>
    with
        WidgetsBindingObserver,
        AutomaticKeepAliveClientMixin,
        TickerProviderStateMixin {
  var _currentIndex = 0;
  TabController? controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TabController(length: 4, vsync: this);
    SystemChrome.setEnabledSystemUIOverlays([]);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      bottomNavigationBar: Container(
       // height: 90,
        padding:
        EdgeInsets.symmetric(horizontal: 5),
        color: Colors.black,
        child: TabBar(
          indicatorSize:
          TabBarIndicatorSize.label,
          isScrollable: false,
          labelPadding: EdgeInsets.all(4),
          indicatorPadding:
          EdgeInsets.only(bottom: 15),
          labelStyle: TextStyle(
              fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.bold),
          labelColor:
         Colors.white,
          unselectedLabelColor:
          Colors.white,
          indicatorWeight: 3,
          indicatorColor: Colors.white,
          controller: controller,
          tabs: <Widget>[
            Tab(
              text: "My quizzes",
              icon: Icon( Icons.quiz),
            ),

            Tab(
              text: "Categories",
              icon: Icon( Icons.category),
            ),

            Tab(
              text: "History",
              icon: Icon( Icons.history),
            ),

            Tab(
              text: "Profile",
              icon: Icon( Icons.person),
            ),

          ],
        ),
      ),
      body: TabBarView(
        controller: controller,
        children: <Widget>[
          Scaffold(appBar: AppBar(),body: Text("Mama"),),
          CategoryScreen(),
          Scaffold(appBar: AppBar(),body: Text("Mama"),),
          OnBoarding(phone: FirebaseAuth.instance.currentUser?.phoneNumber ?? "")

        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}