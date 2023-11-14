import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:http/http.dart' as http;
import 'package:imm_quiz_flutter/ResultScreen/result_screen.dart';
import 'package:imm_quiz_flutter/url.dart';
import 'package:intl/intl.dart';

import '../Cache/DataCacheManager.dart';
import '../Shimmer/HistoryPlaceholder.dart';
import 'HistoryDetailScreen.dart';

class QuizHistory {
  final String id;
  final String? quiz;
  final int correct;
  final int? unanswered;
  final int total;
  final DateTime timestamp;

  QuizHistory({
    required this.id,
    required this.quiz,
    required this.correct,
    required this.unanswered,
    required this.total,
    required this.timestamp,
  });

  factory QuizHistory.fromJson(Map<String, dynamic> json) {
    return QuizHistory(
      id: json['id'],
      quiz: json['quiz'],
      correct: json['correct'],
      unanswered: json['unanswered'],
      total: json['total'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<QuizHistory>? histories;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final apiUrl = baseURL + historyEndPoint;

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${DataCacheManager().headerToken}',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body)['histories'];

        setState(() {
          histories =
              jsonData.map((history) => QuizHistory.fromJson(history)).toList();
        });
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
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
