import '../Services/BaseService.dart';

class HistoryDetails implements JsonDeserializable<HistoryDetails> {
  final String id;
  final List<HistoryQuestion> details;

  HistoryDetails({
    required this.id,
    required this.details,
  });

  factory HistoryDetails.fromJson(Map<String, dynamic> json) {
    List<dynamic> detailsList = json['details'];
    List<HistoryQuestion> questions =
    detailsList.map((item) => HistoryQuestion.fromJson(item)).toList();

    return HistoryDetails(
      id: json['id'],
      details: questions,
    );
  }

  @override
  HistoryDetails fromJson(Map<String, dynamic> json) {
    return HistoryDetails.fromJson(json);
  }
}

class HistoryQuestion implements JsonDeserializable<HistoryQuestion> {
  final String question;
  final bool isCorrect;
  final String correct;
  final String selected;

  HistoryQuestion({
    required this.question,
    required this.isCorrect,
    required this.correct,
    required this.selected,
  });

  factory HistoryQuestion.fromJson(Map<String, dynamic> json) {
    return HistoryQuestion(
      question: json['question'],
      isCorrect: json['isCorrect'],
      correct: json['correct'],
      selected: json['selected'],
    );
  }

  @override
  HistoryQuestion fromJson(Map<String, dynamic> json) {
    return HistoryQuestion.fromJson(json);
  }
}
