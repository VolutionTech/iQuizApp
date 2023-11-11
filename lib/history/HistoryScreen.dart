import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:http/http.dart' as http;
import 'package:imm_quiz_flutter/ResultScreen/result_screen.dart';
import 'package:imm_quiz_flutter/url.dart';
import 'package:intl/intl.dart';

import '../Cache/DataCacheManager.dart';
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
    final apiUrl = baseURL+historyEndPoint;

    try {
      final response = await http.get(
          Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
          'Bearer ${DataCacheManager().headerToken}',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body)['histories'];

        setState(() {
          histories = jsonData.map((history) => QuizHistory.fromJson(history)).toList();
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
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: histories!.length,
        itemBuilder: (context, index) {
          final history = histories![index];
          final scorePercentage = (history.correct / history.total) * 100;

          return ListTile(
            title: Text(history.quiz ?? ""),
            subtitle: Text(
              'Attempted on: ${DateFormat.yMMMMd().add_jms().format(history.timestamp)}',
              style: TextStyle(color: Colors.grey),
            ),
            trailing: Text('${scorePercentage.toStringAsFixed(2)}%'),
            onTap: () {
              Get.to(ResultScreen(history));
            },
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HistoryScreen(),
  ));
}
