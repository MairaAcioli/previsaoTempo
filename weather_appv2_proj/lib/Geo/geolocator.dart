import 'package:geolocator/geolocator.dart';


class GeolocatorPosition {
  final Function(String currentAddress) onLocationGot;
  final Function() errorLocation;

   GeolocatorPosition({ required this.onLocationGot, required this.errorLocation,
  });

  String currentAddress = "";
  late Position currentPosition;

Future<bool> handleLocationPermission() async {
  //Position position = await Geolocator.getCurrentPosition();
  bool serviceEnabled;
  LocationPermission permission;
  
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return false;
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {  
      return false;
    }
  }
  
  if (permission == LocationPermission.deniedForever) {
    return false;
  }
  return true;
}

Future<void> getCurrentPosition() async {
  final hasPermission = await handleLocationPermission();
  if (!hasPermission) return errorLocation();
  await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high)
      .then((Position position) {
     
      double latitude = position.latitude;
      double longitude = position.longitude;
      currentAddress = ("$latitude $longitude").toString();
      onLocationGot(currentAddress);
  });
}
}
  
  