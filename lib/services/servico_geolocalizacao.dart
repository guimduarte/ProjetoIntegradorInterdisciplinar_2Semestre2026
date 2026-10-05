// Este arquivo será o responsável por pegar o CEP, ir na internet (ViaCEP) descobrir a rua, e acionar o GPS para transformar isso em Latitude e Longitude.
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';

class ServicoGeolocalizacao {
  /// Recebe um CEP, busca o endereço via ViaCEP e converte em Lat/Long
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

        // 3. Monta o endereço exato para o motor de busca do GPS nativo
        final enderecoFormatado = '${dadosCep['logradouro']}, ${dadosCep['localidade']}, ${dadosCep['uf']}, Brasil';
        
        // 4. Converte a rua formatada em coordenadas geográficas
        List<Location> locais = await locationFromAddress(enderecoFormatado);
        
        if (locais.isNotEmpty) {
          return {
            'latitude': locais.first.latitude,
            'longitude': locais.first.longitude,
          };
        }
      }
    } catch (e) {
      print('Erro ao obter coordenadas geográficas: $e');
    }
    
    return null;
  }
}