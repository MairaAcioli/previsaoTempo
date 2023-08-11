import 'package:weatherappv2_proj/model/daily_weather_model.dart';
import 'package:weatherappv2_proj/model/hourly_weather_model.dart';
import 'package:weatherappv2_proj/model/weather_model.dart';

class LocationModel {
  final int? id;
  final String? name;
  final double? latitude;
  final double? longitude;
  final double? elevation;
  final String? featureCode;
  final String? countryCode;
  final int? admin1Id;
  final int? admin2Id;
  final String? timezone;
  final int? population;
  final int? countryId;
  final String? country;
  final String? admin1;
  final String? admin2;
  WeatherModel? weather;
  HourlyWeatherModel? hourlyWeatherModel;
  DailyWeatherModel? dailyWeatherModel;

  LocationModel({
    this.id,
    this.name,
    this.latitude,
    this.longitude,
    this.elevation,
    this.featureCode,
    this.countryCode,
    this.admin1Id,
    this.admin2Id,
    this.timezone,
    this.population,
    this.countryId,
    this.country,
    this.admin1,
    this.admin2,
    this.weather,
    this.hourlyWeatherModel,
    this.dailyWeatherModel,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'],
      name: json['name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      elevation: json['elevation'],
      featureCode: json['feature_code'],
      countryCode: json['country_code'],
      admin1Id: json['admin1_id'],
      admin2Id: json['admin2_id'],
      timezone: json['timezone'],
      population: json['population'],
      countryId: json['country_id'],
      country: json['country'],
      admin1: json['admin1'],
      admin2: json['admin2'],
    );
  }

  String toListFormat() =>
      "${name ?? 'N/A'} ${admin1 ?? 'N/A'}, ${country ?? 'N/A'}";
}
