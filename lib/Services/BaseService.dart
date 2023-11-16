import 'dart:convert';

import 'package:get/get_connect/http/src/response/response.dart';
import 'package:http/http.dart' as http;
import 'package:imm_quiz_flutter/Application/url.dart';
import '../Application/DataCacheManager.dart';

enum RequestType {get, post, put, delete}
abstract class JsonDeserializable<T> {
  factory JsonDeserializable.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError('fromJson method must be implemented');
  }

}
class BaseService {
  Future<T?> request<T extends JsonDeserializable<T>>({
    required String endPoint,
    required RequestType type,
    Map<String, dynamic>? body,
    bool isSecure = false,
  }) async {
    try {
      final response = await makeRequest(type, baseURL + endPoint, getHeaderForRequest());
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData != null ? T.fromJson(jsonData) : null; // Call fromJson method directly
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }


  Future<http.Response> makeRequest(RequestType type, String url, Map<String, String>? header) {
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

  getHeaderForRequest() {
    return  {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${DataCacheManager().headerToken}',
    };
  }

}