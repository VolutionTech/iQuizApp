import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Application/AppConfiguration.dart';
import '../../Application/DBhandler.dart';
import '../../Models/CategoryModel.dart';
import '../../Services/QuizServices.dart';
import '../../widgets/Shimmer/ShimmerGrid.dart';
import '../Category/AllQuizScreen.dart';
import '../QuizScreen/QuizAppController.dart';
import 'CategorySearchScreen.dart';

class CategoryScreen extends StatelessWidget {
  final QuizAppController controller = Get.find();
  final FocusNode _focusNode = FocusNode();
  final fontSizeMultper = 0.031;
  final dbHandler = DatabaseHandler();
  List<Color> randomColors = Application.getRandomColorsList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          return Text(controller.showSearchInCate.value
              ? "Search Quizzes"
              : "Categories");
        }),
        backgroundColor: Application.appbarColor,
        actions: [
          IconButton(
            icon: Obx(() {
              return Icon(controller.showSearchInCate.value
                  ? Icons.close
                  : Icons.search);
            }),
            onPressed: () async {
              controller.showSearchInCate.toggle();
              if (controller.showSearchInCate.value) {
                controller.controller.forward();
              } else {
                if (_focusNode.hasFocus) {
                  _focusNode.unfocus();
                  await Future.delayed(Duration(milliseconds: 350));
                }
                controller.controller.reverse();
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<CategoryListModel?>(
        future: QuizServices().fetchCategory(),
        builder: (context, snapshot) {
          controller.controllerQ.reset();
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ShimmerCatGrid();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
            return Center(child: Text('No categories found'));
          }
          var categories = snapshot.data!.data;
          return Stack(
            children: [
              FadeTransition(
                opacity: controller.opacityAnimation,
                child: CategorySearchScreen(categories, _focusNode),
              ),
              SlideTransition(
                position: controller.offset,
                child: _buildListView(categories, context),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildListView(List<CategoryModel> categories, BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:
                MediaQuery.of(context).orientation == Orientation.portrait
                    ? 3
                    : 4,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
          ),
          itemCount: categories.length,
          itemBuilder: (BuildContext context, int index) {
            var category = categories[index];
            return InkWell(
              onTap: () async {
                controller.controller.reset();
                Get.to(() => AllQuizScreen(category.id, category.name));
              },
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: dbHandler.getItemAgainstQuizID(category.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      snapshot.hasError) {
                    return Container(); // Show an empty container while waiting or in case of an error
                  } else {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/icons/${category.name.replaceAll(" ", "")}.jpg'), // Replace with your image asset
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          color: Colors.black.withOpacity(0.65),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Image(
                                  //     image: AssetImage(
                                  //         'assets/icons/CharacterProfiles.jpg')),
                                  Text(
                                    category.name,
                                    softWrap: true,
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              fontSizeMultper,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Quizzes: ${category.count}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              fontSizeMultper *
                                              0.9,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            ),
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
    );
  }
}
