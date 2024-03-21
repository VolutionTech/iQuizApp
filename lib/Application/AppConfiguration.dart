import 'package:flutter/material.dart';

class Application {
  // Application Settings
  static const Color appbarColor = Color(0Xffbaad9c);
  static const double passingMarks = 70;

  // Ad Mobs
  static const bool isAdmobEnable = true;
  static const int numberOfQuestionsBetweenInterstitialAds = 4;
  static const String admobAppId = 'ca-app-pub-6213982913612542~3568206730';
  static const String admobBannerId = 'ca-app-pub-6213982913612542/4510625451';
  static const String admobInterstitialId =
      'ca-app-pub-6213982913612542/5187043181';

  // Colors List to show Quizzes and category tiles.
  static List<Gradient> getShadedColorGradientsList() {
    return [
      LinearGradient(
        colors: [
          Color(0xFFF44336),
          Color(0xFFD32F2F), // Darker shade
        ],
      ),
      LinearGradient(
        colors: [
          Color(0xFFE91E63),
          Color(0xFFC2185B), // Darker shade
        ],
      ),
      LinearGradient(
        colors: [
          Color(0xFF9C27B0),
          Color(0xFF7B1FA2), // Darker shade
        ],
      ),
      LinearGradient(
        colors: [
          Color(0xFF8BC34A),
          Color(0xFF689F38), // Darker shade
        ],
      ),
      LinearGradient(
        colors: [
          Color(0xFF3F51B5),
          Color(0xFF303F9F), // Darker shade
        ],
      ),
      LinearGradient(
        colors: [
          Color(0xFFFF9800),
          Color(0xFFE64A19), // Darker shade
        ],
      ),
      LinearGradient(
        colors: [
          Color(0xFFFF5722),
          Color(0xFFBF360C), // Darker shade
        ],
      ),
      LinearGradient(
        colors: [
          Color(0xFF795548),
          Color(0xFF5D4037), // Darker shade
        ],
      ),
      LinearGradient(
        colors: [
          Color(0xFF03A9F4),
          Color(0xFF0288D1), // Darker shade
        ],
      ),
      LinearGradient(
        colors: [
          Color(0xFF9E9E9E),
          Color(0xFF757575), // Darker shade
        ],
      ),
      LinearGradient(
        colors: [
          Color(0xFF673AB7),
          Color(0xFF512DA8), // Darker shade
        ],
      ),
      LinearGradient(
        colors: [
          Color(0xFFFF6F61),
          Color(0xFFFF6F40), // Darker shade
        ],
      ),
      LinearGradient(
        colors: [
          Color(0xFF00BCD4),
          Color(0xFF0097A7), // Darker shade
        ],
      ),
      LinearGradient(
        colors: [
          Color(0xFF607D8B),
          Color(0xFF455A64), // Darker shade
        ],
      ),
      LinearGradient(
        colors: [
          Color(0xFF78909C),
          Color(0xFF546E7A), // Darker shade
        ],
      ),
      LinearGradient(
        colors: [
          Color(0xFFC62828),
          Color(0xFFB71C1C), // Darker shade
        ],
      ),
    ];
  }
}
