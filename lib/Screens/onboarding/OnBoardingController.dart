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

}