String getDescriptionForCode(int? code) {
  switch (code) {
    case 0:
      return 'Clear sky';
    case 1:
      return 'Mainly clear';
    case 2:
      return 'Partly cloudy';
    case 3:
      return 'Overcast';
    case 45:
    case 48:
      return 'Fog and depositing rime fog';
    case 51:
      return 'Drizzle: Light';
    case 53:
      return 'Drizzle: moderate';
    case 55:
      return 'Drizzle: dense intensity';
    case 56:
    case 57:
      return 'Freezing Drizzle: Light and dense intensity';
    case 61:
      return 'Rain: Slight';
    case 63:
      return 'Rain: moderate';
    case 65:
      return 'Rain: heavy intensity';
    case 66:
    case 67:
      return 'Freezing Rain: Light and heavy intensity';
    case 71:
      return 'Snow fall: Slight';
    case 73:
      return 'Snow fall: moderate';
    case 75:
      return 'Snow fall: heavy intensity';
    case 77:
      return 'Snow grains';
    case 80:
      return 'Rain showers: Slight';
    case 81:
      return 'Rain showers: moderate';
    case 82:
      return 'Rain showers:violent';
    case 85:
    case 86:
      return 'Snow showers slight and heavy';
    case 95:
      return 'Thunderstorm: Slight or moderate';
    case 96:
    case 99:
      return 'Thunderstorm with slight and heavy hail';
    default:
      return 'Unknown';
  }
}

String getPngForCode(int? code) {
  switch (code) {
    case 0:
    case 1:
      return 'assets/sun.png';
    case 2:
    case 3:
    case 45:
    case 48:
      return 'assets/cloudy.png';
    case 51:
    case 53:
    case 55:
    case 56:
    case 57:
    case 61:
    case 63:
    case 65:
    case 66:
    case 67:
      return 'assets/rain.png';
    case 71:
    case 73:
    case 75:
    case 77:
      return 'assets/snow.png';
    case 80:
    case 81:
    case 82:
      return 'assets/rain.png';
    case 85:
    case 86:
      return 'assets/snow.png';
    case 95:
    case 96:
    case 99:
      return 'assets/thunder.png';
    default:
      return 'assets/sun.png';
  }
}
