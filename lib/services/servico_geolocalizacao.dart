import 'dart:convert';
import 'package:http/http.dart' as http;

class ServicoGeolocalizacao {
  /// Recebe um CEP, busca o endereço via ViaCEP e converte em Lat/Long 
  /// usando o OpenStreetMap (Nominatim), funcionando perfeitamente na Web e Mobile.
  static Future<Map<String, double>?> converterCepParaCoordenadas(String cep) async {
    try {
      // 1. Limpa a string (remove traços ou espaços do formulário)
      final cepLimpo = cep.replaceAll(RegExp(r'[^0-9]'), '');
      if (cepLimpo.length != 8) return null;

      // 2. Busca os dados da rua no ViaCEP
      final viaCepUrl = Uri.parse('https://viacep.com.br/ws/$cepLimpo/json/');
      final response = await http.get(viaCepUrl);
      
      if (response.statusCode == 200) {
        final dadosCep = jsonDecode(response.body);
        
        // Retorna nulo se o ViaCEP não encontrar o CEP
        if (dadosCep.containsKey('erro')) return null;

        // 3. Monta o endereço formatado para busca de coordenadas
        final logradouro = dadosCep['logradouro'] ?? '';
        final localidade = dadosCep['localidade'] ?? '';
        final uf = dadosCep['uf'] ?? '';
        
        final enderecoQuery = Uri.encodeComponent('$logradouro, $localidade, $uf, Brasil');

        // 4. Consulta a API pública de geocodificação (Nominatim) via HTTP
        final geoUrl = Uri.parse('https://nominatim.openstreetmap.org/search?q=$enderecoQuery&format=json&limit=1');
        
        // O Nominatim exige um User-Agent válido nas requisições HTTP
        final geoResponse = await http.get(
          geoUrl,
          headers: {'User-Agent': 'ProjetoInterdisciplinarApp'},
        );

        if (geoResponse.statusCode == 200) {
          final List resultados = jsonDecode(geoResponse.body);
          
          if (resultados.isNotEmpty) {
            final double lat = double.parse(resultados[0]['lat']);
            final double lon = double.parse(resultados[0]['lon']);
            
            return {
              'latitude': lat,
              'longitude': lon,
            };
          }
        }
      }
    } catch (e) {
      print('Erro ao obter coordenadas geográficas: $e');
    }
    
    return null;
  }
}

///Eliminámos a dependência do pacote nativo geocoding que crashava no Chrome. Agora, o próprio Flutter faz uma chamada HTTP leve ao serviço de mapas aberto (OpenStreetMap), recolhe a latitude e a longitude exatas e devolve-as para o cadastro, independentemente de estares a testar no navegador ou num telemóvel!