import 'dart:math';

/// Serviço responsável por calcular a distância geográfica real entre dois pontos utilizando a fórmula de Haversine.

class ServicoHaversine {
  /// Calcula a distância em quilómetros entre duas coordenadas (latitude e longitude)
  static double calcularDistanciaKm(
    double lat1, double lon1, double lat2, double lon2) {
    const double raioTerraKm = 6371.0;

    double dLat = _grausParaRadianos(lat2 - lat1);
    double dLon = _grausParaRadianos(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_grausParaRadianos(lat1)) *
            cos(_grausParaRadianos(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return raioTerraKm * c;
  }

  static double _grausParaRadianos(double graus) {
    return graus * pi / 180.0;
  }
}