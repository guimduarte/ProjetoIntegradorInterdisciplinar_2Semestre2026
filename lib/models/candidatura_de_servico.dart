import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';

import 'amplify/ModelProvider.dart';
import 'amplify/Application.dart';
import 'amplify/Service.dart';

import 'nivel_experiencia.dart';
import 'ordem_servico.dart';
import '../theme/tema_do_app.dart';

enum StatusCandidatura { pendente, aceita, recusada }

extension StatusCandidaturaX on StatusCandidatura {
  String get texto {
    switch (this) {
      case StatusCandidatura.pendente:
        return 'Pendente';
      case StatusCandidatura.aceita:
        return 'Aceita';
      case StatusCandidatura.recusada:
        return 'Recusada';
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
    }
  }
}

class CandidaturaDeServico {
  final String id;
  final String servicoId;
  final String servicoTitulo;
  final String operarioId;
  final String operarioNome;
  final String escopoPrincipal;
  final String operarioEmail;
  final String operarioTelefone;
  final NivelExperiencia nivelExperiencia;
  StatusCandidatura status;
  final DateTime dataCriacao;

  final Application? awsApplication;

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
  });

  factory CandidaturaDeServico.fromAWS(Application aws) {
    final statusConvertido = StatusCandidatura.values.firstWhere(
      (s) => s.texto == aws.status_candidatura,
      orElse: () => StatusCandidatura.pendente,
    );

    final nivelConvertido = NivelExperiencia.values.firstWhere(
      (n) => n.texto == aws.resumo_operario_nivel,
      orElse: () => NivelExperiencia.iniciante,
    );

    final escopoTexto = (aws.resumo_operario_escopo != null && aws.resumo_operario_escopo!.isNotEmpty)
        ? aws.resumo_operario_escopo!.join(', ')
        : 'Geral';

    return CandidaturaDeServico(
      id: aws.id,
      servicoId: aws.service_id,
      servicoTitulo: 'Serviço Solidário',
      operarioId: aws.operario_id,
      operarioNome: aws.resumo_operario_nome ?? 'Operário Voluntário',
      escopoPrincipal: escopoTexto,
      operarioEmail: 'Contato via plataforma',
      operarioTelefone: 'Contato via plataforma',
      nivelExperiencia: nivelConvertido,
      status: statusConvertido,
      dataCriacao: aws.data_solicitacao?.getDateTimeInUtc() ??
          aws.createdAt?.getDateTimeInUtc() ??
          DateTime.now(),
      awsApplication: aws,
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

  // --- READ: Busca candidaturas e remove as de serviços já concluídos ---
  static Future<List<CandidaturaDeServico>> buscarCandidaturasAWS({
    String? instituicaoId,
    String? operarioId,
  }) async {
    try {
      // 1. Busca todas as candidaturas
      final requestApp = ModelQueries.list(Application.classType);
      final responseApp = await Amplify.API.query(request: requestApp).response;
      final itensApp = responseApp.data?.items.whereType<Application>().toList() ?? [];

      // 2. Busca a lista de serviços para verificar quais já foram concluídos
      final requestServ = ModelQueries.list(Service.classType);
      final responseServ = await Amplify.API.query(request: requestServ).response;
      final itensServ = responseServ.data?.items.whereType<Service>().toList() ?? [];

      final servicosConcluidosIds = itensServ
          .where((s) => s.status_servico == StatusServico.concluido.texto)
          .map((s) => s.id)
          .toSet();

      // 3. Oculta candidaturas associadas a serviços concluídos
      final candidaturasAtivas = itensApp.where((aws) {
        return !servicosConcluidosIds.contains(aws.service_id);
      }).toList();

      return candidaturasAtivas.map((aws) => CandidaturaDeServico.fromAWS(aws)).toList();
    } on ApiException catch (e) {
      debugPrint('Erro ao buscar candidaturas na AWS: ${e.message}');
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