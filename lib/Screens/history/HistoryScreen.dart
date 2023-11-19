import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_button_type/flutter_button_type.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:imm_quiz_flutter/Application/Constants.dart';
import 'package:imm_quiz_flutter/Application/url.dart';
import 'package:imm_quiz_flutter/Services/HistoryServices.dart';
import 'package:intl/intl.dart';
import '../../Application/DataCacheManager.dart';
import '../../Models/QuizHistoryModel.dart';
import '../../widgets/Shimmer/HistoryPlaceholder.dart';
import '../ResultScreen/result_screen.dart';

class HistoryScreen extends StatefulWidget {
  Function? moveToCategory;
  HistoryScreen({required Function moveToCategory}) {
    this.moveToCategory = moveToCategory;
  }
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  HistoryModel? _historyModel;

  @override
  void initState() {
    super.initState();
    updateData();
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
      body: _historyModel?.histories == null
          ? HistoryPlaceholder()
          : _historyModel?.histories.isEmpty == true ? NRFView() : Padding(
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
                      child: Text(history.id ?? ""),
                    ),
                    subtitle: Text(
                      '${DateFormat.yMMMd().add_jms().format(history.timestamp!.toLocal())}',
                      style: TextStyle(color: Colors.grey),
                    ),
                    trailing: Text(
                      '${scorePercentage.toStringAsFixed(2)}%',
                      style: TextStyle(
                          color: scorePercentage > 70
                              ? Colors.green
                              : Colors.red),
                    ),
                    onTap: () {
                      Get.to(ResultScreen(history));
                    },
                  ),
                  Visibility(
                    visible: index != (_historyModel!.histories!.length - 1),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
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
      ),
    );
  }
  Widget NRFView() {
    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 50),
            SizedBox(height: 20,),
            Text('No quiz completed yet.'),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: FlutterTextButton(
                buttonText: 'Start',
                buttonColor: Colors.black,
                textColor: Colors.white,
                buttonHeight: 50,
                buttonWidth: double.infinity,
                onTap: () async {
                 if (widget.moveToCategory != null) widget.moveToCategory!();
                }
                ,
              ),
            ),
          ],),
      ),
    );
  }
}

