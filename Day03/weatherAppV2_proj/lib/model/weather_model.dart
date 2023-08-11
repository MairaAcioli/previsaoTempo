class WeatherModel {
  final double temperature;
  final double windspeed;
  final int winddirection;
  final int weathercode;
  final int isDay;
  final String time;

  WeatherModel({
    required this.temperature,
    required this.windspeed,
    required this.winddirection,
    required this.weathercode,
    required this.isDay,
    required this.time,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      temperature: json['temperature'] as double,
      windspeed: json['windspeed'] as double,
      winddirection: json['winddirection'],
      weathercode: json['weathercode'] as int,
      isDay: json['is_day'] as int,
      time: json['time'] as String,
    );
  }
}
