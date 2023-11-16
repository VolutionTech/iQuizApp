import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:imm_quiz_flutter/Application/Constants.dart';
import 'package:imm_quiz_flutter/Application/url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Application/DataCacheManager.dart';

enum RequestType { get, post, put, delete }

abstract class JsonDeserializable<T> {
  T fromJson(Map<String, dynamic> json);
}

class BaseService {
  Future<T?> request<T extends JsonDeserializable<T>>({
    required String endPoint,
    required RequestType type,
    required T instance,
    Map<String, dynamic>? body,
    bool isSecure = false,
  }) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      DataCacheManager().headerToken = preferences.getString(SharedPrefKeys.KEY_TOKEN) ?? "";
      final response = await makeRequest(
          type, baseURL + endPoint, getHeaderForRequest());
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData != null ? instance.fromJson(jsonData) : null;
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      print('Error: $error');
      return null;
    }
  }

  Future<http.Response> makeRequest(
      RequestType type, String url, Map<String, String>? header) {
    switch (type) {
      case RequestType.get:
        return http.get(Uri.parse(url), headers: header);
      case RequestType.post:
        return http.post(Uri.parse(url), headers: header);
      case RequestType.put:
        return http.put(Uri.parse(url), headers: header);
      case RequestType.delete:
        return http.delete(Uri.parse(url), headers: header);
    }
  }

  Map<String, String> getHeaderForRequest() {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${DataCacheManager().headerToken}',
    };
  }
}
