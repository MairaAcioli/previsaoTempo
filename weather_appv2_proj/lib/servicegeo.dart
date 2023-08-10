
import 'package:http/http.dart' as http;
import 'model.dart';
import 'dart:async';
import 'dart:convert';


class ServiceGeo {

//final Function(String value) searchCity;
final String searchCity;

  const ServiceGeo({ required this.searchCity,});

Future<Model> fetchModel() async {
  String url = 'https://geocoding-api.open-meteo.com/v1/search?name=$searchCity&count=10&language=en&format=json';
  print(url);
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print(response.body);
    return Model.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load model');
  }
}
}