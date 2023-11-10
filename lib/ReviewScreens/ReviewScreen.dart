import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:imm_quiz_flutter/DBhandler/DBhandler.dart';
import 'package:imm_quiz_flutter/QuizAppController.dart';
import 'package:imm_quiz_flutter/constants.dart';

import '../url.dart';

class ReviewScreen extends StatelessWidget {
  var categoryID = "";
  List<Map<String, dynamic>> allItems = [];
  ReviewScreen(this.categoryID);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbarColor,
        title: Text("Review"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: _fetchData(), // Replace with your actual future function
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator()); // Placeholder for loading state
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                List<Map<String, dynamic>>? reviewDataList = snapshot.data;
                return Column(
                  children: reviewDataList!.asMap().entries.map((entry) {
                    int index = entry.key;
                    dynamic reviewData = entry.value;
                     return ReviewBlock(
                      '${index + 1}) ' + reviewData['question'],
                      reviewData['options'][allItems[index]['correctOption']],
                       (allItems[index]['correctOption'] == allItems[index]['selectedOption'])
                           ? "" : reviewData['options'][allItems[index]['selectedOption']],
                    );
                  }).toList(),
                );

              }
            },
          )
          ,
        ),
      ),
    );
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

  Future<List<Map<String, dynamic>>> _fetchData() async {
    try {
      allItems = await DatabaseHandler().getAllItems(this.categoryID);;
      final response = await http.get(Uri.parse(getCategoryURL(this.categoryID)));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
