import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:imm_quiz_flutter/Services/BaseService.dart';
import '../Application/DataCacheManager.dart';
import '../Application/url.dart';
import '../Models/HistoryDetails.dart';
import '../Models/QuizHistoryModel.dart';
import '../Screens/history/HistoryDetailScreen.dart';

class HistoryService extends BaseService {
  Future<HistoryModel?> fetchAllHistory() async {
    HistoryModel instance = HistoryModel(histories: []);
    return await super.request<HistoryModel>(endPoint: historyEndPoint,
        type: RequestType.get,
        instance: instance);
  }

  Future<HistoryDetails?> fetchHistoryDetails(historyId) async {
    HistoryDetails instance = HistoryDetails(id: '', details: []);
    return await super.request<HistoryDetails>(endPoint: historyEndPoint + historyId,
        type: RequestType.get,
        instance: instance);

  }


}