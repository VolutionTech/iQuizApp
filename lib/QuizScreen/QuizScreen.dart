import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:imm_quiz_flutter/QuizScreen/QuizAppController.dart';
import 'package:imm_quiz_flutter/Shimmer/ShimmerGrid.dart';

import '../constants.dart';
import '../submitQuiz.dart';

class QuizScreen extends StatelessWidget {
  late QuizAppController controller;
  QuizScreen(
      {required String quizId,
      required String quizName,
      required int currentIndex}) {
    controller = Get.put(QuizAppController());
    controller.quizId = quizId;
    controller.quizName = quizName;
    controller.currentIndex.value = currentIndex;
    controller.fetchQuestions(quizId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbarColor,
        title: Text(controller.quizName),
      ),
      body: Obx(() {
        return controller.quizData.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                child: Column(children: [
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Visibility(
                            visible: controller.currentIndex > 0 ? true : false,
                            child: IconButton(
                                onPressed: () {
                                  controller.moveBack();
                                },
                                icon: Icon(Icons.arrow_back))),
                        Spacer(),
                        Text(
                            "${controller.currentIndex.value + 1}/${controller.quizData.length}",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 18)),
                        IconButton(
                          icon: Icon(Icons.volume_up),
                          onPressed: () async {},
                        ),
                        Spacer(),
                        FutureBuilder(
                            future: controller.isToShowNext(),
                            initialData: false,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return Visibility(
                                    visible: snapshot.data ?? false,
                                    child: IconButton(
                                        onPressed: () {
                                          controller.moveNext();
                                        },
                                        icon: Icon(Icons.arrow_forward)));
                              } else {
                                return SizedBox(width: 50,);
                              }
                            })
                      ],
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Text(
                        "${controller.currentIndex.value + 1}) " +
                            controller.quizData[controller.currentIndex.value]
                                .question,
                        style: TextStyle(fontSize: 18.0, color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Column(
                    children: List.generate(
                      controller.quizData[controller.currentIndex.value].options
                          .length,
                      (index) {
                        var currentQuestion =
                            controller.quizData[controller.currentIndex.value];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: InkWell(
                            onTap: () async {
                              controller.currentQuestionSelectedOption.value =
                                  index;
                              await controller.saveInSession(
                                  currentQuestion.id, index);
                              await controller.moveNext(delay: 0.3, quizCompletion: () {
                                Get.to(() => SubmitQuiz(controller.quizId));
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: index ==
                                        controller
                                            .currentQuestionSelectedOption.value
                                    ? controller.selectedOptsColor
                                    : controller.unSelectedOptsColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      currentQuestion.options[index],
                                      maxLines: null,
                                      style: TextStyle(
                                          color: Colors.black.withAlpha(200),
                                          fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ]),
              )
            : ShimmerGrid();
      }),
    );
  }
}
