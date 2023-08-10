class Geocoding_Object {
  final double latitude;
  final double longitude;
  final String? pais;
  final String? regiao;
  final String nome;

  const Geocoding_Object(
      {required this.latitude,
      required this.longitude,
      this.pais,
      this.regiao,
      required this.nome});

  factory Geocoding_Object.fromJson(Map<String, dynamic> json) {
    return Geocoding_Object(
        latitude: json['latitude'],
        longitude: json['longitude'],
        pais: json['country'] ?? "",
        regiao: json['admin1'] ?? "",
        nome: json['name']);
  }
}
