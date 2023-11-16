import '../Application/url.dart';
import '../Models/QuizQuestionModel.dart';
import 'BaseService.dart';

class QuestionService extends BaseService {
  Future<QuizQuestionModel?> fetchQuestions(String quizId) async {
    try {
      QuizQuestionModel instance = QuizQuestionModel(data: []);
      var data = await super.request<QuizQuestionModel>(
          endPoint: questionsEndPoint + quizId,
          type: RequestType.get,
          instance: instance);

      return data;
    } catch (error) {
      print('Error: $error');
      throw Exception('Failed to load data');
    }
  }
}
