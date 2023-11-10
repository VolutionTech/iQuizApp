import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_button_type/flutter_button_type.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:imm_quiz_flutter/DBhandler/DBhandler.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../Category/CategoryScreen.dart';
import '../QuizAppController.dart';
import '../QuizScreen.dart';
import '../ReviewScreens/ReviewScreen.dart';
import '../constants.dart';

class ResultScreen extends StatelessWidget {
  var dbHandler = DatabaseHandler();

  var category;
  ResultScreen(this.category);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbarColor,
        title: Text('Result'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: getResult(category),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // or any loading widget
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.data == 0.0) {
            return Text('');
          } else {
            List<_PieData> pieData = [
              _PieData('Correct', snapshot.data?['correct'], 'Correction'),
              _PieData('Wrong', snapshot.data?['wrong'], 'Wrong'),
            ];
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                      child: SfCircularChart(
                          title: ChartTitle(
                              text:
                                  'Congratulation!!!\nYou have completed the test.'),
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
                            dataLabelSettings:
                                DataLabelSettings(isVisible: false)),
                      ])),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Container(
                      padding: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            10), // Adjust the radius as needed
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset:
                                Offset(0, 3), // Offset in the x and y direction
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text("Pass"),
                              Spacer(),
                              Text("${snapshot.data?['correct']}"),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Divider(),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text("Failed"),
                              Spacer(),
                              Text("${snapshot.data?['wrong']}"),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Divider(),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                "Total",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              Spacer(),
                              Text(
                                  "${snapshot.data?['wrong'] + snapshot.data?['correct']}"),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: FlutterTextButton(
                        buttonText: 'Review',
                        buttonColor: Colors.black,
                        textColor: Colors.white,
                        buttonHeight: 50,
                        buttonWidth: double.infinity,
                        onTap: () async {
                          var dbData = await DatabaseHandler().getAllItems(category['id']);
                          saveToFirestore(dbData, FirebaseAuth.instance.currentUser?.phoneNumber ?? "", this.category['id']);
                          Get.to(() =>
                              ReviewScreen(category['id'])
                          );
                        }
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: FlutterTextButton(
                        buttonText: 'Retry',
                        buttonColor: Colors.black,
                        textColor: Colors.white,
                        buttonHeight: 50,
                        buttonWidth: double.infinity,
                        onTap: () async {
                          Get.off(() =>
                              QuizView(category: category, currentIndex: 0, reviewMode: false));
                        }),
                  ),

                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: FlutterTextButton(
                        buttonText: 'Main Menu',
                        buttonColor: Colors.black,
                        textColor: Colors.white,
                        buttonHeight: 50,
                        buttonWidth: double.infinity,
                        onTap: () async {
                          Get.off(CategoryScreen());
                        }),
                  ),
                  Spacer(),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Future<Map<String, dynamic>> getResult(category) async {
    List<Map<String, dynamic>> resultList =
        await dbHandler.getAllItems(category['id']);
    var correct = 0;
    var wrong = 0;

    resultList.forEach((element) {
      if (element['correctOption'] == element['selectedOption']) {
        correct++;
      } else {
        wrong++;
      }
    });
    // dbHandler.delete(category['id']);
    Get.find<QuizAppController>().attempted = [].obs;
    return {"correct": correct, "wrong": wrong};
  }
  void saveToFirestore(List<Map<String, dynamic>> data, String userId, String categoryId) async {
    CollectionReference historyCollection = FirebaseFirestore.instance.collection('history');

    for (Map<String, dynamic> item in data) {
      item['user'] = userId;
      item['category_id'] = categoryId;
     await historyCollection.add(item);
    }
  }
}

class _PieData {
  _PieData(this.xData, this.yData, [this.text]);
  final String xData;
  final num yData;
  final String? text;
}
