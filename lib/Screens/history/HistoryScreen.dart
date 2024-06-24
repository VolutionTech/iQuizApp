import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Application/AppConfiguration.dart';
import '../../Application/Constants.dart';
import '../../Models/QuizHistoryModel.dart';
import '../../Services/HistoryServices.dart';
import '../../Vendors/FlutterButton/buttons_flutter.dart';
import '../../widgets/Shimmer/HistoryPlaceholder.dart';
import '../QuizScreen/QuizAppController.dart';
import '../ResultScreen/result_screen.dart';
import '../login/login.dart';

class HistoryScreen extends StatefulWidget {
  QuizAppController controller = Get.find();
  Function? moveToCategory;
  SharedPreferences prefs;
  HistoryScreen({required Function moveToCategory, required this.prefs}) {
    this.moveToCategory = moveToCategory;
    this.prefs = prefs;
    controller.showSearchInCate.value = false;
    controller.controller.reverse();
    controller.showSearchInQuizScreen.value = false;
    controller.controllerQ.reverse();
  }
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  HistoryModel? _historyModel;

  @override
  void initState() {
    super.initState();
    if (widget.prefs.getBool(SharedPrefKeys.KEY_ISLOGIN) == true) {
      updateData();
    }
  }

  updateData() async {
    var data = await HistoryService().fetchAllHistory();
    setState(() {
      _historyModel = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz History'),
        backgroundColor: Application.appbarColor,
      ),
      body: widget.prefs.getBool(SharedPrefKeys.KEY_ISLOGIN) == true
          ? _historyModel?.histories == null
              ? HistoryPlaceholder()
              : _historyModel?.histories.isEmpty == true
                  ? NRFView()
                  : Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListView.builder(
                        itemCount: _historyModel?.histories.length,
                        itemBuilder: (context, index) {
                          final history = _historyModel!.histories[index];
                          final scorePercentage =
                              (history.correct! / history.total!) * 100;

                          return Container(
                            color: Colors.white,
                            child: Column(
                              children: [
                                ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Text(history.quiz ?? ""),
                                  ),
                                  subtitle: Text(
                                    '${DateFormat.yMMMd().add_jms().format(history.timestamp!.toLocal())}',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  trailing: Text(
                                    '${scorePercentage.toStringAsFixed(2)}%',
                                    style: TextStyle(
                                        color: scorePercentage >=
                                                Application.passingMarks
                                            ? Colors.green
                                            : Colors.red),
                                  ),
                                  onTap: () {
                                    Get.to(ResultScreen(history, true));
                                  },
                                ),
                                Visibility(
                                  visible: index !=
                                      (_historyModel!.histories!.length - 1),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                    child: Divider(
                                      height: 0,
                                      thickness: 0.2,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
          : LoginView(),
    );
  }

  Widget NRFView() {
    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 50),
            SizedBox(
              height: 20,
            ),
            Text('No quiz completed yet.'),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: FlutterTextButton(
                buttonText: 'Start',
                buttonColor: Application.appbarColor,
                textColor: Colors.white,
                buttonHeight: 50,
                buttonWidth: double.infinity,
                onTap: () async {
                  if (widget.moveToCategory != null) widget.moveToCategory!();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget LoginView() {
    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.login, size: 50),
            SizedBox(
              height: 20,
            ),
            Text('Please login to view history.'),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: FlutterTextButton(
                buttonText: 'Login',
                buttonColor: Application.appbarColor,
                textColor: Colors.white,
                buttonHeight: 50,
                buttonWidth: double.infinity,
                onTap: () async {
                  Get.offAll(Login());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
