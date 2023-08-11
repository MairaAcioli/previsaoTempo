import 'package:flutter/material.dart';
import 'package:weatherappv2_proj/model/location_model.dart';
import 'package:weatherappv2_proj/navbar/tabs/today_tab.dart';
import 'package:weatherappv2_proj/utils/decode.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class WeeklyTab extends StatelessWidget {
  final LocationModel? location;

  const WeeklyTab({super.key, required this.location});

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
            padding: const EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
            ),
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
                    return ChartAxisLabel('${details.value.toInt()}/08', null);
                },
              ),
              primaryYAxis: NumericAxis(
                labelFormat: '{value}°C', // Format for Y-axis labels
              ),
              legend: const Legend(
                isVisible: true,
                position: LegendPosition.bottom,
              ),
              series: [
                LineSeries<ChartData, double>(
                  name: 'Min temperature',
                  dataSource: getChartListWeeklyMaxTemp(location!),
                  xValueMapper: (ChartData item, _) => item.hour,
                  yValueMapper: (ChartData item, _) => item.temperature,
                  markerSettings: const MarkerSettings(isVisible: true),
                ),
                LineSeries<ChartData, double>(
                  name: 'Max temperature',
                  dataSource: getChartListWeeklyMinTemp(location!),
                  xValueMapper: (ChartData item, _) => item.hour,
                  yValueMapper: (ChartData item, _) => item.temperature,
                  markerSettings: const MarkerSettings(isVisible: true),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                7,
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
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ], // Adjust the value to control the roundness
                    ),
                    margin: EdgeInsets.all(5),
                    child: Column(
                      children: [
                        Text(
                          location?.dailyWeatherModel?.time?[index] ?? '',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black),
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
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    '${location?.dailyWeatherModel?.temperature2mMax?[index].toString()} °C',
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.red),
                              ),
                              const TextSpan(
                                text: ' max',
                                style:
                                    TextStyle(fontSize: 12, color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    '${location?.dailyWeatherModel?.temperature2mMin?[index].toString()} °C' ??
                                        'N/A',
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.blue),
                              ),
                              const TextSpan(
                                text: ' min',
                                style:
                                    TextStyle(fontSize: 12, color: Colors.blue),
                              ),
                            ],
                          ),
                        ),
                        // Row(
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [
                        //       const Icon(
                        //         Icons.air,
                        //         size: 16,
                        //         color: Colors.black,
                        //       ),
                        //       const SizedBox(width: 3),
                        //       Text(
                        //         '${location?.hourlyWeatherModel?.windspeed10m[index].toString()} km/h',
                        //         textAlign: TextAlign.center,
                        //         style: const TextStyle(
                        //             fontSize: 14, color: Colors.black),
                        //       ),
                        //     ]),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

List<ChartData> getChartListWeeklyMaxTemp(LocationModel location) {
  return List.generate(7, (index) {
    return ChartData(location.dailyWeatherModel?.temperature2mMin?[index] ?? 0,
        dateToDay(location.dailyWeatherModel?.time?[index]));
  });
}

List<ChartData> getChartListWeeklyMinTemp(LocationModel location) {
  return List.generate(7, (index) {
    return ChartData(
      location.dailyWeatherModel?.temperature2mMax?[index] ?? 0,
      dateToDay(location.dailyWeatherModel?.time?[index]),
    );
  });
}

double dateToDay(String? dateString) {
  DateTime date = DateTime.parse(dateString ?? '0000-00-00');
  return date.day.toDouble();
}
