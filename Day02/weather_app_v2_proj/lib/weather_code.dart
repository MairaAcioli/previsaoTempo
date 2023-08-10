retornaWeatherDescription(int weatherCode) {
    switch (weatherCode) {
      case 0:
        return "Céu limpo";
      case 1:
      case 2:
      case 3:
        return "Nublado";
      case 45:
      case 48:
        return "Nevoeiro";
      case 51:
      case 53:
      case 55:
        return "Garoa";
      case 56:
      case 57:
        return "Garoa congelante";
      case 61:
        return "Chuva leve";
      case 63:
        return "Chuva moderada";
      case 65:
        return "Chuva forte";
      case 66:
      case 67:
        return "Chuva congelante";
      case 71:
      case 73:
      case 75:
      case 77:
      case 85:
      case 86:
        return "Neve";
      case 80:
      case 81:
      case 82:
        return "Pancada de chuva";
      case 95:
      case 96:
      case 99:
        return "Trovoada";
      default:
        return '';
    }
  }


