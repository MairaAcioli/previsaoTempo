import 'package:flutter/material.dart';
import 'package:weatherappv2_proj/model/location_model.dart';
import 'package:weatherappv2_proj/utils/decode.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TodayTab extends StatelessWidget {
  final LocationModel? location;

  const TodayTab({super.key, required this.location});

  String getHours(String? gmt) {
    return gmt?.split('T')[1] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Text(
                location?.name ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, color: Colors.blue),
              ),
              Text(
                '${location?.admin1 ?? ''}, ${location?.country ?? ''}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ], // Adjust the value to control the roundness
            ),
            child: SfCartesianChart(
              primaryXAxis: NumericAxis(
                labelFormat: '{value}h', // Custom label format for X-axis
                // Use axisLabelFormatter to format the X-axis labels as "00:00" or "0:00"
                axisLabelFormatter: (AxisLabelRenderDetails details) {
                  final hours = details.value.toInt();
                  final minutes = ((details.value - hours) * 60).toInt();
                  final formattedLabel = hours < 10
                      ? '0$hours:${minutes.toString().padLeft(2, '0')}'
                      : '$hours:${minutes.toString().padLeft(2, '0')}';
                  return ChartAxisLabel(formattedLabel, null);
                },
              ),
              primaryYAxis: NumericAxis(
                labelFormat: '{value}°C', // Format for Y-axis labels
              ),
              series: [
                LineSeries<ChartData, double>(
                  dataSource: getChartList(location!),
                  xValueMapper: (ChartData item, _) => item.hour,
                  yValueMapper: (ChartData item, _) => item.temperature,
                  markerSettings: const MarkerSettings(isVisible: true),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  24,
                  (index) {
                    return Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ], // Adjust the value to control the roundness
                      ),
                      margin: EdgeInsets.all(5),
                      child: Column(
                        children: [
                          Text(
                            getHours(location?.hourlyWeatherModel?.time[index]),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 18, color: Colors.black),
                          ),
                          Opacity(
                            opacity: 0.7,
                            child: Image.asset(
                              getPngForCode(location?.weather?.weathercode),
                              fit: BoxFit.cover,
                              width: 40,
                              height: 40,
                            ),
                          ),
                          Text(
                            '${location?.hourlyWeatherModel?.temperature2m[index].toString()} °C',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 20, color: Colors.amber),
                          ),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.air,
                                  size: 16,
                                  color: Colors.black,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  '${location?.hourlyWeatherModel?.windspeed10m[index].toString()} km/h',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                              ]),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(this.temperature, this.hour);
  final double temperature;
  final double hour;
}

List<ChartData> getChartList(LocationModel location) {
  return List.generate(24, (index) {
    return ChartData(location.hourlyWeatherModel?.temperature2m[index] ?? 0,
        index.toDouble());
  });
}
