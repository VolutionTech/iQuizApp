import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Application/DBhandler.dart';
import '../../Application/DataCacheManager.dart';
import '../../Models/CategoryModel.dart';
import '../QuizScreen/QuizScreen.dart';
import '../SubmitQuiz/submitQuiz.dart';

class DataSearch extends SearchDelegate<QuizModel> {
  final QuizResponseModel? data = DataCacheManager().category;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      Visibility(
        visible: query.isNotEmpty,
        child: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          },
        ),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Leading icon on the left of the AppBar
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = data?.data
        .where((element) =>
            element.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: results?.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(results?[index].name ?? ""),
          onTap: () {
            //  close(context, results[index]);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Show suggestions as the user types
    List<QuizModel>? suggestionList = query.isEmpty
        ? data?.data
        : data?.data
            .where((element) => element.name
                .toLowerCase()
                .trim()
                .contains(query.toLowerCase().trim()))
            .toList();

    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: ListView.builder(
        itemCount: suggestionList?.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Column(
              children: [
                Row(
                  children: [
                    Container(
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.6),
                        child: Text(
                          suggestionList?[index].name ?? "",
                          maxLines: null,
                        )),
                    Spacer(),
                    FutureBuilder(
                      future: DatabaseHandler().getItemAgainstQuizID(
                          suggestionList?[index].id ?? ""),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.active:
                          case ConnectionState.waiting:
                            return Text('');
                          case ConnectionState.done:
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if ((suggestionList?[index].totalQuestions !=
                                    0) &&
                                (snapshot.data?.length != null) &&
                                (snapshot.data!.isNotEmpty)) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 0.0),
                                child: Text(
                                  "${(((snapshot.data?.length ?? 0) / suggestionList![index].totalQuestions) * 100).toInt()}% completed",
                                  style: TextStyle(color: Colors.blue),
                                ),
                              );
                            } else {
                              return Text('');
                            }
                        }
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Divider(),
                )
              ],
            ),
            onTap: () async {
              var category = suggestionList![index];
              List<Map<String, dynamic>> allAttempted =
                  await DatabaseHandler().getItemAgainstQuizID(category.id);
              if (allAttempted.length == category.totalQuestions) {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                Get.to(() => SubmitQuiz(category.id, category.name, prefs));
              } else {
                Get.to(() => QuizScreen(
                      currentIndex: allAttempted.length,
                      quizId: category.id,
                      quizName: category.name,
                    ));
              }
            },
          );
        },
      ),
    );
  }
}
