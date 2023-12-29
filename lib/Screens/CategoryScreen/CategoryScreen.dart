import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Application/Constants.dart';
import '../../Application/DBhandler.dart';
import '../../Application/util.dart';
import '../../Models/CategoryModel.dart';
import '../../Services/QuizServices.dart';
import '../../widgets/Shimmer/ShimmerGrid.dart';
import '../Category/AllQuizScreen.dart';
import '../QuizScreen/QuizAppController.dart';
class CategoryScreen extends StatelessWidget {
  final QuizAppController controller = Get.find();
  final dbHandler = DatabaseHandler();
  List<Color> randomColors = getRandomColorsList();

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
                if (snapshot.data!.getBool(SharedPrefKeys.KEY_ISLOGIN) == true) {
                  return IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      controller.showSearchInCate.toggle();
                      if (controller.showSearchInCate.value) {
                        controller.controller.forward();
                      } else {
                        controller.controller.reverse();
                      }
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
            return ShimmerCatGrid();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
            return Center(child: Text('No categories found'));
          }
          var categories = snapshot.data!.data;
          return Stack(children: [
            SlideTransition(
              position: controller.offset,
              child: _buildListView(categories, context),
            ),
            FadeTransition(
              opacity: controller.opacityAnimation,
              child: _buildSearchView(),
            )
          ],);
        },
      ),
    );
  }

  Widget _buildSearchView() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text("Biology"),
          subtitle: Text("Science & Technology"),
          onTap: () {
            // Handle tile tap action
          },
        );
      },
    );
  }

  Widget _buildListView(List<CategoryModel> categories, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait ? 3 : 4,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
        ),
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          var category = categories[index];
          return InkWell(
            onTap: () async {
              Get.to(() => AllQuizScreen(category.id, category.name));
            },
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: dbHandler.getItemAgainstQuizID(category.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    snapshot.hasError) {
                  return Container(); // Show an empty container while waiting or in case of an error
                } else {
                  return Container(
                    decoration: BoxDecoration(
                      color: randomColors[index],
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 7,
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
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
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
  }
}


