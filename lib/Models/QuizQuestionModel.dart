import '../Services/BaseService.dart';

class QuizQuestionModel implements JsonDeserializable<QuizQuestionModel> {
  final List<QuizQuestion> data;

  QuizQuestionModel({
    required this.data,
  });

  factory QuizQuestionModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> dataList = json['data'];
    List<QuizQuestion> quizQuestions =
    dataList.map((item) => QuizQuestion.fromJson(item)).toList();

    return QuizQuestionModel(
      data: quizQuestions,
    );
  }

  @override
  QuizQuestionModel fromJson(Map<String, dynamic> json) {
    return QuizQuestionModel.fromJson(json);
  }
}

class QuizQuestion implements JsonDeserializable<QuizQuestion> {
  final String id;
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String quizId;
  final DateTime createdAt;

  QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.quizId,
    required this.createdAt,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['_id'],
      question: json['question'],
      options: List<String>.from(json['options']),
      correctAnswer: json['correctAnswer'],
      quizId: json['quizId'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  @override
  QuizQuestion fromJson(Map<String, dynamic> json) {
    return QuizQuestion.fromJson(json);
  }
}
