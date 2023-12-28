import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imm_quiz_flutter/Screens/SubmitQuiz/submitQuiz.dart';
import 'package:imm_quiz_flutter/Services/HistoryServices.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Application/Constants.dart';
import '../../Application/DBhandler.dart';
import '../../Application/util.dart';
import '../../Models/QuizListModel.dart';
import '../../Services/QuizServices.dart';
import '../../widgets/Shimmer/ShimmerGrid.dart';
import '../QuizScreen/QuizAppController.dart';
import '../QuizScreen/QuizScreen.dart';
import '../ResultScreen/result_screen.dart';
import 'DataSearch.dart';

class AllQuizScreen extends StatelessWidget {
  QuizAppController controller = Get.find();
  var isTileLoad = 10000.obs;
  List<Color> randomColors = getRandomColorsList();
  var dbHandler = DatabaseHandler();
  String id;
  String name;
  AllQuizScreen(this.id, this.name);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
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
          FutureBuilder(
            future: SharedPreferences.getInstance(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data!.getBool(SharedPrefKeys.KEY_ISLOGIN) ==
                    true) {
                  return IconButton(
                    icon: Icon(Icons.exit_to_app),
                    onPressed: () {
                      _showConfirmationDialog(context);
                    },
                  );
                }
              }
              return SizedBox();
            },
          ),
        ],
      ),
      body: FutureBuilder<QuizResponseModel?>(
        future: QuizServices().fetchQuizzes(id),
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
                    if (category.attempted != null && allAttempted.isEmpty) {
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
                    } else if (allAttempted.length == category.totalQuestions) {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      Get.to(
                          () => SubmitQuiz(category.id, category.name, prefs));
                    } else {
                      print("going Constructor ,,..");
                      controller.reset();
                      var result = await Get.to(() => QuizScreen(
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
                      if (snapshot.connectionState == ConnectionState.waiting ||
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
                                            future:
                                                dbHandler.getItemAgainstQuizID(
                                                    category.id),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<
                                                        List<
                                                            Map<String,
                                                                dynamic>>>
                                                    snapshot) {
                                              switch (
                                                  snapshot.connectionState) {
                                                case ConnectionState.none:
                                                  return SizedBox();
                                                case ConnectionState.active:
                                                case ConnectionState.waiting:
                                                  return SizedBox();
                                                case ConnectionState.done:
                                                  if (snapshot.hasError) {
                                                    return Text(
                                                        'Error: ${snapshot.error}');
                                                  } else if ((category.totalQuestions !=
                                                          0) &&
                                                      (snapshot.data?.length !=
                                                          null) &&
                                                      (snapshot
                                                          .data!.isNotEmpty)) {
                                                    return LinearProgressIndicator(
                                                      backgroundColor: Colors
                                                          .white
                                                          .withAlpha(50),
                                                      color: Colors.white,
                                                      value: (snapshot.data
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
                                                                ? CircularProgressIndicator(
                                                                    color: Colors
                                                                        .white,
                                                                  )
                                                                : Text(
                                                                    "Completed",
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w900,
                                                                        color: Colors
                                                                            .white),
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
