import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';

import '../theme/tema_do_app.dart';
import '../../models/amplify/ModelProvider.dart';
import '../../models/amplify/Service.dart';
import '../services/servico_haversine.dart';
import 'nivel_experiencia.dart';

/// Nível de complexidade de um serviço (ÉPICO 03 - US03.1). Determina
/// automaticamente a taxa de pontos por hora (ÉPICO 05 - US05.1) e o
/// nível de experiência mínimo exigido do operário.
enum ComplexidadeServico { facil, medio, dificil, avancado }

extension ComplexidadeServicoX on ComplexidadeServico {
  String get texto {
    switch (this) {
      case ComplexidadeServico.facil:
        return 'Fácil';
      case ComplexidadeServico.medio:
        return 'Médio';
      case ComplexidadeServico.dificil:
        return 'Difícil';
      case ComplexidadeServico.avancado:
        return 'Avançado';
    }
  }

  /// Pontos concedidos por hora trabalhada (US05.1).
  double get pontosPorHora {
    switch (this) {
      case ComplexidadeServico.facil:
        return 2.5;
      case ComplexidadeServico.medio:
        return 5.0;
      case ComplexidadeServico.dificil:
        return 10.0;
      case ComplexidadeServico.avancado:
        return 20.0;
    }
  }

  /// Nível mínimo de experiência exigido para se candidatar (US04.2).
  NivelExperiencia get nivelMinimoExigido {
    switch (this) {
      case ComplexidadeServico.facil:
      case ComplexidadeServico.medio:
        return NivelExperiencia.iniciante;
      case ComplexidadeServico.dificil:
        return NivelExperiencia.intermediario;
      case ComplexidadeServico.avancado:
        return NivelExperiencia.avancado;
    }
  }

  Color get cor {
    switch (this) {
      case ComplexidadeServico.facil:
        return CoresApp.verdeSucesso;
      case ComplexidadeServico.medio:
        return CoresApp.amareloEscuro;
      case ComplexidadeServico.dificil:
        return CoresApp.vermelhoEscuro;
      case ComplexidadeServico.avancado:
        return CoresApp.roxoAvancado;
    }
  }

  Color get background {
    switch (this) {
      case ComplexidadeServico.facil:
        return CoresApp.verdeFundo;
      case ComplexidadeServico.medio:
        return CoresApp.amareloFundo;
      case ComplexidadeServico.dificil:
        return CoresApp.vermelhoFundo;
      case ComplexidadeServico.avancado:
        return CoresApp.roxoFundo;
    }
  }
}

/// Tipo de serviço dentro do escopo solidário (US03.1).
enum EscopoServico {
  instalacaoMoveis,
  manutencaoBasica,
  limpeza,
  pintura,
  eletricaBasica,
  eletricaEspecializada,
  carpintaria,
  construcaoCivil,
}

extension EscopoServicoX on EscopoServico {
  String get texto {
    switch (this) {
      case EscopoServico.instalacaoMoveis:
        return 'Instalação de móveis/eletros';
      case EscopoServico.manutencaoBasica:
        return 'Manutenção básica';
      case EscopoServico.limpeza:
        return 'Limpeza';
      case EscopoServico.pintura:
        return 'Pintura';
      case EscopoServico.eletricaBasica:
        return 'Elétrica/Encanamento básico';
      case EscopoServico.eletricaEspecializada:
        return 'Elétrica/Encanamento especializado';
      case EscopoServico.carpintaria:
        return 'Carpintaria/Marcenaria';
      case EscopoServico.construcaoCivil:
        return 'Construção civil';
    }
  }

  IconData get icone {
    switch (this) {
      case EscopoServico.instalacaoMoveis:
        return Icons.chair_alt_rounded;
      case EscopoServico.manutencaoBasica:
        return Icons.build_rounded;
      case EscopoServico.limpeza:
        return Icons.cleaning_services_rounded;
      case EscopoServico.pintura:
        return Icons.format_paint_rounded;
      case EscopoServico.eletricaBasica:
        return Icons.bolt_rounded;
      case EscopoServico.eletricaEspecializada:
        return Icons.electrical_services_rounded;
      case EscopoServico.carpintaria:
        return Icons.carpenter_rounded;
      case EscopoServico.construcaoCivil:
        return Icons.construction_rounded;
    }
  }

  ComplexidadeServico get complexidadeBase {
    switch (this) {
      case EscopoServico.instalacaoMoveis:
      case EscopoServico.manutencaoBasica:
        return ComplexidadeServico.facil;
      case EscopoServico.limpeza:
      case EscopoServico.pintura:
      case EscopoServico.eletricaBasica:
        return ComplexidadeServico.medio;
      case EscopoServico.eletricaEspecializada:
      case EscopoServico.carpintaria:
      case EscopoServico.construcaoCivil:
        return ComplexidadeServico.dificil;
    }
  }

  bool get permiteMarcarAvancado => complexidadeBase == ComplexidadeServico.dificil;
}

enum StatusServico { aberto, aceito, concluido }

extension StatusServicoX on StatusServico {
  String get texto {
    switch (this) {
      case StatusServico.aberto:
        return 'Aberto';
      case StatusServico.aceito:
        return 'Aceito';
      case StatusServico.concluido:
        return 'Concluído';
    }
  }

  Color get cor {
    switch (this) {
      case StatusServico.aberto:
        return CoresApp.azulClaro;
      case StatusServico.aceito:
        return CoresApp.amareloEscuro;
      case StatusServico.concluido:
        return CoresApp.verdeEscuro;
    }
  }
}

/// Ordem de serviço publicada por uma instituição (ÉPICO 03 - US03.1).
class OrdemServico {
  final String id;
  final String titulo;
  final String descricao;
  final EscopoServico escopo;
  final bool marcadoComoAvancado;
  final String instituicaoNome;
  final String instituicaoLocalizacao;
  final double? latitude;
  final double? longitude;
  double distanciaKm;
  final double horasEstimadas;
  final int candidatos;
  StatusServico status;
  final double? horasRealizadas;
  final int? pontosGanhos;

  final Service? awsService;

  OrdemServico({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.escopo,
    this.marcadoComoAvancado = false,
    required this.instituicaoNome,
    required this.instituicaoLocalizacao,
    this.latitude,
    this.longitude,
    this.distanciaKm = 0.0,
    required this.horasEstimadas,
    this.candidatos = 0,
    this.status = StatusServico.aberto,
    this.horasRealizadas,
    this.pontosGanhos,
    this.awsService,
  });

  factory OrdemServico.fromAWS(Service aws) {
    final escopoConvertido = EscopoServico.values.firstWhere(
      (e) => e.texto == aws.escopo_servico,
      orElse: () => EscopoServico.manutencaoBasica,
    );

    final statusConvertido = StatusServico.values.firstWhere(
      (s) => s.texto == aws.status_servico,
      orElse: () => StatusServico.aberto,
    );

    return OrdemServico(
      id: aws.id,
      titulo: aws.titulo ?? 'sem_titulo',
      descricao: aws.descricao ?? 'Sem descrição',
      escopo: escopoConvertido,
      marcadoComoAvancado: aws.complexidade == 'Avançado',
      instituicaoNome: aws.instituicao_nome ?? 'Instituição',
      instituicaoLocalizacao: aws.endereco_texto ?? 'Localização não informada',
      latitude: aws.latitude,
      longitude: aws.longitude,
      distanciaKm: 0.0,
      horasEstimadas: 4.0,
      candidatos: 0,
      status: statusConvertido,
      awsService: aws,
    );
  }

  ComplexidadeServico get complexidade {
    if (marcadoComoAvancado && escopo.permiteMarcarAvancado) {
      return ComplexidadeServico.avancado;
    }
    return escopo.complexidadeBase;
  }

  bool operarioEstaApto(double raioOperarioKm, int servicosRealizados) {
    final dentroDoRaio = distanciaKm <= raioOperarioKm;
    final nivel = NivelExperienciaX.deServicosRealizados(servicosRealizados);
    final experienciaOk =
        nivel.minServicosRealizados >= complexidade.nivelMinimoExigido.minServicosRealizados;
    return dentroDoRaio && experienciaOk;
  }

  // =========================================================================
  // MÉTODO COMPARTIMENTALIZADO: BUSCA NA AWS + CÁLCULO DE DISTÂNCIA HAVERSINE
  // =========================================================================

  /// Consulta todos os serviços no DynamoDB via AWS Amplify e calcula a
  /// distância geográfica exata até o operário logado se as coordenadas existirem.
  static Future<List<OrdemServico>> buscarServicosAWS({
    double? latitudeOperario,
    double? longitudeOperario,
  }) async {
    try {
      final request = ModelQueries.list(Service.classType);
      final response = await Amplify.API.query(request: request).response;
      final itensNuvem = response.data?.items.whereType<Service>().toList() ?? [];

      return itensNuvem.map<OrdemServico>((servicoAWS) {
        final ordem = OrdemServico.fromAWS(servicoAWS);

        // Se houver coordenadas da instituição e do operário, calcula a distância real
        if (servicoAWS.latitude != null &&
            servicoAWS.longitude != null &&
            latitudeOperario != null &&
            longitudeOperario != null) {
          ordem.distanciaKm = ServicoHaversine.calcularDistanciaKm(
            latitudeOperario,
            longitudeOperario,
            servicoAWS.latitude!,
            servicoAWS.longitude!,
          );
        }

        return ordem;
      }).toList();
    } on ApiException catch (e) {
      debugPrint('Erro ao buscar serviços na AWS (OrdemServico.buscarServicosAWS): ${e.message}');
      return [];
    }
  }
}

/// Mocks mantidos para retrocompatibilidade em testes offline
//final List<OrdemServico> mockOrdensServico = [...];
//final List<OrdemServico> mockServicosRealizados = [...];
//final List<OrdemServico> mockServicosAceitos = [...];