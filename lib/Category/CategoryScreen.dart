import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:imm_quiz_flutter/QuizScreen.dart';
import 'package:imm_quiz_flutter/constants.dart';

class CategoryScreen extends StatelessWidget {
  List<Map<String, dynamic>>? randomColors;


  CategoryScreen()  {
    randomColors = generateRandomColors(100);
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection(collectionCategory).orderBy("time").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        var categories = snapshot.data!.docs;
        var categoryData = categories.map((category) => category.data() as Map<String, dynamic>).toList();
        print(categoryData);
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns in the grid
              mainAxisSpacing: 10.0, // Space between rows
              crossAxisSpacing: 10.0, // Space between columns

            ),
            itemCount: categoryData.length,
            itemBuilder: (BuildContext context, int index) {
              var category = categoryData[index];
              return InkWell(
                onTap: () {
                  Get.to(QuizView(category: categoryData[index]));
                },
                child: Container(
                    decoration: BoxDecoration(
                      color: randomColors![index]['color'],
                    borderRadius: BorderRadius.circular(10), // Adjust the radius to control the roundness
                boxShadow: [
                BoxShadow(
                color: Colors.grey.withOpacity(0.1), // Shadow color
                spreadRadius: 5, // Spread radius
                blurRadius: 7, // Blur radius
                offset: Offset(0, 3), // Offset in x and y
                ),
                ],
                    ),

                child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/images/exam.png", width: 25,),
                          SizedBox(height: 10,),
                          Text(category['name'], style: TextStyle(fontWeight: FontWeight.w500, color: randomColors![index]['textColor']), textAlign: TextAlign.center,),
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
    );
  }

  List<Map<String, dynamic>> generateRandomColors(int count) {
    Random random = Random();
    List<Map<String, dynamic>> colors = [];

    for (int i = 0; i < count; i++) {
      Color randomColor = Color.fromRGBO(
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
        1.0,
      );

      // Determine perceived brightness of the background color
      double luminance = randomColor.computeLuminance();
      Color textColor = luminance > 0.5 ? Colors.black : Colors.white;

      colors.add({
        'color': randomColor,
        'textColor': textColor,
      });
    }

    return colors;
  }

}
