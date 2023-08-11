import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weatherappv2_proj/model/daily_weather_model.dart';
import 'package:weatherappv2_proj/model/hourly_weather_model.dart';
import 'package:weatherappv2_proj/model/location_model.dart';
import 'package:weatherappv2_proj/model/weather_model.dart';
import 'dart:async';

import 'package:weatherappv2_proj/services/city_service.dart';

class LocationService {
  Future<Position> getCurrentLocation() async {
    try {
      bool permissionGranted = await _requestLocationPermission();
      if (!permissionGranted) {
        throw "Location permission not granted.";
      }

      return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      throw "Error getting location: $e";
    }
  }

  Future<bool> requestPermission() async {
    return await _requestLocationPermission();
  }

  Future<bool> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  Future<String> getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      return "${placemarks.first.subThoroughfare} "
          "${placemarks.first.thoroughfare}, "
          "${placemarks.first.locality}, "
          "${placemarks.first.administrativeArea}, "
          "${placemarks.first.country}";
    } catch (e) {
      throw "Error getting address: $e";
    }
  }

  Future<LocationModel?> getLocationInfo(LocationModel location) async {
    final response = await http.get(Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=${location.latitude}&longitude=${location.longitude}&hourly=temperature_2m&hourly=weathercode&hourly=windspeed_10m&current_weather=true&daily=weathercode,temperature_2m_max,temperature_2m_min&timezone=GMT'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final jsonResultWeather = data['current_weather'];
      final jsonResultHourly = data['hourly'];
      final jsonResultDaily = data['daily'];

      if (jsonResultWeather != null) {
        location.weather = WeatherModel.fromJson(jsonResultWeather);
      }

      if (jsonResultHourly != null) {
        location.hourlyWeatherModel =
            HourlyWeatherModel.fromJson(jsonResultHourly);
      }

      if (jsonResultDaily != null) {
        location.dailyWeatherModel =
            DailyWeatherModel.fromJson(jsonResultDaily);
      }

      return location;
    }
  }

  Future<LocationModel?> getLocationByCity(LocationModel location) async {
    try {
      final response = await http.get(Uri.parse(
          'https://geocoding-api.open-meteo.com/v1/search?name=${location.name}&count=1&language=en&format=json'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final jsonResult = data['results'][0];
        if (jsonResult != null) {
          return LocationModel.fromJson(jsonResult);
        }
      }
    } catch (e) {
      return null;
    }
  }
}
