class DailyWeatherModel {
  List<String>? time;
  List<int>? weatherCode;
  List<double>? temperature2mMax;
  List<double>? temperature2mMin;

  DailyWeatherModel({
    this.time,
    this.weatherCode,
    this.temperature2mMax,
    this.temperature2mMin,
  });

  factory DailyWeatherModel.fromJson(Map<String, dynamic> json) {
    return DailyWeatherModel(
      time: List<String>.from(json['time']),
      weatherCode: List<int>.from(json['weathercode']),
      temperature2mMax: List<double>.from(json['temperature_2m_max'].map((x) => x.toDouble())),
      temperature2mMin: List<double>.from(json['temperature_2m_min'].map((x) => x.toDouble())),
    );
  }
}