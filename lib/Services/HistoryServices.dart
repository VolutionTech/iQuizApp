import 'package:imm_quiz_flutter/Services/BaseService.dart';
import '../Application/DBhandler.dart';
import '../Application/url.dart';
import '../Models/HistoryDetails.dart';
import '../Models/QuizHistoryModel.dart';

class HistoryService extends BaseService {
  Future<HistoryModel?> fetchAllHistory() async {
    try {
      HistoryModel instance = HistoryModel(histories: []);
      var history = await super.request<HistoryModel>(
          endPoint: historyEndPoint, type: RequestType.get, instance: instance);

      return history;
    } catch (error) {
      print('Error: $error');
      throw Exception('Failed to load data');
    }
  }

  Future<HistoryDetails?> fetchHistoryDetails(historyId) async {
    HistoryDetails instance = HistoryDetails(id: '', details: []);
    try {
      return await super.request<HistoryDetails>(
          endPoint: historyEndPoint + historyId,
          type: RequestType.get,
          instance: instance);
    } catch (error) {
      print('Error: $error');
      throw Exception('Failed to load data');
    }
  }

  Future<void> submitHistory(String quizId, List<Map<String, String>> answers,
      void Function(SaveHistoryModel) success) async {
    try {
      final Map<String, dynamic> requestBody = {
        'quiz': quizId,
        'answers': answers,
      };
      SaveHistoryModel instance = SaveHistoryModel(
          result: QuizHistoryModel(
              id: '',
              correct: 0,
              unanswered: 0,
              total: 0,
              timestamp: DateTime.now(), quiz: ''));
      var result = await super.request(
          endPoint: historyEndPoint,
          type: RequestType.post,
          instance: instance,
          body: requestBody);
      if (result != null) {
        success(result);
        DatabaseHandler().delete(quizId);
      }
    } catch (error) {
      print('Error: $error');
      throw Exception('Failed to load data');
    }
  }
}
