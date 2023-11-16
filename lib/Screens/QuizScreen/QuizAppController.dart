import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Application/Constants.dart';
import '../../Application/DBhandler.dart';
import '../../Application/url.dart';
import '../../Models/QuizQuestionModel.dart';
import 'package:http/http.dart' as http;
class QuizAppController extends GetxController {

  String quizId = "";
  String quizName = "";

  var selectedOptsColor = Colors.grey.withAlpha(200);
  var unSelectedOptsColor = Colors.grey.withAlpha(50);

  RxList<QuizQuestion> quizData = <QuizQuestion>[].obs;
  RxInt currentQuestionSelectedOption = (-1).obs;
  RxInt currentIndex = 0.obs;

  moveNext({double delay = 0, Function? quizCompletion}) async {
    await Future.delayed(Duration(milliseconds: (delay*1000).toInt()));
    if ((currentIndex.value + 1) >= quizData.length && quizCompletion != null) {
      await quizCompletion();
    } else {
      currentIndex.value++;
      await getSelectedValue(idx: currentIndex.value);
    }
  }
  moveBack({int delay = 0}) async {
    await Future.delayed(Duration(seconds: delay));
    currentIndex.value--;
    await getSelectedValue(idx: currentIndex.value);
  }

  getSelectedValue({required int idx}) async {
    if (idx < quizData.length) {
      var dbValues = await DatabaseHandler().getItem(quizData.value[idx].id, quizId);
      if (dbValues.isNotEmpty) {
        var selectedOpt = dbValues.first[DBKeys.KEY_SELECTED_OPTION];
        if (selectedOpt != null) {
          this.currentQuestionSelectedOption.value = getIndexFromLetter(selectedOpt);
          return;
        }
      }
    }
    this.currentQuestionSelectedOption.value = -1;
  }
  saveInSession(String questionId, index) async {
    var dbHandler = DatabaseHandler();
    var existingItem =
    await dbHandler.getItem(questionId, quizId);

    if (existingItem.isNotEmpty) {
      await dbHandler.updateItem({
        "selected_option": getLetterAtIndex(index),
      }, questionId, quizId);
    } else {
      await dbHandler.insertItem({
        "question_id": quizData[currentIndex.value].id,
        "selected_option": getLetterAtIndex(index),
        "quiz_id": quizId
      });
    }
    currentQuestionSelectedOption.value = -1;
  }

  String getLetterAtIndex(int index) {
    if (index >= 0) {
      return String.fromCharCode('A'.codeUnitAt(0) + (index % 26));
    } else {
      throw ArgumentError('Index must be a non-negative integer.');
    }
  }
  int getIndexFromLetter(String letter) {
    String lowerCaseAnswer = letter.toLowerCase();
    int answerNumber = lowerCaseAnswer.codeUnitAt(0) - 'a'.codeUnitAt(0);
    return answerNumber < 0 ? 0 : answerNumber;
  }



  fetchQuestions(String quizId) async {
    print(baseURL+questionsEndPoint+quizId);
    final response = await http.get(Uri.parse(baseURL+questionsEndPoint+quizId));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body)['data'];
      var data = jsonData.map((question) => QuizQuestion.fromJson(question)).toList();
      quizData.value = data;
    } else {
      throw Exception('Failed to load questions ' + response.body.toString());
    }
  }

  Future<bool> isToShowNext() async {
    List<Map<String, dynamic>> allAttempted = await DatabaseHandler().getItemAgainstQuizID(quizId);
    if (currentIndex < allAttempted.length) {
      return true;
    }
    return false;
  }


}
