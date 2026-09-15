import 'dart:math' as math;

double _grausParaRadianos(double graus) {
  return graus * math.pi / 180;
}

double calcularDistancia(double lat1, double lon1, double lat2, double lon2) {
  const double r = 6371; // Raio volumétrico médio da Terra em quilômetros
  
  final double dLat = _grausParaRadianos(lat2 - lat1);
  final double dLon = _grausParaRadianos(lon2 - lon1);

  final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(_grausParaRadianos(lat1)) *
      math.cos(_grausParaRadianos(lat2)) *
      math.sin(dLon / 2) *
      math.sin(dLon / 2);

  final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  
  return r * c; // Retorna a distância exata em km
}