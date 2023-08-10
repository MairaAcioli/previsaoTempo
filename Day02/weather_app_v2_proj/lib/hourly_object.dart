class Hourly_Object {
  final List<String> listaTime;
  final List<int> listaWeatherCode;
  final List<double> listaTemperature;
  final List<double> listaWindSpeed;

  const Hourly_Object(
      {required this.listaTime,
      required this.listaWeatherCode,
      required this.listaTemperature,
      required this.listaWindSpeed});

  factory Hourly_Object.fromJson(Map<String, dynamic> json) {
    return Hourly_Object(
      listaTime: json['time'].cast<String>(),
      listaWeatherCode: json['weathercode'].cast<int>(),
      listaTemperature: json['temperature_2m'].cast<double>(),
      listaWindSpeed: json['windspeed_10m'].cast<double>(),
    );
  }
}
