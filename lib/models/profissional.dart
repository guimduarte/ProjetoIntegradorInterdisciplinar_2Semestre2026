import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';

/// Representa um profissional autônomo que oferece serviços
/// manuais (pedreiro, carpinteiro, pintor, eletricista etc.)
/// para entidades públicas e ONGs através do aplicativo.
class Profissional {
  final String nome;
  final String especialidade;
  final double avaliacao;
  final double distanciaKm;
  final bool ongEstaVerificada;
  final bool ehServicoVoluntario;
  final String email;
  final String telefone;

  const Profissional({
    required this.nome,
    required this.especialidade,
    required this.avaliacao,
    required this.distanciaKm,
    this.ongEstaVerificada = false,
    this.ehServicoVoluntario = false,
    this.email = '',
    this.telefone = '',
  });

  String get iniciais {
    final nomes = nome.trim().split(RegExp(r'\s+'));

    if (nomes.isEmpty || nomes.first.isEmpty) {
      return 'P';
    }

    if (nomes.length == 1) {
      return nomes.first[0].toUpperCase();
    }

    return '${nomes.first[0]}${nomes.last[0]}'.toUpperCase();
  }

  /// Busca todos os profissionais do tipo 'operario' salvos no DynamoDB na AWS.
  static Future<List<Profissional>> buscarProfissionaisAWS() async {
    try {
      const consultaOperariosGraphQL = '''
        query ListarOperarios(\$filter: ModelUserFilterInput) {
          listUsers(filter: \$filter) {
            items {
              id
              perfil
              email
              nome
              telefone
              escopo_operario
              raio_atendimento_km
            }
          }
        }
      ''';

      final req = GraphQLRequest<String>(
        document: consultaOperariosGraphQL,
        variables: {
          'filter': {
            'perfil': {'eq': 'operario'}
          }
        },
      );

      final resp = await Amplify.API.query(request: req).response;
      if (resp.data != null) {
        final mapaJson = jsonDecode(resp.data!) as Map<String, dynamic>;
        final itens = mapaJson['listUsers']?['items'] as List<dynamic>?;
        if (itens != null) {
          return itens.map((item) {
            final escopos = item['escopo_operario'] as List<dynamic>?;
            final esp = (escopos != null && escopos.isNotEmpty)
                ? escopos.first.toString()
                : 'Manutenção Geral';

            return Profissional(
              nome: item['nome'] as String? ?? 'Profissional Solidário',
              especialidade: esp,
              avaliacao: 5.0,
              distanciaKm:
                  (item['raio_atendimento_km'] as num?)?.toDouble() ?? 5.0,
              ongEstaVerificada: true,
              email: item['email'] as String? ?? '',
              telefone: item['telefone'] as String? ?? '',
            );
          }).toList();
        }
      }
    } catch (e) {
      safePrint('Erro ao buscar profissionais da AWS: $e');
    }
    return [];
  }
}

/// Categoria de serviço manual oferecida na plataforma.
class CategoriaServico {
  final String texto;
  final String caminhoIcone;

  const CategoriaServico({required this.texto, required this.caminhoIcone});
}
