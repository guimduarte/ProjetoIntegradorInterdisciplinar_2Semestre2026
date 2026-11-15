import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';

import 'amplify/ModelProvider.dart';
import 'amplify/Application.dart';
import 'amplify/Service.dart';

import 'nivel_experiencia.dart';
import 'ordem_servico.dart';
import '../theme/tema_do_app.dart';

enum StatusCandidatura { pendente, aceita, recusada, concluida }

extension StatusCandidaturaX on StatusCandidatura {
  String get texto {
    switch (this) {
      case StatusCandidatura.pendente:
        return 'Pendente';
      case StatusCandidatura.aceita:
        return 'Aceita';
      case StatusCandidatura.recusada:
        return 'Recusada';
      case StatusCandidatura.concluida:
        return 'Concluída';
    }
  }

  Color get cor {
    switch (this) {
      case StatusCandidatura.pendente:
        return CoresApp.amareloEscuro;
      case StatusCandidatura.aceita:
        return CoresApp.verdeEscuro;
      case StatusCandidatura.recusada:
        return CoresApp.vermelhoEscuro;
      case StatusCandidatura.concluida:
        return CoresApp.azulClaro;
    }
  }
}

class CandidaturaDeServico {
  final String id;
  final String servicoId;
  String servicoTitulo;
  final String operarioId;
  final String operarioNome;
  final String escopoPrincipal;
  final String operarioEmail;
  final String operarioTelefone;
  final NivelExperiencia nivelExperiencia;
  StatusCandidatura status;
  final DateTime dataCriacao;

  final Application? awsApplication;
  final Service? awsService;

  CandidaturaDeServico({
    required this.id,
    required this.servicoId,
    required this.servicoTitulo,
    required this.operarioId,
    required this.operarioNome,
    required this.escopoPrincipal,
    required this.operarioEmail,
    required this.operarioTelefone,
    required this.nivelExperiencia,
    this.status = StatusCandidatura.pendente,
    required this.dataCriacao,
    this.awsApplication,
    this.awsService,
  });

  factory CandidaturaDeServico.fromAWS(Application aws,
      {Service? servicoAWS, String? tituloServico}) {
    final statusConvertido = StatusCandidatura.values.firstWhere(
      (s) => s.texto == aws.status_candidatura,
      orElse: () => StatusCandidatura.pendente,
    );

    final nivelConvertido = NivelExperiencia.values.firstWhere(
      (n) => n.texto == aws.resumo_operario_nivel,
      orElse: () => NivelExperiencia.iniciante,
    );

    final escopoTexto = (aws.resumo_operario_escopo != null &&
            aws.resumo_operario_escopo!.isNotEmpty)
        ? aws.resumo_operario_escopo!.join(', ')
        : (servicoAWS?.escopo_servico ?? 'Geral');

    return CandidaturaDeServico(
      id: aws.id,
      servicoId: aws.service_id,
      servicoTitulo: servicoAWS?.titulo ?? tituloServico ?? 'Serviço Solidário',
      operarioId: aws.operario_id,
      operarioNome: aws.resumo_operario_nome ?? 'Operário Voluntário',
      escopoPrincipal: escopoTexto,
      operarioEmail: aws.operario_id.contains('@')
          ? aws.operario_id
          : (aws.resumo_operario_nome ?? 'Operário Voluntário'),
      operarioTelefone: 'Contato via plataforma',
      nivelExperiencia: nivelConvertido,
      status: statusConvertido,
      dataCriacao: aws.data_solicitacao?.getDateTimeInUtc() ??
          aws.createdAt?.getDateTimeInUtc() ??
          DateTime.now(),
      awsApplication: aws,
      awsService: servicoAWS,
    );
  }

  static Future<bool> criarCandidaturaAWS({
    required String servicoId,
    required String servicoTitulo,
    required String operarioId,
    required String operarioNome,
    required String operarioEmail,
    required String operarioTelefone,
    required String escopoPrincipal,
    required NivelExperiencia nivelExperiencia,
  }) async {
    try {
      final novaAplicacao = Application(
        service_id: servicoId,
        operario_id: operarioId,
        status_candidatura: StatusCandidatura.pendente.texto,
        data_solicitacao: TemporalDateTime.now(),
        resumo_operario_nome: operarioNome,
        resumo_operario_escopo: [escopoPrincipal],
        resumo_operario_nivel: nivelExperiencia.texto,
      );

      final request = ModelMutations.create(novaAplicacao);
      final response = await Amplify.API.mutate(request: request).response;

      return response.data != null;
    } on ApiException catch (e) {
      debugPrint('Erro ao criar candidatura na AWS: ${e.message}');
      return false;
    }
  }

  /// Busca candidaturas na AWS filtradas estritamente pela Instituição logada.
  static Future<List<CandidaturaDeServico>> buscarCandidaturasAWS({
    String? instituicaoId,
    String? operarioId,
  }) async {
    try {
      // 1. Busca todas as candidaturas
      final requestApp = ModelQueries.list(Application.classType);
      final responseApp = await Amplify.API.query(request: requestApp).response;
      final itensApp = responseApp.data?.items.whereType<Application>().toList() ?? [];

      // 2. Busca a lista de serviços para filtrar pela instituição e extrair títulos/status
      final requestServ = ModelQueries.list(Service.classType);
      final responseServ = await Amplify.API.query(request: requestServ).response;
      final itensServ = responseServ.data?.items.whereType<Service>().toList() ?? [];

      final Map<String, Service> mapaServicos = {};
      for (final s in itensServ) {
        // Se instituicaoId foi informado, só inclui serviços pertencentes a essa instituição
        if (instituicaoId != null && instituicaoId.isNotEmpty) {
          final nomeServicoInst = (s.instituicao_nome ?? '').trim().toLowerCase();
          final idServicoInst = (s.instituicao_id ?? '').trim().toLowerCase();
          final busca = instituicaoId.trim().toLowerCase();

          if (nomeServicoInst != busca &&
              idServicoInst != busca &&
              !nomeServicoInst.contains(busca)) {
            continue; // Ignora serviços de outras instituições
          }
        }
        mapaServicos[s.id] = s;
      }

      // 3. Filtra apenas candidaturas que pertencem aos serviços da instituição logada (deduplicando IDs)
      final candidaturasFiltradas = <CandidaturaDeServico>[];
      final Set<String> chavesVistas = {};

      for (final aws in itensApp) {
        if (instituicaoId != null && instituicaoId.isNotEmpty) {
          if (!mapaServicos.containsKey(aws.service_id)) {
            continue; // Ignora candidaturas de serviços de outras instituições
          }
        }

        // Evita duplicatas pela chave do ID da candidatura ou do par servico_operario
        final chaveUnica = '${aws.service_id}_${aws.operario_id}';
        if (chavesVistas.contains(chaveUnica) || chavesVistas.contains(aws.id)) {
          continue;
        }
        chavesVistas.add(chaveUnica);
        chavesVistas.add(aws.id);

        final servicoAssociado = mapaServicos[aws.service_id];
        final tituloReal = servicoAssociado?.titulo ?? 'Serviço Solidário';

        final candidatura = CandidaturaDeServico.fromAWS(
          aws,
          tituloServico: tituloReal,
        );

        // Se o serviço foi concluído na AWS, marca a candidatura como concluída
        if (servicoAssociado?.status_servico == StatusServico.concluido.texto) {
          candidatura.status = StatusCandidatura.concluida;
        }

        candidaturasFiltradas.add(candidatura);
      }

      return candidaturasFiltradas;
    } on ApiException catch (e) {
      debugPrint('Erro ao buscar candidaturas na AWS: ${e.message}');
      return [];
    }
  }

  /// Busca todas as candidaturas registradas por um operário específico.
  static Future<List<CandidaturaDeServico>> buscarCandidaturasDoOperarioAWS(
      String identificadorOperario) async {
    try {
      final requestApp = ModelQueries.list(Application.classType);
      final responseApp = await Amplify.API.query(request: requestApp).response;
      final itensApp =
          responseApp.data?.items.whereType<Application>().toList() ?? [];

      final requestServ = ModelQueries.list(Service.classType);
      final responseServ =
          await Amplify.API.query(request: requestServ).response;
      final itensServ =
          responseServ.data?.items.whereType<Service>().toList() ?? [];

      final Map<String, Service> mapaServicos = {
        for (final s in itensServ) s.id: s
      };

      final busca = identificadorOperario.trim().toLowerCase();
      final candidaturasDoOperario = <CandidaturaDeServico>[];

      for (final aws in itensApp) {
        final opId = (aws.operario_id ?? '').trim().toLowerCase();
        final opNome = (aws.resumo_operario_nome ?? '').trim().toLowerCase();

        if (opId != busca && opNome != busca && !opId.contains(busca)) {
          continue; // Ignora candidaturas de outros operários
        }

        final servicoAssociado = mapaServicos[aws.service_id];
        final tituloReal = servicoAssociado?.titulo ?? 'Serviço Solidário';

        final candidatura = CandidaturaDeServico.fromAWS(
          aws,
          servicoAWS: servicoAssociado,
          tituloServico: tituloReal,
        );

        if (servicoAssociado?.status_servico == StatusServico.concluido.texto) {
          candidatura.status = StatusCandidatura.concluida;
        }

        candidaturasDoOperario.add(candidatura);
      }

      return candidaturasDoOperario;
    } catch (e) {
      debugPrint('Erro ao buscar candidaturas do operário: $e');
      return [];
    }
  }

  static Future<bool> atualizarStatusAWS({
    required CandidaturaDeServico candidatura,
    required StatusCandidatura novoStatus,
  }) async {
    if (candidatura.awsApplication == null) return false;

    try {
      final atualizado = candidatura.awsApplication!.copyWith(
        status_candidatura: novoStatus.texto,
      );

      final request = ModelMutations.update(atualizado);
      final response = await Amplify.API.mutate(request: request).response;

      if (response.data != null) {
        if (novoStatus == StatusCandidatura.aceita) {
          await OrdemServico.atualizarStatusServicoAWS(
            servicoId: candidatura.servicoId,
            novoStatus: StatusServico.aceito,
          );
        } else if (novoStatus == StatusCandidatura.concluida) {
          await OrdemServico.atualizarStatusServicoAWS(
            servicoId: candidatura.servicoId,
            novoStatus: StatusServico.concluido,
          );
        }
        return true;
      }
      return false;
    } on ApiException catch (e) {
      debugPrint('Erro ao atualizar status da candidatura na AWS: ${e.message}');
      return false;
    }
  }
}
