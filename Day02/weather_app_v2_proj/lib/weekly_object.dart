class Weekly_Object {
  final List<String> listaTime;
  final List<int> listaWeatherCode;
  final List<double> listaTemperatureMax;
  final List<double> listaTemperatureMin;

  const Weekly_Object(
      {required this.listaTime,
      required this.listaWeatherCode,
      required this.listaTemperatureMax,
      required this.listaTemperatureMin});

  factory Weekly_Object.fromJson(Map<String, dynamic> json) {
    return Weekly_Object(
      listaTime: json['time'].cast<String>(),
      listaWeatherCode: json['weathercode'].cast<int>(),
      listaTemperatureMax: json['temperature_2m_max'].cast<double>(),
      listaTemperatureMin: json['temperature_2m_min'].cast<double>(),
    );
  }
}
