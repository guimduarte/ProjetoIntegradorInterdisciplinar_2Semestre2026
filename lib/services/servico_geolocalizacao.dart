import 'dart:convert';
import 'package:http/http.dart' as http;

// Cria um tipo personalizado para evitar conflitos de leitura no chat
typedef CoordenadaMap = Map<String, double>;

class ServicoGeolocalizacao {
  /// Recebe um CEP, busca o endereço via ViaCEP e converte em Lat/Long 
  /// usando o OpenStreetMap (Nominatim), com fallback para Cidade/Estado.
  static Future<CoordenadaMap?> converterCepParaCoordenadas(String cep) async {
    try {
      final cepLimpo = cep.replaceAll(RegExp(r'[^0-9]'), '');
      if (cepLimpo.length != 8) return null;

      final viaCepUrl = Uri.parse('https://viacep.com.br/ws/$cepLimpo/json/');
      final response = await http.get(viaCepUrl);
      
      if (response.statusCode == 200) {
        final dadosCep = jsonDecode(response.body);
        if (dadosCep.containsKey('erro')) return null;

        final logradouro = dadosCep['logradouro'] ?? '';
        final localidade = dadosCep['localidade'] ?? '';
        final uf = dadosCep['uf'] ?? '';
        
        final enderecoQuery = Uri.encodeComponent('$logradouro, $localidade, $uf, Brasil');
        final geoUrl = Uri.parse('https://nominatim.openstreetmap.org/search?q=$enderecoQuery&format=json&limit=1');
        
        final geoResponse = await http.get(
          geoUrl,
          headers: {'User-Agent': 'ProjetoInterdisciplinarApp'},
        );

        if (geoResponse.statusCode == 200) {
          final List resultados = jsonDecode(geoResponse.body);
          
          if (resultados.isNotEmpty) {
            return {
              'latitude': double.parse(resultados[0]['lat']),
              'longitude': double.parse(resultados[0]['lon']),
            };
          } else {
            // PLANO B: Tentar apenas com Cidade e Estado
            final fallbackQuery = Uri.encodeComponent('$localidade, $uf, Brasil');
            final fallbackUrl = Uri.parse('https://nominatim.openstreetmap.org/search?q=$fallbackQuery&format=json&limit=1');
            
            final fallbackResponse = await http.get(
              fallbackUrl,
              headers: {'User-Agent': 'ProjetoInterdisciplinarApp'},
            );

            if (fallbackResponse.statusCode == 200) {
              final List fallbackResultados = jsonDecode(fallbackResponse.body);
              if (fallbackResultados.isNotEmpty) {
                return {
                  'latitude': double.parse(fallbackResultados[0]['lat']),
                  'longitude': double.parse(fallbackResultados[0]['lon']),
                };
              }
            }
          }
        }
      }
    } catch (e) {
      print('Erro ao obter coordenadas geográficas: $e');
    }
    
    return null;
  }
}