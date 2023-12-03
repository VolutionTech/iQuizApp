import 'package:flutter/material.dart';
import 'package:imm_quiz_flutter/Services/HistoryServices.dart';
import 'package:readmore/readmore.dart';

import '../../Application/Constants.dart';
import '../../Models/HistoryDetails.dart';
import '../../Services/ReportServer.dart';

class HistoryDetailScreen extends StatelessWidget {
  final String historyId;

  HistoryDetailScreen({required this.historyId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History Details'),
        backgroundColor: Application.appbarColor,
      ),
      body: FutureBuilder<HistoryDetails?>(
        future: HistoryService().fetchHistoryDetails(historyId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData ||
              snapshot.data?.details.isEmpty != false) {
            return Center(
              child: Text('No details available.'),
            );
          } else {
            List<HistoryQuestion>? reviewDataList = snapshot.data?.details;
            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: ListView(
                children: reviewDataList!.asMap().entries.map((entry) {
                  int index = entry.key;
                  HistoryQuestion reviewData = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ReviewBlock(
                        '${index + 1}) ' + reviewData.question,
                        reviewData.correct,
                        reviewData.isCorrect ? "" : reviewData.selected,
                        context,
                        reviewData),
                  );
                }).toList(),
              ),
            );
          }
        },
      ),
    );
  }
}

Widget ReviewBlock(
    question, ans, wrongAns, context, HistoryQuestion reviewData) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: wrongAns.isEmpty ? Colors.green : Colors.red),
    ),
    child: Stack(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Container(
            decoration: BoxDecoration(
              color: wrongAns.isEmpty ? Colors.green : Colors.red,
              border: Border.all(
                  color: wrongAns.isEmpty ? Colors.green : Colors.red),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                wrongAns.isEmpty ? "Correct" : "Wrong",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 40.0, 15.0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ReadMoreText(
                  question,
                  trimLines: 3,
                  colorClickableText: Colors.pink,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: 'Show more',
                  trimExpandedText: ' less',
                  lessStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                  moreStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              wrongAns.isEmpty
                  ? SizedBox()
                  : RichText(
                      text: TextSpan(children: <TextSpan>[
                        TextSpan(
                          text: "You selected: ",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        TextSpan(
                          text: wrongAns,
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        )
                      ]),
                    ),
              RichText(
                text: TextSpan(children: <TextSpan>[
                  TextSpan(
                    text: wrongAns.isEmpty
                        ? "You selected: "
                        : "Correct Answer: ",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  TextSpan(
                    text: ans,
                    style: TextStyle(color: Colors.green, fontSize: 16),
                  )
                ]),
              ),
              Row(
                children: [
                  Spacer(),
                  TextButton(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ReportDialog(reviewData: reviewData);
                        },
                      );
                    },
                    child: Text(
                      "Report",
                      style: TextStyle(fontSize: 15.0, color: Colors.red),
                    ),
                  ),
                  Spacer(),
                ],
              )
            ],
          ),
        ),
      ],
    ),
  );
}

class ReportDialog extends StatefulWidget {
  HistoryQuestion reviewData;
  ReportDialog({required this.reviewData});
  @override
  _ReportDialogState createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Report'),
      content: TextField(
        controller: _messageController,
        decoration: InputDecoration(
          hintText: 'Enter your message',
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            String message = _messageController.text;
            // Perform API hit using ReportService
            await ReportService()
                .report(message: message + " " + widget.reviewData.question);

            Navigator.of(context).pop(); // Close the dialog after API hit
          },
          child: Text('Done'),
        ),
      ],
    );
  }
}
