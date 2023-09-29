import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imm_quiz_flutter/DBhandler/DBhandler.dart';

class ResultScreen extends StatelessWidget {
  var dbHandler = DatabaseHandler();
  String category;
  ResultScreen(this.category);
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(),
    body:
    FutureBuilder<Map<String, dynamic>>(
      future: getResult(category),
      builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // or any loading widget
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.data == 0.0) {
          return Text('');
        }
        else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Correct",
                      style: TextStyle(fontSize: 24), // Adjust the font size as needed
                    ),
                    Text(
                      "${snapshot.data?['correct']}",
                      style: TextStyle(fontSize: 24), // Adjust the font size as needed
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Wrong",
                      style: TextStyle(fontSize: 24), // Adjust the font size as needed
                    ),
                    Text(
                      "${snapshot.data?['wrong']}",
                      style: TextStyle(fontSize: 24), // Adjust the font size as needed
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Total",
                      style: TextStyle(fontSize: 24), // Adjust the font size as needed
                    ),
                    Text(
                      "${snapshot.data?['correct'] + snapshot.data?['wrong']}",
                      style: TextStyle(fontSize: 24), // Adjust the font size as needed
                    )
                  ],
                ),
              ],
            ),
          );

        }
      },
    ),

      );

  }

  Future<Map<String, dynamic>> getResult(String category) async {
    List<Map<String, dynamic>> resultList = await dbHandler.getAllItems(category);
    var correct = 0;
    var wrong = 0;

    resultList.forEach((element) {
      if (element['correctOption'] == element['selectedOption']) {
        correct++;
      } else {
        wrong ++;
      }
    });
    return {"correct": correct, "wrong": wrong};
    print(resultList);

  }

}