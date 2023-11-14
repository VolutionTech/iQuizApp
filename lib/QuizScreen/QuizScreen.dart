import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';


class QuizScreen extends StatelessWidget {
  String quizId = "";
  String quizName = "";
  int currentIndex = 0;
  QuizScreen({required String quizId, required String quizName, required int currentIndex}) {
    this.quizId = quizId;
    this.quizName = quizName;
    this.currentIndex = currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: appbarColor,
          title: Text(quizName),
        )
    );
  }
}
