import '../Services/BaseService.dart';

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
  final DateTime timestamp;

  CategoryModel({
    required this.id,
    required this.name,
    required this.timestamp,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id'],
      name: json['name'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  @override
  CategoryModel fromJson(Map<String, dynamic> json) {
    return CategoryModel.fromJson(json);
  }
}
