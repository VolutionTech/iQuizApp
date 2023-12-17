import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imm_quiz_flutter/widgets/Shimmer/QuizPlaceholder.dart';

import '../../Application/Constants.dart';
import '../SubmitQuiz/submitQuiz.dart';
import 'QuizAppController.dart';

class QuizScreen extends StatelessWidget {
  late QuizAppController controller;
  var isReviewScreen = false;
  QuizScreen({
    required String quizId,
    required String quizName,
    required int currentIndex,
    this.isReviewScreen = false,
  }) {
    controller = Get.put(QuizAppController());
    controller.quizId = quizId;
    controller.quizName = quizName;
    controller.currentIndex.value = currentIndex;
    controller.fetchQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Application.appbarColor,
          title: Text(controller.quizName),
          automaticallyImplyLeading: isReviewScreen ? false : true,
          actions: [
            if (isReviewScreen) ...[
              TextButton(
                onPressed: () {
                  Get.offAll(
                      () => SubmitQuiz(controller.quizId, controller.quizName));
                },
                child: Text(
                  "Submit",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ]),
      body: Obx(() {
        if (controller.quizData.isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
            child: SingleChildScrollView(
              child: Column(children: [
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: controller.currentIndex > 0
                            ? IconButton(
                                onPressed: () {
                                  controller.moveBack();
                                },
                                icon: Icon(Icons.arrow_back))
                            : SizedBox(width: 50),
                      ),
                      Spacer(),
                      Text(
                          "${controller.currentIndex.value + 1}/${controller.quizData.length}",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 18)),
                      Spacer(),
                      FutureBuilder(
                          future: controller.isToShowNext(isReviewScreen),
                          initialData: false,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return SizedBox(
                                width: 50,
                                child: snapshot.data ?? false
                                    ? IconButton(
                                        onPressed: () {
                                          controller.moveNext();
                                        },
                                        icon: Icon(Icons.arrow_forward))
                                    : SizedBox(),
                              );
                            } else {
                              return SizedBox(
                                width: 50,
                              );
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
                          controller
                              .quizData[controller.currentIndex.value].question,
                      style: TextStyle(fontSize: 18.0, color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Column(
                  children: List.generate(
                    controller
                        .quizData[controller.currentIndex.value].options.length,
                    (index) {
                      var currentQuestion =
                          controller.quizData[controller.currentIndex.value];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: InkWell(
                          onTap: () async {
                            controller.currentQuestionSelectedOption.value =
                                index;

                            try {
                              await controller.player
                                  .play(AssetSource('click.mp3'));
                            } catch (e) {
                              print(e);
                            }
                            await controller.saveInSession(
                                currentQuestion.id, index);
                            await controller.moveNext(
                                delay: 0.3,
                                quizCompletion: () {
                                  Get.offAll(() => SubmitQuiz(
                                      controller.quizId, controller.quizName));
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            ),
          );
        } else {
          return QuizPlaceholder();
        }
      }),
    );
  }
}
