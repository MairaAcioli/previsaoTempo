import 'dart:convert';

List<Model> modelFromJson(String str) => List<Model>.from(json.decode(str).map((x) => Model.fromJson(x)));

String modelToJson(List<Model> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Model {
    final int? id;
    final String name;
    final double latitude;
    final double longitude;
    final String country;
    final String admin1;

    Model({
        required this.id,
        required this.name,
        required this.latitude,
        required this.longitude,
        required this.country,
        required this.admin1,
    });

    factory Model.fromJson(Map<String, dynamic> json) => Model(
        id: json["id"],
        name: json["name"] as String? ?? 'Unknown City',
        latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
        longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
        country: json["country"] as String? ?? 'Unknown',
        admin1: json["admin1"] as String? ?? 'Unknown',
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "latitude": latitude,
        "longitude": longitude,
        "country": country,
        "admin1": admin1,
    };
}
