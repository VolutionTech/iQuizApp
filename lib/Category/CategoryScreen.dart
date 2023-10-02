import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:imm_quiz_flutter/QuizAppController.dart';
import 'package:imm_quiz_flutter/QuizScreen.dart';
import 'package:imm_quiz_flutter/constants.dart';

import '../DBhandler/DBhandler.dart';

class CategoryScreen extends StatelessWidget {
  QuizAppController controller = Get.put(QuizAppController());

  List<Color>? randomColors;
  var dbHandler = DatabaseHandler();
  CategoryScreen()  {
    randomColors = generateRandomColors();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Category"), backgroundColor: appbarColor, actions: [
        IconButton(
          icon: Icon(Icons.exit_to_app),
          onPressed: () {
            _showConfirmationDialog(context);
          },
        ),
      ],),

      body: StreamBuilder<QuerySnapshot>(
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
                onTap: () async {

                  List<Map<String, dynamic>> attempted = await  dbHandler.getAllItems(categoryData[index]['id']);
                  int? currentIndex = (await dbHandler.getRowWithMaxIndForCategory(categoryData[index]['id']))?['ind'] ;
                  if (currentIndex != null) {
                       currentIndex = currentIndex + 1;
                  } else {
                    currentIndex = 0;
                  }
                  Get.to(() => QuizView(category: categoryData[index],currentIndex: currentIndex!));
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: randomColors![index],
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
                          Spacer(),
                          Image.asset("assets/images/exam.png", width: 30,),
                          SizedBox(height: 10,),
                          Text(category['name'], style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.center,),
                          Spacer(),
                          FutureBuilder<double>(
                            future: controller.getPercentage(category['id']),
                            builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return CircularProgressIndicator(); // or any loading widget
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else if (snapshot.data == 0.0) {
                                return Text('');
                              }
                              else {
                                return LinearProgressIndicator(
                                  value: snapshot.data!,
                                  color: Colors.white,
                                backgroundColor: Colors.black26 ,
                                );
                              }
                            },
                          )
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
    ),);
  }

  List<Color> generateRandomColors() {
    return [

      Color(0xFFF44336),
    Color(0xFFE91E63),
    Color(0xFF9C27B0),
    Color(0xFF673AB7),
    Color(0xFF3F51B5),
    Color(0xFF2196F3),
    Color(0xFF03A9F4),
    Color(0xFF00BCD4),
    Color(0xFF009688),
    Color(0xFF4CAF50),
    Color(0xFF8BC34A),
    Color(0xFFCDDC39),
    Color(0xFFFFEB3B),
    Color(0xFFFFC107),
    Color(0xFFFF9800),
    Color(0xFFFF5722),
    Color(0xFF795548),
    Color(0xFF9E9E9E),
    Color(0xFF607D8B),
    Color(0xFF78909C),
    Color(0xFFC62828),
    Color(0xFFAD1457),
    Color(0xFF6A1B9A),
    Color(0xFF4527A0),
    Color(0xFF283593),
    Color(0xFF1565C0),
    Color(0xFF0277BD),
    Color(0xFF00838F),
    Color(0xFF00695C),
    Color(0xFF2E7D32),
    Color(0xFF558B2F),
    Color(0xFF9E9D24),
    Color(0xFFF9A825),
    Color(0xFFF57F17),
    Color(0xFFFF6F00),
    Color(0xFFE65100),
    Color(0xFFBF360C),
    Color(0xFF3E2723),
    Color(0xFF607D8B),
    Color(0xFF90A4AE),
    Color(0xFFD32F2F),
    Color(0xFFC2185B),
    Color(0xFF7B1FA2),
    Color(0xFF512DA8),
    Color(0xFF303F9F),
    Color(0xFF1976D2),
    Color(0xFF0288D1),
    Color(0xFF0097A7),
    Color(0xFF00796B),
    Color(0xFF388E3C),
    Color(0xFF689F38),
    Color(0xFFAFB42B),
    Color(0xFFFBC02D),
    Color(0xFFFFA000),
    Color(0xFFFF6F40),
    Color(0xFFF4511E),
    Color(0xFF8D6E63),
    Color(0xFF757575),
    Color(0xFF546E7A),
    Color(0xFF607D8B),
    Color(0xFFB71C1C),
    Color(0xFF880E4F),
    Color(0xFF4A148C),
    Color(0xFF311B92),
    Color(0xFF1A237E),
    Color(0xFF0D47A1),
    Color(0xFF01579B),
    Color(0xFF006064),
    Color(0xFF004D40),
    Color(0xFF1B5E20),
    Color(0xFF33691E),
    Color(0xFF827717),
    Color(0xFFF57C00),
    Color(0xFFFF6F61),
    Color(0xFFE64A19),
    Color(0xFF5D4037),
    Color(0xFF616161),
    Color(0xFF455A64),
    Color(0xFF546E7A),
    Color(0xFF607D8B),
    Color(0xFF880E4F),
    Color(0xFF4A148C),
    Color(0xFFB71C1C),
    Color(0xFF4A148C),
    Color(0xFF0D47A1),
    Color(0xFF01579B),
    Color(0xFF006064),
    Color(0xFF004D40),
    Color(0xFF1B5E20),
    Color(0xFF33691E),
    Color(0xFF827717),
    Color(0xFFF57C00),
    Color(0xFFFF6F61),
    Color(0xFFE64A19),
    Color(0xFF5D4037),
    Color(0xFF616161),
    Color(0xFF455A64),
    Color(0xFF546E7A),
    Color(0xFF607D8B),
    Color(0xFF9E9E9E)];


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

}
