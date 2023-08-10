class Current_Weather_Object {
  final double temperature;
  final double windspeed;
  final int weathercode;

  const Current_Weather_Object({
    required this.temperature,
    required this.windspeed,
    required this.weathercode,
  });

  factory Current_Weather_Object.fromJson(Map<String, dynamic> json) {
    return Current_Weather_Object(
      temperature: json['temperature'],
      windspeed: json['windspeed'],
      weathercode: json['weathercode'],
    );
  }
}
