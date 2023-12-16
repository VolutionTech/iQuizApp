import '../Services/BaseService.dart';

class HistoryModel implements JsonDeserializable<HistoryModel> {
  final List<QuizHistoryModel> histories;

  HistoryModel({required this.histories});

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    print("historyList");

    List<dynamic> historyList = json['histories'];
    List<QuizHistoryModel> histories = historyList
        .map((history) => QuizHistoryModel.fromJson(history))
        .toList();

    return HistoryModel(histories: histories);
  }

  @override
  HistoryModel fromJson(Map<String, dynamic> json) {
    return HistoryModel.fromJson(json);
  }
}

class QuizHistoryModel implements JsonDeserializable<QuizHistoryModel> {
  final String? id;
  final int? correct;
  final int? unanswered;
  final String? quiz;
  final int? total;
  final DateTime? timestamp;

  QuizHistoryModel({
    required this.id,
    required this.correct,
    required this.unanswered,
    required this.quiz,
    required this.total,
    required this.timestamp,
  });

  factory QuizHistoryModel.fromJson(Map<String, dynamic> json) {
    print("QuizHistoryModel: $json");
    return QuizHistoryModel(
      id: json['id'] ?? '',
      correct: json['correct'] ?? 0,
      unanswered: json['unanswered'] ?? 0,
      total: json['total'] ?? 0,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      quiz: json['quiz'] ?? '',
    );
  }

  @override
  QuizHistoryModel fromJson(Map<String, dynamic> json) {
    return QuizHistoryModel.fromJson(json);
  }
}

class SaveHistoryModel extends JsonDeserializable<SaveHistoryModel> {
  final QuizHistoryModel result;
  SaveHistoryModel({required this.result});
  @override
  SaveHistoryModel fromJson(Map<String, dynamic> json) {
    return SaveHistoryModel(
        result: QuizHistoryModel.fromJson(json['result'] ?? {}));
  }
}
