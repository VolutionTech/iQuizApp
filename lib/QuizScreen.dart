import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:imm_quiz_flutter/DBhandler/DBhandler.dart';
import 'package:imm_quiz_flutter/constants.dart';

import 'ResultScreen/result_screen.dart';


class QuizView extends StatefulWidget {
  dynamic category;
  int currentIndex = 0;
  List<Map<String, dynamic>> attempted = [];
  QuizView({dynamic category, dynamic attempted, required int currentIndex}) {
    this.category = category;
    this.attempted = attempted;
    this.currentIndex = currentIndex;
  }
  @override
  _QuizViewState createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  int _score = 0;
  List<Map<String, dynamic>> _quizData = [];
  bool? isAnswerCorrect;
  int? selectedIndex;
  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _fetchData(); // Fetch data when the widget is first created
  }

  void _fetchData() async {
    try {
      final response = await http.get(Uri.parse(
          'https://quizvolutiontech.000webhostapp.com/${widget.category['id']}.json'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          _quizData = List<Map<String, dynamic>>.from(data);
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print(e);
    }
  }
  void _updateIndexAfterDelay() {
    Future.delayed(Duration(milliseconds: 500), () {
      if ((widget.currentIndex + 1) < _quizData.length) {
        setState(() {
          widget.currentIndex++;
          isAnswerCorrect = null;
          selectedIndex = null;
        });
      } else {
        DatabaseHandler().delete(widget.category['id']);
        Get.to(() => ResultScreen(widget.category['id']));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbarColor,
        title: Text(widget.category['name']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _quizData.isEmpty
            ? Center(child: CircularProgressIndicator())
            :
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("${widget.currentIndex + 1}/${_quizData.length}", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
                          IconButton(
                            icon: Icon(Icons.volume_up),
                            onPressed: () async {
                              await flutterTts.setVolume(100);
                              await flutterTts.setSpeechRate(0.5);
                              await flutterTts.setPitch(0.5);
                              var optionString = _quizData[widget.currentIndex]['options'].toString();
                              var result = await flutterTts.speak(_quizData[widget.currentIndex]['question'] + "Option: "  + optionString);
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white, // Set background color
                        borderRadius: BorderRadius.circular(10.0), // Set border radius
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text("${widget.currentIndex + 1}) " +
                          _quizData[widget.currentIndex]['question'],
                          style:
                              TextStyle(fontSize: 18.0, color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Column(
                      children: List.generate(
                        _quizData[widget.currentIndex]['options'].length,
                        (index) {
                          return InkWell(
                            onTap: () {
                              selectedIndex = index;
                              if (getAnswerNumber(_quizData[widget.currentIndex]['correctAnswer']) == index) {
                                setState(() {
                                  isAnswerCorrect = true;
                                });
                                print("correct");
                              } else {
                                setState(() {
                                  isAnswerCorrect = false;
                                });
                                print("wrong");
                              }
                              _updateIndexAfterDelay();
                              saveInSession(index);
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 8),
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                border: Border.all(color: selectedIndex == index ? getTheRightColor() : Colors.grey),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "${_quizData[widget.currentIndex]['options'][index].toString()}",
                                      maxLines: null,
                                      style: TextStyle(
                                          color:  (selectedIndex == index ? getTheRightColor() : Colors.grey), fontSize: 16),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: (selectedIndex != index)
                                          ? Colors.transparent
                                          : getTheRightColor(),
                                      borderRadius: BorderRadius.circular(50),
                                      border:
                                          Border.all(color: selectedIndex == index ? getTheRightColor() :  Colors.grey),
                                    ),
                                    child: (selectedIndex != index)
                                        ? null
                                        : Icon(getTheRightIcon(), size: 16),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );


  }

  IconData getTheRightIcon() {
    return getTheRightColor() == Colors.red ? Icons.close : Icons.done;
  }

  Color getTheRightColor() {
    if (isAnswerCorrect != null) {
      if (isAnswerCorrect == true) {
        return Colors.green;
      } else if (isAnswerCorrect == false) {
        return Colors.red;
      }
    }
    return Colors.grey;
  }
  int getAnswerNumber(correctAnswer) {
    switch (correctAnswer[0].toLowerCase()) {
      case 'a':
        return 0;
      case 'b':
        return 1;
      case 'c':
        return 2;
      case 'd':
        return 3;
      case 'e':
        return 4;
      case 'f':
        return 5;
      default:
        return 0;
    }
  }

  void saveInSession(index) async {
    var dbHandler = DatabaseHandler();
    dbHandler.insertItem({
      "ind":widget.currentIndex,
      "selectedOption": index,
      "correctOption": getAnswerNumber(_quizData[widget.currentIndex]['correctAnswer']),
      "category": widget.category['id'],
      "total": _quizData.length,

    });

}
}
