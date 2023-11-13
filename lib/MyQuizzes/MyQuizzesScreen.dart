import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:imm_quiz_flutter/QuizAppController.dart';
import 'package:imm_quiz_flutter/QuizScreen.dart';
import 'package:imm_quiz_flutter/constants.dart';
import 'package:imm_quiz_flutter/util/util.dart';
import '../Cache/DataCacheManager.dart';
import '../Category/CategoryModel.dart';
import '../DBhandler/DBhandler.dart';
import '../Shimmer/ShimmerGrid.dart';
import '../url.dart';

class MyQuizzes extends StatelessWidget {
  QuizAppController controller = Get.put(QuizAppController());

  List<Color> randomColors = getRandomColorsList();
  var dbHandler = DatabaseHandler();

  CategoryScreen() {
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quizzes"),
        backgroundColor: appbarColor,
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              _showConfirmationDialog(context);
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Category>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ShimmerGrid();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('No categories found');
          }
          var categories = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
              ),
              itemCount: categories.length,
              itemBuilder: (BuildContext context, int index) {
                var category = categories[index];
                return InkWell(
                  onTap: () async {
                    List<Map<String, dynamic>> allAttempted = await dbHandler.getItemAgainstQuizID(category.id);
                    Get.to(() =>
                        QuizView(
                          currentIndex: allAttempted.length,
                          reviewMode: false,
                          quizId: category.id,
                          quizName: category.name,
                        ));
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
                            SizedBox(height: 10,),
                            Text(
                              category.name,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Spacer(),

                            FutureBuilder(
                              future: dbHandler.getItemAgainstQuizID(
                                  category.id),
                              builder: (BuildContext context, AsyncSnapshot<
                                  List<Map<String, dynamic>>> snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.none:
                                    return Text('Press button to start.');
                                  case ConnectionState.active:
                                  case ConnectionState.waiting:
                                    return Text('Awaiting result...');
                                  case ConnectionState.done:
                                    if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else if ((category.totalQuestions != 0) &&
                                        (snapshot.data?.length != null) &&
                                        (snapshot.data!.isNotEmpty)) {
                                      return LinearProgressIndicator(
                                        value: (snapshot.data?.length ?? 0) /
                                            category.totalQuestions,
                                      color: Colors.white,
                                        backgroundColor: Colors.white.withAlpha(50),
                                      );
                                    } else {
                                      return Text('');
                                    }
                                }
                              },
                            ),

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
                _logout();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _logout() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.signOut();
    print('User logged out');
  }

  Future<List<Category>> filterMyQuiz(List<Category> list) async {
    List<Map<String, dynamic>> allAttempted = await dbHandler.getAllItems();
    List<dynamic> quizIds = allAttempted.map((e) => e['quiz_id'] ?? "").toSet().toList();
    List<Category> filteredList = list.where((quiz) => quizIds.contains(quiz.id)).toList();
    return filteredList;
  }


  Future<List<Category>> fetchData() async {
    if (DataCacheManager().category != null) {
      return await filterMyQuiz(DataCacheManager().category!);
    }
    final response = await http.get(Uri.parse(baseURL + categoryEndPoint));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body)['data'];
      var categoryList = jsonData.map((category) => Category.fromJson(category))
          .toList();
      DataCacheManager().category = categoryList;
      return await filterMyQuiz(categoryList);
    } else {
      throw Exception('Failed to load categories');
    }
  }
}
