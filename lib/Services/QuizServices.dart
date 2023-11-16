import '../Application/DataCacheManager.dart';
import '../Application/url.dart';
import '../Models/CategoryModel.dart';
import 'BaseService.dart';

class QuizServices extends BaseService {
  Future<QuizResponseModel?> fetchQuizzes() async {
    try {
      if (DataCacheManager().category != null) {
        return DataCacheManager().category!;
      }
      QuizResponseModel instance = QuizResponseModel(data: []);
      var data = await super.request<QuizResponseModel>(
          endPoint: categoryEndPoint,
          type: RequestType.get,
          instance: instance);

      DataCacheManager().category = data;
      return data;
    } catch (error) {
      print('Error: $error');
      throw Exception('Failed to load data');
    }
  }
}
