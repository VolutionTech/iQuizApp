import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Application/DataCacheManager.dart';
import '../Application/url.dart';
import '../Models/QuizHistoryModel.dart';

class HistoryService {
  Future<void> fetchAllHistory() async {
    final apiUrl = baseURL + historyEndPoint;
    try {
      final response = await http.get(Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${DataCacheManager().headerToken}',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body)['histories'];

        setState(() {
          histories =
              jsonData.map((history) => QuizHistoryModel.fromJson(history)).toList();
        });
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }


}