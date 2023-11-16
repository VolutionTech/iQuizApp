import '../Services/BaseService.dart';

class QuizResponseModel implements JsonDeserializable<QuizResponseModel> {
  final List<QuizModel> data;

  QuizResponseModel({
    required this.data,
  });

  factory QuizResponseModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> dataList = json['data'];
    List<QuizModel> quizzes =
    dataList.map((item) => QuizModel.fromJson(item)).toList();

    return QuizResponseModel(
      data: quizzes,
    );
  }

  @override
  QuizResponseModel fromJson(Map<String, dynamic> json) {
    return QuizResponseModel.fromJson(json);
  }
}

class QuizModel implements JsonDeserializable<QuizModel> {
  final String id;
  final String name;
  final int totalQuestions;
  final DateTime timestamp;

  QuizModel({
    required this.id,
    required this.name,
    required this.totalQuestions,
    required this.timestamp,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json['_id'],
      name: json['name'],
      totalQuestions: json['totalQuestions'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  @override
  QuizModel fromJson(Map<String, dynamic> json) {
    return QuizModel.fromJson(json);
  }
}
