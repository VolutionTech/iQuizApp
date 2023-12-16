import 'package:flutter/material.dart';
import 'package:flutter_button_type/flutter_button_type.dart';
import 'package:get/get.dart';
import 'package:imm_quiz_flutter/Application/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../Application/DBhandler.dart';
import '../../Application/DataCacheManager.dart';
import '../../Models/QuizHistoryModel.dart';
import '../Home/home.dart';
import '../QuizScreen/QuizScreen.dart';
import '../history/HistoryDetailScreen.dart';

class ResultScreen extends StatelessWidget {
  var dbHandler = DatabaseHandler();
  QuizHistoryModel result;

  bool isFromHistory;
  bool? showRetry = false;
  String? categoriID;

  ResultScreen(this.result, this.isFromHistory,
      {this.showRetry, this.categoriID});

  @override
  Widget build(BuildContext context) {
    print("result: ${result.correct}");
    List<_PieData> pieData = [
      _PieData('Correct', result.correct!, 'Correct'),
      _PieData('Wrong', result.total! - result.correct!, 'Wrong'),
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Application.appbarColor,
        title: Text('Result'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () async {
            if (isFromHistory) {
              Get.back();
            } else {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              Get.offAll(() => HomeScreen(prefs: prefs));
            }
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: SfCircularChart(
                title: ChartTitle(
                  text: isFromHistory
                      ? result.quiz ?? ""
                      : 'Congratulation!!!\nYou have completed the test.',
                ),
                legend: Legend(isVisible: true),
                palette: const <Color>[
                  Colors.green,
                  Colors.red,
                ],
                series: <PieSeries<_PieData, String>>[
                  PieSeries<_PieData, String>(
                    explode: true,
                    explodeIndex: 0,
                    dataSource: pieData,
                    xValueMapper: (_PieData data, _) => data.xData,
                    yValueMapper: (_PieData data, _) => data.yData,
                    dataLabelMapper: (_PieData data, _) => data.text,
                    dataLabelSettings: DataLabelSettings(isVisible: false),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Container(
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Text("Correct"),
                        Spacer(),
                        Text("${result.correct}"),
                      ],
                    ),
                    SizedBox(height: 10),
                    Divider(),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Text("Failed"),
                        Spacer(),
                        Text("${result.total! - result.correct!}"),
                      ],
                    ),
                    SizedBox(height: 10),
                    Divider(),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          "Total",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Spacer(),
                        Text(
                          "${result.total!}",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: FlutterTextButton(
                buttonText: showRetry == true ? 'Retry' : 'Review',
                buttonColor: Colors.black,
                textColor: Colors.white,
                buttonHeight: 50,
                buttonWidth: double.infinity,
                onTap: () async {
                  if (showRetry == true) {
                    Get.to(() => QuizScreen(
                          currentIndex: 0,
                          quizId: categoriID ?? "",
                          quizName: result.quiz ?? "",
                        ));
                    return;
                  } else {
                    Get.to(HistoryDetailScreen(
                      historyId: result.id!,
                    ));
                  }
                },
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: FlutterTextButton(
                buttonText: 'Main Menu',
                buttonColor: Colors.black,
                textColor: Colors.white,
                buttonHeight: 50,
                buttonWidth: double.infinity,
                onTap: () async {
                  DataCacheManager().category = null;
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  Get.offAll(() => HomeScreen(prefs: prefs));
                },
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}

class _PieData {
  _PieData(this.xData, this.yData, [this.text]);
  final String xData;
  final num yData;
  final String? text;
}
