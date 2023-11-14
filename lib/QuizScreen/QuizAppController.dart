import 'dart:convert';

import 'package:get/get.dart';
import 'package:imm_quiz_flutter/DBhandler/DBhandler.dart';

import '../QuestionScreen/QuizQuestionModel.dart';
import '../url.dart';
import 'package:http/http.dart' as http;

class QuizAppController extends GetxController {
  var quizData = [QuizQuestion].obs;

  Future<List<QuizQuestion>> fetchQuestions(String quizId) async {
    print(baseURL+questionsEndPoint+quizId);
    final response = await http.get(Uri.parse(baseURL+questionsEndPoint+quizId));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body)['data'];
      return jsonData.map((question) => QuizQuestion.fromJson(question)).toList();
    } else {
      throw Exception('Failed to load questions ' + response.body.toString());
    }
  }


}

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:imm_quiz_flutter/DBhandler/DBhandler.dart';
import 'package:imm_quiz_flutter/constants.dart';
import 'package:imm_quiz_flutter/submitQuiz.dart';
import 'package:imm_quiz_flutter/url.dart';

import 'QuestionScreen/QuizQuestionModel.dart';
import 'QuizAppController.dart';
import 'ResultScreen/result_screen.dart';
import 'Shimmer/QuizPlaceholder.dart';

class QuizView extends StatefulWidget {
  String quizId = "";
  String quizName = "";
  int currentIndex = 0;
  bool reviewMode = false;

  QuizView({required String quizId, required String quizName, required int currentIndex, required bool reviewMode}) {
    this.quizId = quizId;
    this.currentIndex = currentIndex;
    this.reviewMode = reviewMode;
  }
  @override
  _QuizViewState createState() => _QuizViewState();
}

// class _QuizViewState extends State<QuizView> {
//   bool? isAnswerCorrect;
//   int? selectedIndex;
//   FlutterTts flutterTts = FlutterTts();
//   var isSpeaking = false;
//   QuizAppController controller = Get.find();
//
//   @override
//   void dispose() {
//     super.dispose();
//     flutterTts.stop();
//   }
//
//   @override
//   void initState()  {
//     super.initState();
//     loadQuestions();
//   }
//
//   loadQuestions() async {
//     var questions = await fetchQuestions(widget.quizId);
//     setState(() {
//       _quizData = questions;
//     });
//   }
//
//
//
//   void goBack() {
//     setState(() {
//       widget.currentIndex--;
//       isAnswerCorrect = null;
//       selectedIndex = null;
//     });
//   }
//
//   void goNext() {
//     setState(() {
//       widget.currentIndex++;
//       isAnswerCorrect = null;
//       selectedIndex = null;
//     });
//   }
//
//   void _updateIndexAfterDelay() async {
//     flutterTts.stop();
//
//     setState(() {
//       isSpeaking = false;
//     });
//     Future.delayed(Duration(milliseconds: 500), () async {
//       if ((widget.currentIndex + 1) < _quizData.length) {
//         setState(() {
//           goNext();
//         });
//       } else {
//
//         Get.to(() => SubmitQuiz(widget.quizId));
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: appbarColor,
//         title: Text(widget.quizName),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: _quizData.isEmpty
//             ? QuizPlaceholder()
//             : SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: <Widget>[
//               Center(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     IconButton(
//                         onPressed: goBack, icon: Icon(Icons.arrow_back)),
//                     Spacer(),
//                     Text("${widget.currentIndex + 1}/${_quizData.length}",
//                         style: TextStyle(
//                             fontWeight: FontWeight.w500, fontSize: 18)),
//                     IconButton(
//                       icon:
//                       Icon(isSpeaking ? Icons.stop : Icons.volume_up),
//                       onPressed: () async {
//                         if (isSpeaking) {
//                           await flutterTts.stop();
//
//                           setState(() {
//                             isSpeaking = false;
//                           });
//                         } else {
//                           await flutterTts.setVolume(100);
//                           await flutterTts.setSpeechRate(0.5);
//                           await flutterTts.setPitch(0.5);
//                           var optionString =
//                           _quizData[widget.currentIndex].options
//                               .toString();
//                           var result = await flutterTts.speak(
//                               _quizData[widget.currentIndex].question +
//                                   "Option: " +
//                                   optionString);
//                           setState(() {
//                             isSpeaking = true;
//                           });
//                         }
//                       },
//                     ),
//                     Spacer(),
//                     Visibility(
//                         visible: true,
//                         child: IconButton(
//                             onPressed: goNext,
//                             icon: Icon(Icons.arrow_forward))),
//                   ],
//                 ),
//               ),
//               Container(
//                 child: Padding(
//                   padding: const EdgeInsets.all(0.0),
//                   child: Text(
//                     "${widget.currentIndex + 1}) " +
//                         _quizData[widget.currentIndex].question,
//                     style: TextStyle(fontSize: 18.0, color: Colors.black),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 10.0),
//               Column(
//                 children: List.generate(
//                   _quizData[widget.currentIndex].options.length,
//                       (index) {
//                     return InkWell(
//                       onTap: () async {
//                         selectedIndex = index;
//                         if (getAnswerNumber(_quizData[widget.currentIndex].correctAnswer) ==
//                             index) {
//                           setState(() {
//                             isAnswerCorrect = true;
//                           });
//                         } else {
//                           setState(() {
//                             isAnswerCorrect = false;
//                           });
//                         }
//                         await saveInSession(_quizData[widget.currentIndex].id, index);
//                         _updateIndexAfterDelay();
//
//                       },
//                       child: Container(
//                         margin: EdgeInsets.only(top: 8),
//                         padding: EdgeInsets.all(15),
//                         decoration: BoxDecoration(
//                           border:
//                           Border.all(color: getColorforIndex(index)),
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         child: Row(
//                           mainAxisAlignment:
//                           MainAxisAlignment.spaceBetween,
//                           children: [
//                             Expanded(
//                               child: Text(
//                                 "${_quizData[widget.currentIndex].options[index].toString()}",
//                                 maxLines: null,
//                                 style: TextStyle(
//                                     color: getColorforIndex(index),
//                                     fontSize: 16),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   int getAnswerNumber(correctAnswer) {
//     switch (correctAnswer[0].toLowerCase()) {
//       case 'a':
//         return 0;
//       case 'b':
//         return 1;
//       case 'c':
//         return 2;
//       case 'd':
//         return 3;
//       case 'e':
//         return 4;
//       case 'f':
//         return 5;
//       default:
//         return 0;
//     }
//   }
//
//   String getLetterAtIndex(int index) {
//     if (index >= 0) {
//       // Assuming you want A, B, C, D, E...
//       return String.fromCharCode('A'.codeUnitAt(0) + (index % 26));
//     } else {
//       throw ArgumentError('Index must be a non-negative integer.');
//     }
//   }
//   saveInSession(String questionId, index) async {
//     var dbHandler = DatabaseHandler();
//     var existingItem =
//     await dbHandler.getItem(questionId, widget.quizId);
//
//     if (existingItem.isNotEmpty) {
//       await dbHandler.updateItem({
//         "selected_option": getLetterAtIndex(index),
//       }, questionId, widget.quizId);
//     } else {
//       await dbHandler.insertItem({
//         "question_id": _quizData[widget.currentIndex].id,
//         "selected_option": getLetterAtIndex(index),
//         "quiz_id": widget.quizId
//       });
//     }
//
//     controller.updateData(widget.quizId);
//   }
//
//   getColorforIndex(int index) {
//     return Colors.grey;
//   }
// }
