import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:imm_quiz_flutter/Cache/DataCacheManager.dart';
import 'dart:convert';

import '../url.dart';

class HistoryDetailScreen extends StatelessWidget {
  final String historyId;

  HistoryDetailScreen({required this.historyId});

  Future<HistoryDetails> fetchHistoryDetails() async {
    final response = await http.get(
      Uri.parse(baseURL + historyEndPoint + historyId),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
        'Bearer ${DataCacheManager().headerToken}',
      },
    );

    if (response.statusCode == 200) {
      return HistoryDetails.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load history details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History Details'),
      ),
      body: FutureBuilder<HistoryDetails>(
        future: fetchHistoryDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else
          if (!snapshot.hasData || snapshot.data?.details.isEmpty != false) {
            return Center(
              child: Text('No details available.'),
            );
          } else {
            List<HistoryQuestion>? reviewDataList = snapshot.data?.details;
            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: ListView(
                children: reviewDataList!.asMap().entries.map((entry) {
                  int index = entry.key;
                  HistoryQuestion reviewData = entry.value;
                  return ReviewBlock(
                    '${index + 1}) ' + reviewData.question,
                    reviewData.correct,
                    reviewData.isCorrect
                        ? ""
                        : reviewData.selected,
                  );
                }).toList(),
              ),
            );
          }
        },
      ),
    );
  }

}


Column ReviewBlock(question, ans, wrongAns) {
  return Column(
    children: [
      Text(
        question,
        style: TextStyle(fontSize: 18.0, color: Colors.black),
      ),
      SizedBox(
        height: 5,
      ),

      wrongAns.isEmpty ? Text("") : Container(
        margin: EdgeInsets.only(top: 8),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                wrongAns,
                maxLines: null,
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
      Container(
        margin: EdgeInsets.only(top: 8),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                ans,
                maxLines: null,
                style: TextStyle(color: Colors.green, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
      SizedBox(
        height: 10,
      ),
    ],
  );
}
class HistoryDetails {
  final String id;
  final List<HistoryQuestion> details;

  HistoryDetails({
    required this.id,
    required this.details,
  });

  factory HistoryDetails.fromJson(Map<String, dynamic> json) {
    List<dynamic> detailsList = json['details'];
    List<HistoryQuestion> questions = detailsList.map((item) => HistoryQuestion.fromJson(item)).toList();

    return HistoryDetails(
      id: json['id'],
      details: questions,
    );
  }
}

class HistoryQuestion {
  final String question;
  final bool isCorrect;
  final String correct;
  final String selected;

  HistoryQuestion({
    required this.question,
    required this.isCorrect,
    required this.correct,
    required this.selected,
  });

  factory HistoryQuestion.fromJson(Map<String, dynamic> json) {
    return HistoryQuestion(
      question: json['question'],
      isCorrect: json['isCorrect'],
      correct: json['correct'],
      selected: json['selected'],
    );
  }
}
