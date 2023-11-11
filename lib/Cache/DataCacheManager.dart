import 'package:imm_quiz_flutter/Category/CategoryModel.dart';

class DataCacheManager {
  static DataCacheManager? _instance;

  DataCacheManager._();

  factory DataCacheManager() {
    _instance ??= DataCacheManager._();
    return _instance!;
  }

  List<Category>? category;
  var headerToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwaG9uZSI6Iis5MjMyNDQ4OTczODQiLCJpYXQiOjE2OTk0MjQ2MDQsImV4cCI6MTcwMjAxNjYwNH0.e5EyMop4dlY8m_p3M4qp7JrklIm6zTIAKw5KPTQI0Wk";

}