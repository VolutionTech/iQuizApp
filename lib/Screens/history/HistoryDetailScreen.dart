import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:imm_quiz_flutter/Services/HistoryServices.dart';
import 'dart:convert';

import '../../Application/Constants.dart';
import '../../Application/DataCacheManager.dart';
import '../../Application/url.dart';
import '../../Models/HistoryDetails.dart';

class HistoryDetailScreen extends StatelessWidget {
  final String historyId;

  HistoryDetailScreen({required this.historyId});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History Details'),
        backgroundColor: Application.appbarColor,
      ),
      body: FutureBuilder<HistoryDetails?>(
        future: HistoryService().fetchHistoryDetails(historyId),
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



