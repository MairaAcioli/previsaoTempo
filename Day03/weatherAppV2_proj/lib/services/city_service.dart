import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weatherappv2_proj/model/location_model.dart';

class CityService {
  static Future<List<LocationModel>> fetchCitySuggestions(String query) async {
    try {
      if (query.length > 2) {
        final response = await http.get(Uri.parse(
            'https://geocoding-api.open-meteo.com/v1/search?name=$query&count=5&language=en&format=json'));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final result = formatResult(data['results'] ?? []);
          if (result.isNotEmpty) {
            List<LocationModel> locationModels = (data['results'] as List)
                .map((locationMap) => LocationModel.fromJson(locationMap))
                .toList();
            return locationModels;
          }
          return [];
        }
        return [];
      }

      return [];
    } catch (e) {
      return [];
    }
  }

  static List<String> formatResult(List<dynamic> result) {
    return result
        .map((item) => "${item["name"]} ${item["admin1"]}, ${item["country"]}")
        .toList();
  }
}
