import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imm_quiz_flutter/Screens/ResultScreen/result_screen.dart';
import 'package:imm_quiz_flutter/Screens/SubmitQuiz/submitQuiz.dart';
import 'package:imm_quiz_flutter/Services/HistoryServices.dart';
import 'package:imm_quiz_flutter/Services/QuizServices.dart';

import '../../Application/Constants.dart';
import '../../Application/DBhandler.dart';
import '../../Application/util.dart';
import '../../Models/CategoryModel.dart';
import '../../widgets/Shimmer/ShimmerGrid.dart';
import '../QuizScreen/QuizAppController.dart';
import '../QuizScreen/QuizScreen.dart';
import 'DataSearch.dart';

class CategoryScreen extends StatelessWidget {
  QuizAppController controller = Get.put(QuizAppController());
  List<Color> randomColors = getRandomColorsList();
  var dbHandler = DatabaseHandler();

  CategoryScreen() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quizzes"),
        backgroundColor: Application.appbarColor,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: DataSearch(),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              _showConfirmationDialog(context);
            },
          ),
        ],
      ),
      body: FutureBuilder<QuizResponseModel?>(
        future: QuizServices().fetchQuizzes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ShimmerGrid();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
            return Text('No categories found');
          }
          var categories = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? 2
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
                    if (category.attempted != null) {
                      controller.loadingTile.value = index;

                      await HistoryService()
                          .fetchHistory(category.attempted!)
                          .then((history) {
                        controller.loadingTile.value = 10000;
                        print("history");
                        if (history?.histories.first != null) {
                          Get.to(() => ResultScreen(
                              history!.histories.first, true,
                              showRetry: true, categoriID: category.id));
                        }
                      });
                    } else if (allAttempted.length == category.totalQuestions) {
                      Get.to(() => SubmitQuiz(category.id, category.name));
                    } else {
                      var result = await Get.to(() => QuizScreen(
                            currentIndex: allAttempted.length,
                            quizId: category.id,
                            quizName: category.name,
                          ));
                      controller.totalScreen.value += 1;
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: randomColors[index],
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Spacer(),
                            Image.asset(
                              "assets/images/exam.png",
                              width: 30,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              category.name,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Spacer(),
                            Obx(() {
                              return controller.totalScreen.value > 1
                                  ? FutureBuilder(
                                      future: dbHandler
                                          .getItemAgainstQuizID(category.id),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<
                                                  List<Map<String, dynamic>>>
                                              snapshot) {
                                        switch (snapshot.connectionState) {
                                          case ConnectionState.none:
                                            return Text(
                                                'Press button to start.');
                                          case ConnectionState.active:
                                          case ConnectionState.waiting:
                                            return Text('Awaiting result...');
                                          case ConnectionState.done:
                                            if (snapshot.hasError) {
                                              return Text(
                                                  'Error: ${snapshot.error}');
                                            } else if ((category.totalQuestions !=
                                                    0) &&
                                                (snapshot.data?.length !=
                                                    null) &&
                                                (snapshot.data!.isNotEmpty)) {
                                              return LinearProgressIndicator(
                                                backgroundColor:
                                                    Colors.white.withAlpha(50),
                                                color: Colors.white,
                                                value: (snapshot.data?.length ??
                                                        0) /
                                                    category.totalQuestions,
                                              );
                                            } else {
                                              return Text('');
                                            }
                                        }
                                      },
                                    )
                                  : SizedBox();
                            }),
                            Obx(() {
                              return controller.pHolder.value
                                  ? (category.attempted != null
                                      ? controller.loadingTile == index
                                          ? CircularProgressIndicator(
                                              color: Colors.white,
                                            )
                                          : Text(
                                              "Completed",
                                              style: TextStyle(
                                                  color: Colors.green),
                                            )
                                      : SizedBox())
                                  : SizedBox();
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: Text('Do you want to log out?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Logout'),
              onPressed: () {
                logout();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
