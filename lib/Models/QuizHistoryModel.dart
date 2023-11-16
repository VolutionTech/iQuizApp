class QuizHistoryModel {
  final String id;
  final String? quiz;
  final int correct;
  final int? unanswered;
  final int total;
  final DateTime timestamp;

  QuizHistoryModel({
    required this.id,
    required this.quiz,
    required this.correct,
    required this.unanswered,
    required this.total,
    required this.timestamp,
  });

  factory QuizHistoryModel.fromJson(Map<String, dynamic> json) {
    return QuizHistoryModel(
      id: json['id'],
      quiz: json['quiz'],
      correct: json['correct'],
      unanswered: json['unanswered'],
      total: json['total'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}