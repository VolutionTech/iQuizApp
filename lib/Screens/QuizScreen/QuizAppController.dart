import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Application/Constants.dart';
import '../../Application/DBhandler.dart';
import '../../Models/QuizQuestionModel.dart';
import '../../Services/QuestionServices.dart';

class QuizAppController extends GetxController
    with GetTickerProviderStateMixin {
  String quizId = "";
  String quizName = "";
  var totalScreen = 2.obs;
  var pHolder = true.obs;
  var isViewDiable = false.obs;
  var showNavbar = true.obs;

  // Animation things for category Screen
  var showSearchInCate = false.obs;
  late AnimationController controller;
  late Animation<Offset> offset;
  late Animation<double> opacityAnimation;
  // Animation things for quiz Screen
  var showSearchInQuizScreen = false.obs;
  late AnimationController controllerQ;
  late Animation<Offset> offsetQ;
  late Animation<double> opacityAnimationQ;

  void resetAnimation() {
    showSearchInCate.value = false;
    showSearchInQuizScreen.value = false;
    // controller.reset();
    // controllerQ.reset();
  }

  @override
  void onInit() {
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    controllerQ =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    offset = Tween<Offset>(begin: Offset.zero, end: Offset(0.0, 1.9))
        .animate(controller);
    opacityAnimation = Tween<double>(begin: 0, end: 1).animate(controller);

    offsetQ = Tween<Offset>(begin: Offset.zero, end: Offset(0.0, 1.9))
        .animate(controllerQ);
    opacityAnimationQ = Tween<double>(begin: 0, end: 1).animate(controllerQ);
  }

  var selectedOptsColor = Colors.grey.withAlpha(200);
  var unSelectedOptsColor = Colors.grey.withAlpha(50);

  RxList<QuizQuestion> quizData = <QuizQuestion>[].obs;
  RxInt currentQuestionSelectedOption = (-1).obs;
  RxInt currentIndex = 0.obs;
  final player = AudioPlayer();

  reset() {
    quizId = "";
    quizName = "";
    isViewDiable.value = false;
    totalScreen.value = 2;
    pHolder.value = true;
    quizData.value = <QuizQuestion>[];
    currentQuestionSelectedOption.value = (-1);
    currentIndex.value = 0;
  }

  moveNext({double delay = 0, Function? quizCompletion}) async {
    isViewDiable.value = true;
    await Future.delayed(Duration(milliseconds: (delay * 1000).toInt()));
    if ((currentIndex.value + 1) >= quizData.length && quizCompletion != null) {
      await quizCompletion();
      isViewDiable.value = false;
    } else {
      await getSelectedValue(idx: currentIndex.value + 1);
      currentIndex.value++;
      isViewDiable.value = false;
    }
  }

  moveBack({int delay = 0}) async {
    await Future.delayed(Duration(seconds: delay));
    currentIndex.value--;
    await getSelectedValue(idx: currentIndex.value);
  }

  getSelectedValue({required int idx}) async {
    currentQuestionSelectedOption.value = -1;
    if (idx < quizData.length) {
      var dbValues =
          await DatabaseHandler().getItem(quizData.value[idx].id, quizId);
      if (dbValues.isNotEmpty) {
        var selectedOpt = dbValues.first[DBKeys.KEY_SELECTED_OPTION];
        if (selectedOpt != null) {
          this.currentQuestionSelectedOption.value =
              getIndexFromLetter(selectedOpt);
          return;
        }
      }
    }
    this.currentQuestionSelectedOption.value = -1;
  }

  Future<bool> saveInSession(String questionId, index) async {
    var dbHandler = DatabaseHandler();
    var existingItem = await dbHandler.getItem(questionId, quizId);

    if (existingItem.isNotEmpty) {
      await dbHandler.updateItem({
        "selected_option": getLetterAtIndex(index),
      }, questionId, quizId);

      return true;
    } else {
      await dbHandler.insertItem({
        "question_id": quizData[currentIndex.value].id,
        "selected_option": getLetterAtIndex(index),
        "quiz_id": quizId
      });
      return true;
    }
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

  Future<bool> isToShowNext(isReviewScreen) async {
    List<Map<String, dynamic>> allAttempted =
        await DatabaseHandler().getItemAgainstQuizID(quizId);
    if (currentIndex.value < allAttempted.length - (isReviewScreen ? 1 : 0)) {
      return true;
    }
    return false;
  }

  void fetchQuestions() async {
    print("Loading audio player");

    print("loaded audio player");
    var result = await QuestionService().fetchQuestions(quizId);
    if (result != null) {
      quizData.value = result.data;
      getSelectedValue(idx: currentIndex.value);
    }
  }
}
