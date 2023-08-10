import 'package:weather_app_v2_proj/hourly_object.dart';
import 'package:weather_app_v2_proj/weekly_object.dart';

import 'current_weather_object.dart';

class Forecast_Object {
  final double latitude;
  final double longitude;
  final Current_Weather_Object? current_weather;
  final Hourly_Object? hourly;
  final Weekly_Object? weekly;

  const Forecast_Object(
      {required this.latitude,
      required this.longitude,
      this.current_weather,
      this.hourly,
      this.weekly});

  factory Forecast_Object.fromJson(Map<String, dynamic> json) {
    return Forecast_Object(
      latitude: json['latitude'],
      longitude: json['longitude'],
      current_weather: json['current_weather'] == null
          ? null
          : Current_Weather_Object.fromJson(json['current_weather']),
      hourly: json['hourly'] == null
          ? null
          : Hourly_Object.fromJson(json['hourly']),
      weekly:
          json['daily'] == null ? null : Weekly_Object.fromJson(json['daily']),
    );
  }
}
