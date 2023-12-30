import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Application/DBhandler.dart';
import '../../Models/CategoryModel.dart';
import '../../Models/QuizListModel.dart';
import '../../Services/HistoryServices.dart';
import '../QuizScreen/QuizAppController.dart';
import '../QuizScreen/QuizScreen.dart';
import '../ResultScreen/result_screen.dart';
import '../SubmitQuiz/submitQuiz.dart';

class CategorySearchScreen extends StatelessWidget {
  late List<
      CategorySearchResults> categoryList; // Assuming you have the category list
  var filteredList = [].obs; // Assuming you have the category list
  late FocusNode _focusNode;
  QuizAppController controller = Get.find();

  CategorySearchScreen(List<CategoryModel> categories, focusNode) {
    this._focusNode = focusNode;

    categoryList = [];
    print(categories);
    categories.forEach((cate) {
      print(cate.quizzes);
      if (cate.quizzes != null) {
        cate.quizzes!.forEach((quiz) {
          categoryList.add(
              CategorySearchResults(
                  quiz.id, quiz.name, cate.name, 0, null, quiz.totalQuestions));
        });
      }
    });
    filteredList.value = categoryList;
  }

  CategorySearchScreen.initial(QuizResponseModel categories, focusNode) {
    this._focusNode = focusNode;

    categoryList = [];
    print(categories);
    categories.data.forEach((cate) async {
      print(cate.name);
      categoryList.add(
          CategorySearchResults(
              cate.id, cate.name, "", 50, cate.attempted, cate.totalQuestions));
      filteredList.value = categoryList;
    });
    filteredList.value = categoryList;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(() {
            return TextField(
              autofocus: (controller.showSearchInQuizScreen.value || controller.showSearchInCate.value) ? true : false,
              focusNode: _focusNode,
              onEditingComplete: () {

              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                    vertical: 5.0, horizontal: 10.0), // Adjust vertical padding
                hintText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: (value) {
                if (value.isEmpty) {
                  filteredList.value = this.categoryList;
                } else {
                  filteredList.value = categoryList.where((search) =>
                  search.categoryName.toLowerCase().contains(
                      value.toLowerCase()) ||
                      search.quizName.toLowerCase().contains(
                          value.toLowerCase()))
                      .toList();
                }
              },
            );
          }),
        ),
        Expanded(
          child: Obx(() {
            return ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredList[index].quizName,
                    style: TextStyle(fontSize: 14),),
                  subtitle: filteredList[index].progress != 0 ?
                  FutureBuilder(future: DatabaseHandler().getItemAgainstQuizID(
                      filteredList[index].id ?? ""),
                      builder: (builder, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          var progress = snapshot.data?.length ?? 0;
                          return Text("${progress}% completed",
                            style: TextStyle(color: Color(0xff006400)),);
                        } else {
                          return SizedBox();
                        }
                      })


                      :
                  Row(
                    children: [
                      Text(
                          "Category: ", style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w500)),
                      Text(
                          filteredList[index].categoryName,
                          style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  onTap: () async {
                    controller.showSearchInCate.value = false;
                    controller.controller.reverse();
                    controller.showSearchInQuizScreen.value = false;
                    controller.controllerQ.reverse();
                    print("Going to quiz screen69");
                    var dbHandler = DatabaseHandler();
                    List<Map<String, dynamic>> allAttempted =
                    await dbHandler.getItemAgainstQuizID(
                        filteredList[index].id);
                    print("DB loaded69");
                    print(filteredList[index].attempted);
                    print(filteredList[index].attempted != null &&
                        allAttempted.isEmpty);
                    print(allAttempted);
                    if (filteredList[index].attempted != null &&
                        allAttempted.isEmpty) {
                      print(index);
                      await HistoryService()
                          .fetchHistory(filteredList[index].attempted!)
                          .then((history) async {
                        print("history");
                        if (history?.histories.first != null) {
                          Get.to(() =>
                              ResultScreen(
                                  history!.histories.first, true,
                                  showRetry: true,
                                  categoriID: filteredList[index].id));
                        }
                      });
                    }
                    else if (allAttempted.length == filteredList[index]
                        .totalQuestions) {
                      print("DB loadsed");
                      SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                      Get.to(
                              () =>
                              SubmitQuiz(filteredList[index].id,
                                  filteredList[index].quizName, prefs));
                    }
                    else {
                      print("quizId: ${filteredList[index].id}");
                      controller.reset();
                      var _ = await Get.to(() =>
                          QuizScreen(
                            currentIndex: allAttempted.length,
                            quizId: filteredList[index].id,
                            quizName: filteredList[index].quizName,
                          ));
                      controller.totalScreen.value += 1;
                    }
                  },
                );
              },
            );
          }),
        ),
      ],
    ),);
  }
}

class CategorySearchResults {
  String quizName;
  String id;
  String categoryName;
  double progress;
  String? attempted;
  int totalQuestions;

  CategorySearchResults(this.id, this.quizName, this.categoryName,
      this.progress, this.attempted, this.totalQuestions);
}