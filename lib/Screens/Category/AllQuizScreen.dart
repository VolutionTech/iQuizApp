import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imm_quiz_flutter/Screens/SubmitQuiz/submitQuiz.dart';
import 'package:imm_quiz_flutter/Services/HistoryServices.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Application/AppConfiguration.dart';
import '../../Application/DBhandler.dart';
import '../../Models/QuizListModel.dart';
import '../../Services/QuizServices.dart';
import '../../widgets/Shimmer/ShimmerGrid.dart';
import '../CategoryScreen/CategorySearchScreen.dart';
import '../QuizScreen/QuizAppController.dart';
import '../QuizScreen/QuizScreen.dart';
import '../ResultScreen/result_screen.dart';

class AllQuizScreen extends StatelessWidget {
  QuizAppController controller = Get.find();
  var isTileLoad = 10000.obs;
  final fontSizeMultper = 0.03;
  final FocusNode _focusNode = FocusNode();

  List<Color> randomColors = Application.getRandomColorsList();
  var dbHandler = DatabaseHandler();
  String id;
  String name;
  AllQuizScreen(this.id, this.name) {
    controller.showSearchInCate.value = false;
    controller.controller.reverse();
    controller.showSearchInQuizScreen.value = false;
    controller.controllerQ.reverse();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          textAlign: TextAlign.start,
          text: TextSpan(
              text: "Quizzes",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: '\n$name',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ]),
        ),
        centerTitle: false,
        backgroundColor: Application.appbarColor,
        actions: [
          IconButton(
            icon: Obx(() {
              return Icon(controller.showSearchInQuizScreen.value
                  ? Icons.close
                  : Icons.search);
            }),
            onPressed: () async {
              controller.showSearchInQuizScreen.toggle();
              if (controller.showSearchInQuizScreen.value) {
                controller.controllerQ.forward();
              } else {
                if (_focusNode.hasFocus) {
                  _focusNode.unfocus();
                  await Future.delayed(Duration(milliseconds: 350));
                }
                controller.controllerQ.reverse();
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<QuizResponseModel?>(
        future: QuizServices().fetchQuizzes(id, enableCache: false),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ShimmerGrid();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
            return Text('No categories found');
          }
          var categories = snapshot.data!;
          return Stack(
            children: [
              FadeTransition(
                opacity: controller.opacityAnimationQ,
                child: CategorySearchScreen.initial(categories, _focusNode),
              ),
              SlideTransition(
                position: controller.offsetQ,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: MediaQuery.of(context).orientation ==
                              Orientation.portrait
                          ? 3
                          : 4,
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                    ),
                    itemCount: categories.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      var category = categories.data[index];
                      return InkWell(
                        onTap: () async {
                          List<Map<String, dynamic>> allAttempted =
                              await dbHandler.getItemAgainstQuizID(category.id);
                          if (category.attempted != null &&
                              allAttempted.isEmpty) {
                            isTileLoad.value = index;
                            print(index);
                            await HistoryService()
                                .fetchHistory(category.attempted!)
                                .then((history) async {
                              isTileLoad.value = 10000;
                              print("history");
                              if (history?.histories.first != null) {
                                Get.to(() => ResultScreen(
                                    history!.histories.first, true,
                                    showRetry: true, categoriID: category.id));
                              }
                            });
                          } else if (allAttempted.length ==
                              category.totalQuestions) {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            Get.to(() =>
                                SubmitQuiz(category.id, category.name, prefs));
                          } else {
                            controller.reset();
                            var _ = await Get.to(() => QuizScreen(
                                  currentIndex: allAttempted.length,
                                  quizId: category.id,
                                  quizName: category.name,
                                ));
                            controller.totalScreen.value += 1;
                          }
                        },
                        child: FutureBuilder<List<Map<String, dynamic>>>(
                          future: dbHandler.getItemAgainstQuizID(category.id),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.waiting ||
                                snapshot.hasError) {
                              // Show an empty container while waiting or in case of an error
                              return Container();
                            } else {
                              // Your provided Container code snippet
                              return Container(
                                decoration: BoxDecoration(
                                  color: (category.attempted != null &&
                                          snapshot.data?.isNotEmpty == false)
                                      ? Colors.green
                                      : randomColors[index],
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Spacer(),
                                        Text(
                                          category.name,
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                fontSizeMultper,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Spacer(),
                                        Obx(() {
                                          return controller.totalScreen.value >
                                                  1
                                              ? FutureBuilder(
                                                  future: dbHandler
                                                      .getItemAgainstQuizID(
                                                          category.id),
                                                  builder: (BuildContext
                                                          context,
                                                      AsyncSnapshot<
                                                              List<
                                                                  Map<String,
                                                                      dynamic>>>
                                                          snapshot) {
                                                    switch (snapshot
                                                        .connectionState) {
                                                      case ConnectionState.none:
                                                        return SizedBox();
                                                      case ConnectionState
                                                            .active:
                                                      case ConnectionState
                                                            .waiting:
                                                        return SizedBox();
                                                      case ConnectionState.done:
                                                        if (snapshot.hasError) {
                                                          return Text(
                                                              'Error: ${snapshot.error}');
                                                        } else if ((category.totalQuestions !=
                                                                0) &&
                                                            (snapshot.data
                                                                    ?.length !=
                                                                null) &&
                                                            (snapshot.data!
                                                                .isNotEmpty)) {
                                                          return LinearProgressIndicator(
                                                            backgroundColor:
                                                                Colors
                                                                    .white
                                                                    .withAlpha(
                                                                        50),
                                                            color: Colors.white,
                                                            value: (snapshot
                                                                        .data
                                                                        ?.length ??
                                                                    0) /
                                                                category
                                                                    .totalQuestions,
                                                          );
                                                        } else {
                                                          return Obx(() => controller
                                                                  .pHolder.value
                                                              ? (category.attempted !=
                                                                      null
                                                                  ? isTileLoad.value ==
                                                                          index
                                                                      ? SizedBox(
                                                                          height:
                                                                              20,
                                                                          width:
                                                                              20,
                                                                          child:
                                                                              CircularProgressIndicator(
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        )
                                                                      : Text(
                                                                          "Completed",
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w900,
                                                                              fontSize: MediaQuery.of(context).size.width * fontSizeMultper,
                                                                              color: Colors.white),
                                                                        )
                                                                  : SizedBox())
                                                              : Text(''));
                                                        }
                                                    }
                                                  },
                                                )
                                              : SizedBox();
                                        }),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
