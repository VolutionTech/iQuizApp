import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:imm_quiz_flutter/constants.dart';

class QuizView extends StatefulWidget {
  dynamic category;
  QuizView({dynamic category}) {
    this.category = category;
  }
  @override
  _QuizViewState createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  int _currentIndex = 0;
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
      setState(() {
       _currentIndex++;
       isAnswerCorrect = null;
       selectedIndex = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                    Center(child: Text("${_currentIndex + 1}/${_quizData.length}", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18))),
                    SizedBox(height: 30),
                    Text("${_currentIndex + 1}) " +
                      _quizData[_currentIndex]['question'],
                      style:
                          TextStyle(fontSize: 18.0),
                    ),
                    SizedBox(height: 10.0),
                    IconButton(
                      icon: Icon(Icons.volume_up),
                      onPressed: () async {
                        await flutterTts.setVolume(100);
                        await flutterTts.setSpeechRate(1);
                        await flutterTts.setPitch(2.0);
                        var result = await flutterTts.speak("Hello World");
                      },
                    ),

                    Column(
                      children: List.generate(
                        _quizData[_currentIndex]['options'].length,
                        (index) {
                          return InkWell(
                            onTap: () {
                              selectedIndex = index;
                              if (getAnswerNumber(_quizData[_currentIndex]['correctAnswer']) == index) {
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
                                      "${_quizData[_currentIndex]['options'][index].toString()}",
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
  try {
    QuerySnapshot documentRef = await FirebaseFirestore.instance.collection(collectionUser)
        .where("phone", isEqualTo: FirebaseAuth.instance.currentUser?.phoneNumber).get();
    CollectionReference fsRef = documentRef.docs.first.reference.collection(collectionSession);
    fsRef.add({
      'questionNo': _currentIndex,
      'selected': index,
      'correct': getAnswerNumber(_quizData[_currentIndex]['correctAnswer']),
      'totalQuestions': _quizData.length,
      'category' : widget.category['id'],
    });
  } catch(e) {
    print(e);
  }
}
}
