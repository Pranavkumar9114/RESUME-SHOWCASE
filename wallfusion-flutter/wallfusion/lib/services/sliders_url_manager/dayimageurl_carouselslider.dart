import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class DayImageUrls {
  final String day;
  final List<String> urls;

  DayImageUrls({required this.day, required this.urls});

  factory DayImageUrls.fromJson(Map<String, dynamic> json) {
    return DayImageUrls(
      day: json['day'],
      urls: List<String>.from(json['urls']),
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

Future<DaysData> loadDaysData() async {
  final String response = await rootBundle.loadString('assets/images/days_data_carouselslider.json');
  final data = await json.decode(response);
  return DaysData.fromJson(data);
}
