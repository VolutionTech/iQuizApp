import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imm_quiz_flutter/Screens/Category/CategoryScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Application/Constants.dart';
import '../../Application/DBhandler.dart';
import '../../Application/util.dart';
import '../../Models/CategoryModel.dart';
import '../../Services/QuizServices.dart';
import '../../widgets/Shimmer/ShimmerGrid.dart';
import '../QuizScreen/QuizAppController.dart';

class CategoryScreen extends StatelessWidget {
  QuizAppController controller = Get.find();
  var isTileLoad = 10000.obs;
  List<Color> randomColors = getRandomColorsList();
  var dbHandler = DatabaseHandler();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Categories"),
        backgroundColor: Application.appbarColor,
        actions: [
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
      body: FutureBuilder<CategoryListModel?>(
        future: QuizServices().fetchCategory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ShimmerGrid();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
            return Center(child: Text('No categories found'));
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
                    Get.to(() => AllQuizScreen(category.id, category.name));
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
                              child: Text(
                                category.name,
                                softWrap: true,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
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
