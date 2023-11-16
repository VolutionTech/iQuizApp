import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../Application/DataCacheManager.dart';
import '../../Application/url.dart';
import '../../Models/LoginResponseModel.dart';


class OnboardingController extends GetxController {
  var nameController = TextEditingController().obs;
  var imageName = "1".obs;

  Future<void> getUserData() async {
    final String apiUrl = '$baseURL$userEndPoint' + 'getUser';
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${DataCacheManager().headerToken}',
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print(responseData);
        var responses = UserLoginResponse.fromJson(responseData);
        this.nameController.value.text = responses.user.name;
        this.imageName.value = responses.user.imageName;

      } else {
        throw Exception('Failed to fetch user data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error occurred while fetching user data: $e');
    }
  }

  Future<void> saveProfile() async {
    final String apiUrl = '$baseURL$userEndPoint';
    try {
      Map<String, dynamic> data =  {
          "name": this.nameController.value.text,
          "imageName": imageName.value,
        };
      final response = await http.put(
        Uri.parse(apiUrl),
        body: jsonEncode(data),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${DataCacheManager().headerToken}',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        var responses = UserLoginResponse.fromJson(responseData);
        this.nameController.value.text = responses.user.name;
        this.imageName.value = responses.user.imageName;
      } else {
        throw Exception('Failed to save profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error occurred while saving profile: $e');
    }
  }
}