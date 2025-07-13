import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class DayImageUrls {
  final String day;
  final List<Map<String, String>> videos;

  DayImageUrls({required this.day, required this.videos});

  factory DayImageUrls.fromJson(Map<String, dynamic> json) {
    return DayImageUrls(
      day: json['day'],
      videos: List<Map<String, String>>.from(json['videos'].map((video) => Map<String, String>.from(video))),
    );
  }
}

class DaysData {
  final List<DayImageUrls> days;

  DaysData({required this.days});

  factory DaysData.fromJson(Map<String, dynamic> json) {
    return DaysData(
      days: (json['days'] as List).map((day) => DayImageUrls.fromJson(day)).toList(),
    );
  }
}

String getCurrentDay() {
  final DateTime now = DateTime.now();
  final List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  return days[now.weekday - 1];
}

Future<DaysData> loadDaysData(String jsonPath) async {
  final String response = await rootBundle.loadString(jsonPath);
  final data = await json.decode(response);
  return DaysData.fromJson(data);
}