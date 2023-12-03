import 'dart:convert';
import 'package:flutter_button_type/flutter_button_type.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:imm_quiz_flutter/Application/Constants.dart';
import 'package:imm_quiz_flutter/Screens/QuizScreen/QuizScreen.dart';
import 'package:imm_quiz_flutter/Services/HistoryServices.dart';
import '../../Application/DBhandler.dart';
import '../ResultScreen/result_screen.dart';


class SubmitQuiz extends StatelessWidget {
  var quizId;
  var quizName;
      SubmitQuiz(this.quizId, this.quizName);
      var isLoading = false.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      title: Text("Review"),
      backgroundColor: Application.appbarColor,
        automaticallyImplyLeading: false,
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
                  Get.to(()=>QuizScreen(quizId: quizId, quizName: quizName, currentIndex: 0, isReviewScreen: true));
                }
                ,
              ),
              SizedBox(height: 15,),
              Obx(() => isLoading.value ? SizedBox(width: 50, height: 50, child: CircularProgressIndicator(backgroundColor: Application.appbarColor,),) : FlutterTextButton(
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
                  isLoading.value = true;
                  await HistoryService().submitHistory(quizId, answers, (result) {
                    isLoading.value = false;
                    Get.offAll(ResultScreen(result.result, false));
                  });
                }
                ,
              )),

        ],)
        ,),
      )
      ,);
  }

}
