import 'dart:convert';
import 'package:flutter_button_type/flutter_button_type.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imm_quiz_flutter/ResultScreen/result_screen.dart';
import 'package:imm_quiz_flutter/constants.dart';
import 'package:imm_quiz_flutter/url.dart';

import 'Cache/DataCacheManager.dart';
import 'DBhandler/DBhandler.dart';
import 'history/HistoryScreen.dart';

class SubmitQuiz extends StatelessWidget {
  var quizId;
      SubmitQuiz(this.quizId);
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      title: Text("Review"),
      backgroundColor: appbarColor,
    ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          width: double.infinity,
          color: Colors.white,
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15,),
              Text("Quiz done! 🎉", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),textAlign: TextAlign.center,),
              SizedBox(height: 5,),
              Text("Keep up the great work! 😊", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),textAlign: TextAlign.center,),
              SizedBox(height: 15,),
              Text("Before submitting, review all quiz answers meticulously. No edits will be possible post-submission. Take time to ensure accuracy and completeness of each response as changes won't be allowed afterward.",
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13), textAlign: TextAlign.start,),

              SizedBox(height: 15,),
              FlutterTextButton(
                buttonText: 'Review',
                buttonColor: Colors.black,
                textColor: Colors.white,
                buttonHeight: 50,
                buttonWidth: double.infinity,
                onTap: () async {
                  Get.back();
                }
                ,
              ),
              SizedBox(height: 15,),
              FlutterTextButton(
                buttonText: 'Submit Quiz',
                buttonColor: Colors.black,
                textColor: Colors.white,
                buttonHeight: 50,
                buttonWidth: double.infinity,
                onTap: () async {
                  List<Map<String, dynamic>> results = await DatabaseHandler()
                      .getItemAgainstQuizID(quizId);
                  List<Map<String, String>> answers = [];
                  results.forEach((element) {
                    answers.add({
                      'question': element['question_id'],
                      'selectedOption': element['selected_option'],
                    });
                  });
                  await submitHistory(quizId, answers, (result) {
                    Get.to(ResultScreen(result));
                  });
                }
    ,
              ),

        ],)
        ,),
      )
      ,);
  }

  Future<void> submitHistory(String quizId, List<Map<String, String>> answers, void Function(QuizHistory) success) async {
    final String apiUrl = baseURL+historyEndPoint;
    print(answers);
    // Prepare the request body
    final Map<String, dynamic> requestBody = {
      'quiz': quizId,
      'answers': answers,
    };

    // Convert the request body to JSON
    final String requestBodyJson = jsonEncode(requestBody);

    try {
      // Make the POST request
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json',
          'Authorization':
          'Bearer ${DataCacheManager().headerToken}',
        },
        body: requestBodyJson,
      );

      // Check the response status
      if (response.statusCode == 200) {
        print('API Request Successful');
        print('Response: ${response.body}');
        final Map<String, dynamic> jsonData = json.decode(response.body)['result'];
        print(jsonData);
        success(QuizHistory.fromJson(jsonData));
        DatabaseHandler().delete(quizId);
      } else {
        print('API Request Failed');
        print('Status Code: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }


}
