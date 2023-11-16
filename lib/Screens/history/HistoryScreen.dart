import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:imm_quiz_flutter/Application/url.dart';
import 'package:intl/intl.dart';
import '../../Application/DataCacheManager.dart';
import '../../Models/QuizHistoryModel.dart';
import '../../widgets/Shimmer/HistoryPlaceholder.dart';
import '../ResultScreen/result_screen.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<QuizHistoryModel>? histories;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz History'),
      ),
      body: histories == null
          ? HistoryPlaceholder()
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                itemCount: histories!.length,
                itemBuilder: (context, index) {
                  final history = histories![index];
                  final scorePercentage =
                      (history.correct / history.total) * 100;

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
                            '${DateFormat.yMMMd().add_jms().format(history.timestamp.toLocal())}',
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
                          visible: index != (histories!.length - 1),
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
}

void main() {
  runApp(MaterialApp(
    home: HistoryScreen(),
  ));
}
