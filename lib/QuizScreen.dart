import 'package:flutter/material.dart';
import 'dart:convert';

class QuizView extends StatefulWidget {
  @override
  _QuizViewState createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  int _currentIndex = 0;
  int _score = 0;

  List<Map<String, dynamic>> _quizData = [
    {
      "question": "A 44 year old diabetic patient presented to surgical emergency with complaint of ulcer on Antom of foot. On examination, there is a small ulcer on plantar aspect of left foot. There is also absence of dorsalis pedis and posterior tibial pulses. Doppler signals are barely palpable. What should be the management plan in this patient?",
      "options": [
        "Debridement of ulcer with wet-to-dry dressing",
        "Debridement of ulcer with wet-to-dry dressing followed by arterial bypass procedure",
        "Disarticulation at ankle joint",
        "Below knee amputation",
        "Above knee amputation"
      ],
      "correctAnswer": "B",
      "explanation": "Debridement of ulcer with wet-to-dry dressing followed by arterial bypass procedure"
    },
    {
      "question": "Which of the following is a disadvantage of split thickness skin graft?",
      "options": [
        "Limited availability of high quality donor skin",
        "Limited vascularity at the donor site",
        "Contraction of graft",
        "Limited ability to harvest at donor site",
        "Increased metabolic demands of graft"
      ],
      "correctAnswer": "C",
      "explanation": "Contraction of graft"
    },
    {
      "question": "Which of the following is a major disadvantage of split thickness skin graft?",
      "options": [
        "Limited availability of high quality donor",
        "Limited vascularity at the donor site",
        "Primary contraction of graft",
        "Limited ability to harvest at donor site",
        "Secondary contraction of graft"
      ],
      "correctAnswer": "E",
      "explanation": "Secondary contraction of graft"
    },
    {
      "question": "A patient develops hypotension following spinal anesthesia. There is no evidence of ongoing fluid/blood loss. Which of the following is the best initial step for management of hypotension induced after spinal anesthesia?",
      "options": [
        "Intravenous dopamine",
        "Intravenous dobutamine",
        "Intravenous fluid bolus",
        "Sympathomimetic (phenylephrine and ephedrine)",
        "None of the above"
      ],
      "correctAnswer": "D",
      "explanation": "Sympathomimetic (phenylephrine and ephedrine)"
    },
    {
      "question": "A pedestrian is hit by a speeding car. Radiologic studies obtained in the emergency room, including a retrograde urethrogram (RUG), are consistent with a pelvic fracture with a rupture of the urethra superior to the urogenital diaphragm. Which of the following is the most appropriate next step in this patient's management?",
      "options": [
        "Immediate percutaneous nephrostomy",
        "Immediate placement of a Foley catheter through the urethra into the bladder to align and stent the injured portions",
        "Immediate reconstruction of the ruptured urethra after initial stabilization of the patient",
        "Immediate exploration of the pelvis for control of hemorrhage from pelvic fracture and drainage of pelvic hematoma",
        "Immediate placement of a suprapubic cystostomy tube"
      ],
      "correctAnswer": "E",
      "explanation": "Immediate placement of a suprapubic cystostomy tube"
    }
  ];


  void _checkAnswer(String selectedOption) {
    if (selectedOption == _quizData[_currentIndex]['correctAnswer']) {
      setState(() {
        _score++;
      });
    }

    if (_currentIndex < _quizData.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      // End of quiz, display score or navigate to result screen
      // You can implement this part based on your app's flow
      print('Quiz Completed! Score: $_score');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz View'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              _quizData[_currentIndex]['question'],
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Column(
              children: List.generate(
                _quizData[_currentIndex]['options'].length,
                    (index) => ElevatedButton(
                  onPressed: () {
                    _checkAnswer(_quizData[_currentIndex]['options'][index]);
                  },
                  child: Text(_quizData[_currentIndex]['options'][index]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
