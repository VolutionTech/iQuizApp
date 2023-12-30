import '../Services/BaseService.dart';
import 'QuizListModel.dart';

class CategoryListModel implements JsonDeserializable<CategoryListModel> {
  final List<CategoryModel> data;


  CategoryListModel({
    required this.data,

  });

  factory CategoryListModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> dataList = json['data'];
    List<CategoryModel> quizzes =
        dataList.map((item) => CategoryModel.fromJson(item)).toList();

    return CategoryListModel(
      data: quizzes,
    );
  }

  @override
  CategoryListModel fromJson(Map<String, dynamic> json) {
    return CategoryListModel.fromJson(json);
  }
}

class CategoryModel implements JsonDeserializable<CategoryModel> {
  final String id;
  final String name;
  final int count;
  final List<QuizModel>? quizzes;


  CategoryModel({
    required this.id,
    required this.name,
    required this.count,
    this.quizzes,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> dataList = json['quizzes'];
    List<QuizModel> quizzes =
    dataList.map((item) {
      return QuizModel.fromJson(item);
    }).toList();


    return CategoryModel(
      id: json['id'],
      name: json['name'],
      count: json['count'],
      quizzes: quizzes,
    );
  }

  @override
  CategoryModel fromJson(Map<String, dynamic> json) {
    return CategoryModel.fromJson(json);
  }
}