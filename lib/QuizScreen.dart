
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:imm_quiz_flutter/DBhandler/DBhandler.dart';
import 'package:imm_quiz_flutter/constants.dart';

import 'QuizAppController.dart';
import 'ResultScreen/result_screen.dart';

class QuizView extends StatefulWidget {
  dynamic category;
  int currentIndex = 0;


  QuizView({dynamic category, required int currentIndex}) {
    this.category = category;
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
  var isSpeaking = false;
  QuizAppController controller = Get.find();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    flutterTts.stop();
  }

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

  void goBack() {
    setState(() {
      widget.currentIndex--;
      isAnswerCorrect = null;
      selectedIndex = null;
      if (controller.attempted.length > widget.currentIndex) {
        print(controller.attempted[widget.currentIndex]);
        isAnswerCorrect = controller.attempted[widget.currentIndex]['correctOption'] ==
            controller.attempted[widget.currentIndex]['selectedOption'];
        selectedIndex = controller.attempted[widget.currentIndex]['selectedOption'];

      }
    });
  }

  void goNext() {
    setState(() {
      widget.currentIndex++;
      isAnswerCorrect = null;
      selectedIndex = null;
      if (controller.attempted.length > widget.currentIndex) {
        print(controller.attempted[widget.currentIndex]);
      }
    });
  }

  void _updateIndexAfterDelay() {
    flutterTts.stop();

    setState(() {
      isSpeaking = false;
    });
    Future.delayed(Duration(milliseconds: 500), () {
      if ((widget.currentIndex + 1) < _quizData.length) {
        setState(() {
          goNext();
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
                          IconButton(onPressed: goBack, icon: Icon(Icons.arrow_back)),
                          Spacer(),
                          Text("${widget.currentIndex + 1}/${_quizData.length}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 18)),
                          IconButton(
                            icon:
                                Icon(isSpeaking ? Icons.stop : Icons.volume_up),
                            onPressed: () async {
                              if (isSpeaking) {
                                await flutterTts.stop();

                                setState(() {
                                  isSpeaking = false;
                                });
                              } else {
                                await flutterTts.setVolume(100);
                                await flutterTts.setSpeechRate(0.5);
                                await flutterTts.setPitch(0.5);
                                var optionString =
                                    _quizData[widget.currentIndex]['options']
                                        .toString();
                                var result = await flutterTts.speak(
                                    _quizData[widget.currentIndex]['question'] +
                                        "Option: " +
                                        optionString);
                                setState(() {
                                  isSpeaking = true;
                                });
                              }
                            },
                          ),
                          Spacer(),
                          IconButton(onPressed: goNext, icon: Icon(Icons.arrow_forward)),
                        ],
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Text(
                          "${widget.currentIndex + 1}) " +
                              _quizData[widget.currentIndex]['question'],
                          style: TextStyle(fontSize: 18.0, color: Colors.black),
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
                              if (getAnswerNumber(_quizData[widget.currentIndex]
                                      ['correctAnswer']) ==
                                  index) {
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
                                border:
                                    Border.all(color: getColorforIndex(index)),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "${_quizData[widget.currentIndex]['options'][index].toString()}",
                                      maxLines: null,
                                      style: TextStyle(
                                          color: getColorforIndex(index),
                                          fontSize: 16),
                                    ),
                                  ),
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
    var existingItem = await dbHandler.getItem(widget.currentIndex, widget.category['id']);

    if (existingItem != null) {
      // If the item exists, update it
      await dbHandler.updateItem({
        "ind": widget.currentIndex,
        "selectedOption": index,
        "correctOption": getAnswerNumber(_quizData[widget.currentIndex]['correctAnswer']),
        "category": widget.category['id'],
        "total": _quizData.length,
      });
    } else {
      // If the item does not exist, insert a new one
      await dbHandler.insertItem({
        "ind": widget.currentIndex,
        "selectedOption": index,
        "correctOption": getAnswerNumber(_quizData[widget.currentIndex]['correctAnswer']),
        "category": widget.category['id'],
        "total": _quizData.length,
      });
    }

    controller.updateData(widget.category['id']);

  }


  getColorforIndex(int index) {
    print(",,..controller.attempted");
    print(controller.attempted);
    if (index == selectedIndex) {
      return Colors.black;
    } else if ((controller.attempted.length > widget.currentIndex) &&
        controller.attempted[widget.currentIndex]['selectedOption'] == index)  {
      return Colors.black;
    } else {
      return Colors.grey;
    }
  }
}
