import 'package:flutter/material.dart';
import 'package:weatherappv2_proj/model/location_model.dart';
import 'package:weatherappv2_proj/utils/decode.dart';

class CurrentlyTab extends StatelessWidget {
  final LocationModel? location;

  const CurrentlyTab({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 30),
                child: Column(
                  children: [
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
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 30),
                child: Text(
                  '${location?.weather?.temperature.toString()} °C',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 32,
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 30),
                child: Column(
                  children: [
                    Opacity(
                      opacity: 0.7,
                      child: Image.asset(
                        getPngForCode(location?.weather?.weathercode),
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                      ),
                    ),
                    Text(
                      getDescriptionForCode(location?.weather?.weathercode),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.air,
                      size: 24,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 8),
                    Text('${location?.weather?.windspeed} km/h',
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontSize: 18, color: Colors.cyan[900])),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
