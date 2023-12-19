import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:imm_quiz_flutter/Application/Constants.dart';
import 'package:imm_quiz_flutter/Application/url.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Application/DataCacheManager.dart';
import '../Application/ErrorDialogs.dart';

enum RequestType { get, post, put, delete }

abstract class JsonDeserializable<T> {
  T fromJson(Map<String, dynamic> json);
}

class BaseService {
  Future<T?> request<T extends JsonDeserializable<T>>({
    required String endPoint,
    required RequestType type,
    T? instance,
    Map<String, dynamic>? body,
    bool isSecure = false,
  }) async {
    print("request: $endPoint");
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      DataCacheManager().headerToken =
          preferences.getString(SharedPrefKeys.KEY_TOKEN) ?? "";
      print("Sending request to $baseURL$endPoint");
      final response = await makeRequest(
          type, baseURL + endPoint, getHeaderForRequest(preferences), body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (instance != null) {
          final Map<String, dynamic> jsonData = json.decode(response.body);
          print("jsonData: $jsonData and instance: $instance");
          var parsedData = instance.fromJson(jsonData);
          print("parsedData: $parsedData");

          return parsedData;
        } else {
          return null;
        }
      } else {
        showErrorDialog("Failed to load data");
      }
    } catch (error) {
      print('Error: $error');
      showErrorDialog("No Internet Connection");
      throw Exception('No Internet Connection');
    }
  }

  Future<http.Response> makeRequest(RequestType type, String url,
      Map<String, String>? header, Map<String, dynamic>? body) {
    String requestBodyJson = "";
    if (body != null) {
      requestBodyJson = jsonEncode(body);
    } else {
      requestBodyJson = "";
    }

    switch (type) {
      case RequestType.get:
        return http.get(Uri.parse(url), headers: header);
      case RequestType.post:
        return http.post(Uri.parse(url),
            headers: header, body: requestBodyJson);
      case RequestType.put:
        return http.put(Uri.parse(url), headers: header, body: requestBodyJson);
      case RequestType.delete:
        return http.delete(Uri.parse(url),
            headers: header, body: requestBodyJson);
    }
  }

  Map<String, String> getHeaderForRequest(SharedPreferences prefs) {
    if (prefs.getBool(SharedPrefKeys.KEY_ISLOGIN) == true) {
      return {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${DataCacheManager().headerToken}',
      };
    }
    return {
      'Content-Type': 'application/json',
    };
  }
}
