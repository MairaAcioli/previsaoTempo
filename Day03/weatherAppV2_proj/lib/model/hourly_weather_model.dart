class HourlyWeatherModel {
  List<String> time;
  List<double> temperature2m;
  List<int> weatherCode;
  List<double> windspeed10m;

  HourlyWeatherModel({
    required this.time,
    required this.temperature2m,
    required this.weatherCode,
    required this.windspeed10m,
  });

  factory HourlyWeatherModel.fromJson(Map<String, dynamic> json) {
    return HourlyWeatherModel(
      time: List<String>.from(json['time']),
      temperature2m: List<double>.from(
          json['temperature_2m'].map((value) => value.toDouble())),
      weatherCode:
          List<int>.from(json['weathercode'].map((value) => value.toInt())),
      windspeed10m: List<double>.from(
          json['windspeed_10m'].map((value) => value.toDouble())),
    );
  }
}
