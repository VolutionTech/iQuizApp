import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:imm_quiz_flutter/Services/HistoryServices.dart';
import 'dart:convert';

import '../../Application/Constants.dart';
import 'dart:math' as math;
import '../../Application/url.dart';
import '../../Models/HistoryDetails.dart';
import '../../widgets/Triangle.dart';

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
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ReviewBlock(
                      '${index + 1}) ' + reviewData.question,
                      reviewData.correct,
                      reviewData.isCorrect
                          ? ""
                          : reviewData.selected,
                    ),
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


Widget ReviewBlock(question, ans, wrongAns) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: wrongAns.isEmpty ? Colors.green : Colors.red),
    ),
    child: Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  question,
                  style: TextStyle(fontSize: 18.0, color: Colors.black),
                ),
              ),
              SizedBox(
                height: 20,
              ),

              wrongAns.isEmpty ? SizedBox() : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text("You selected: ", style: TextStyle(color: Colors.black, fontSize: 16)),
                        Text(
                          wrongAns,
                          maxLines: null,
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(wrongAns.isEmpty ? "You selected: " : "Correct Answer: ",
                            style: TextStyle(color: Colors.black, fontSize: 16)),
                        Text(
                          ans,
                          maxLines: null,
                          style: TextStyle(color: Colors.green, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ],
    ),
  );
}



