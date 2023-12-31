import '../Application/DBhandler.dart';
import '../Application/DataCacheManager.dart';
import '../Application/url.dart';
import '../Models/CategoryModel.dart';
import '../Models/QuizListModel.dart';
import 'BaseService.dart';

class QuizServices extends BaseService {
  Future<QuizResponseModel?> fetchQuizzes(String id,
      {required bool enableCache}) async {
    if (DataCacheManager().category != null && enableCache) {
      return DataCacheManager().category;
    }
    try {
      QuizResponseModel instance = QuizResponseModel(data: []);
      var data = await super.request<QuizResponseModel>(
          endPoint: id.isNotEmpty ? quizEndPoint + "/" + id : quizEndPoint,
          type: RequestType.get,
          instance: instance);

      await setData(data);
      return DataCacheManager().category!;
    } catch (error) {
      print('Error: $error');
      throw Exception('Failed to load data');
    }
  }

  Future<CategoryListModel?> fetchCategory() async {
    if (DataCacheManager().categoryModel != null) {
      return DataCacheManager().categoryModel;
    }

    try {
      CategoryListModel instance = CategoryListModel(data: []);
      var data = await super.request<CategoryListModel>(
          endPoint: categoryEndPoint,
          type: RequestType.get,
          instance: instance);
      DataCacheManager().categoryModel = data;
      return data;
    } catch (error) {
      print('Error: $error');
      throw Exception('Failed to load data');
    }
  }

  setData(QuizResponseModel? data) async {
    List<QuizModel> onGoing =
        (await Future.wait(data?.data.map((element) async {
                  List<Map<String, dynamic>> allAttempted =
                      await DatabaseHandler().getItemAgainstQuizID(element.id);
                  return (!allAttempted.isEmpty) ? element : null;
                }).toList() ??
                []))
            .where((element) => element != null)
            .cast<QuizModel>()
            .toList();

    List<QuizModel> unattempted =
        (await Future.wait(data?.data.map((element) async {
                  List<Map<String, dynamic>> allAttempted =
                      await DatabaseHandler().getItemAgainstQuizID(element.id);
                  return (allAttempted.isEmpty && element.attempted == null)
                      ? element
                      : null;
                }).toList() ??
                []))
            .where((element) => element != null)
            .cast<QuizModel>()
            .toList();

    List<QuizModel> attempted =
        (await Future.wait(data?.data.map((element) async {
                  List<Map<String, dynamic>> allAttempted =
                      await DatabaseHandler().getItemAgainstQuizID(element.id);
                  return (allAttempted.isEmpty && element.attempted != null)
                      ? element
                      : null;
                }).toList() ??
                []))
            .where((element) => element != null)
            .cast<QuizModel>()
            .toList();

    DataCacheManager().category =
        QuizResponseModel(data: onGoing + unattempted + attempted);
  }
}
