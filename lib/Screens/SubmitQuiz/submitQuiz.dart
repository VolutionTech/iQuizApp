import 'dart:convert';
import 'package:flutter_button_type/flutter_button_type.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:imm_quiz_flutter/Application/Constants.dart';
import 'package:imm_quiz_flutter/Application/url.dart';
import 'package:imm_quiz_flutter/Services/HistoryServices.dart';
import '../../Application/DBhandler.dart';
import '../../Application/DataCacheManager.dart';
import '../../Models/QuizHistoryModel.dart';
import '../ResultScreen/result_screen.dart';


class SubmitQuiz extends StatelessWidget {
  var quizId;
      SubmitQuiz(this.quizId);
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      title: Text("Review"),
      backgroundColor: Application.appbarColor,
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
                  await HistoryService().submitHistory(quizId, answers, (result) {
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

}
