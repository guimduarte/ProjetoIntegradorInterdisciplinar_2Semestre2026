import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'experience_level.dart';

/// Nível de complexidade de um serviço (ÉPICO 03 - US03.1). Determina
/// automaticamente a taxa de pontos por hora (ÉPICO 05 - US05.1) e o
/// nível de experiência mínimo exigido do operário.
enum ServiceComplexity { facil, medio, dificil, avancado }

extension ServiceComplexityX on ServiceComplexity {
  String get label {
    switch (this) {
      case ServiceComplexity.facil:
        return 'Fácil';
      case ServiceComplexity.medio:
        return 'Médio';
      case ServiceComplexity.dificil:
        return 'Difícil';
      case ServiceComplexity.avancado:
        return 'Avançado';
    }
  }

  /// Pontos concedidos por hora trabalhada (US05.1).
  double get pontosPorHora {
    switch (this) {
      case ServiceComplexity.facil:
        return 2.5;
      case ServiceComplexity.medio:
        return 5.0;
      case ServiceComplexity.dificil:
        return 10.0;
      case ServiceComplexity.avancado:
        return 20.0;
    }
  }

  /// Nível mínimo de experiência exigido para se candidatar (US04.2).
  ExperienceLevel get nivelMinimoExigido {
    switch (this) {
      case ServiceComplexity.facil:
      case ServiceComplexity.medio:
        return ExperienceLevel.iniciante;
      case ServiceComplexity.dificil:
        return ExperienceLevel.intermediario;
      case ServiceComplexity.avancado:
        return ExperienceLevel.avancado;
    }
  }

  Color get color {
    switch (this) {
      case ServiceComplexity.facil:
        return AppColors.verdeSucesso;
      case ServiceComplexity.medio:
        return AppColors.amareloEscuro;
      case ServiceComplexity.dificil:
        return AppColors.vermelhoEscuro;
      case ServiceComplexity.avancado:
        return AppColors.roxoAvancado;
    }
  }

  Color get background {
    switch (this) {
      case ServiceComplexity.facil:
        return AppColors.verdeFundo;
      case ServiceComplexity.medio:
        return AppColors.amareloFundo;
      case ServiceComplexity.dificil:
        return AppColors.vermelhoFundo;
      case ServiceComplexity.avancado:
        return AppColors.roxoFundo;
    }
  }
}

/// Tipo de serviço dentro do escopo solidário (US03.1). Cada opção
/// mapeia automaticamente para um nível de complexidade — a
/// classificação "Avançado" é aplicada quando a instituição sinaliza
/// um serviço 'Difícil' como especialmente extenso/urgente, exigindo
/// operários com 5+ serviços realizados.
enum ServiceScope {
  instalacaoMoveis,
  manutencaoBasica,
  limpeza,
  pintura,
  eletricaBasica,
  eletricaEspecializada,
  carpintaria,
  construcaoCivil,
}

extension ServiceScopeX on ServiceScope {
  String get label {
    switch (this) {
      case ServiceScope.instalacaoMoveis:
        return 'Instalação de móveis/eletros';
      case ServiceScope.manutencaoBasica:
        return 'Manutenção básica';
      case ServiceScope.limpeza:
        return 'Limpeza';
      case ServiceScope.pintura:
        return 'Pintura';
      case ServiceScope.eletricaBasica:
        return 'Elétrica/Encanamento básico';
      case ServiceScope.eletricaEspecializada:
        return 'Elétrica/Encanamento especializado';
      case ServiceScope.carpintaria:
        return 'Carpintaria/Marcenaria';
      case ServiceScope.construcaoCivil:
        return 'Construção civil';
    }
  }

  IconData get icon {
    switch (this) {
      case ServiceScope.instalacaoMoveis:
        return Icons.chair_alt_rounded;
      case ServiceScope.manutencaoBasica:
        return Icons.build_rounded;
      case ServiceScope.limpeza:
        return Icons.cleaning_services_rounded;
      case ServiceScope.pintura:
        return Icons.format_paint_rounded;
      case ServiceScope.eletricaBasica:
        return Icons.bolt_rounded;
      case ServiceScope.eletricaEspecializada:
        return Icons.electrical_services_rounded;
      case ServiceScope.carpintaria:
        return Icons.carpenter_rounded;
      case ServiceScope.construcaoCivil:
        return Icons.construction_rounded;
    }
  }

  /// Classificação automática de complexidade a partir do escopo
  /// (US03.1: "Sistema categoriza automaticamente a complexidade").
  ServiceComplexity get complexidadeBase {
    switch (this) {
      case ServiceScope.instalacaoMoveis:
      case ServiceScope.manutencaoBasica:
        return ServiceComplexity.facil;
      case ServiceScope.limpeza:
      case ServiceScope.pintura:
      case ServiceScope.eletricaBasica:
        return ServiceComplexity.medio;
      case ServiceScope.eletricaEspecializada:
      case ServiceScope.carpintaria:
      case ServiceScope.construcaoCivil:
        return ServiceComplexity.dificil;
    }
  }

  /// Somente escopos 'Difícil' podem ser reclassificados como
  /// 'Avançado' pela instituição no momento da publicação.
  bool get permiteMarcarAvancado => complexidadeBase == ServiceComplexity.dificil;
}

enum ServiceStatus { aberto, aceito, concluido }

extension ServiceStatusX on ServiceStatus {
  String get label {
    switch (this) {
      case ServiceStatus.aberto:
        return 'Aberto';
      case ServiceStatus.aceito:
        return 'Aceito';
      case ServiceStatus.concluido:
        return 'Concluído';
    }
  }

  Color get color {
    switch (this) {
      case ServiceStatus.aberto:
        return AppColors.azulClaro;
      case ServiceStatus.aceito:
        return AppColors.amareloEscuro;
      case ServiceStatus.concluido:
        return AppColors.verdeEscuro;
    }
  }
}

/// Ordem de serviço publicada por uma instituição (ÉPICO 03 - US03.1).
class ServiceOrder {
  final String id;
  final String titulo;
  final String descricao;
  final ServiceScope escopo;
  final bool marcadoComoAvancado;
  final String instituicaoNome;
  final String instituicaoLocalizacao;
  final double distanciaKm;
  final double horasEstimadas;
  final int candidatos;
  ServiceStatus status;
  final double? horasRealizadas;
  final int? pontosGanhos;

  ServiceOrder({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.escopo,
    this.marcadoComoAvancado = false,
    required this.instituicaoNome,
    required this.instituicaoLocalizacao,
    required this.distanciaKm,
    required this.horasEstimadas,
    this.candidatos = 0,
    this.status = ServiceStatus.aberto,
    this.horasRealizadas,
    this.pontosGanhos,
  });

  ServiceComplexity get complexidade {
    if (marcadoComoAvancado && escopo.permiteMarcarAvancado) {
      return ServiceComplexity.avancado;
    }
    return escopo.complexidadeBase;
  }

  /// Se o operário logado no protótipo atende ao raio e ao nível de
  /// experiência mínimo exigido para este serviço.
  bool operarioEstaApto(double raioOperarioKm, int servicosRealizados) {
    final dentroDoRaio = distanciaKm <= raioOperarioKm;
    final nivel = ExperienceLevelX.fromServicosRealizados(servicosRealizados);
    final experienciaOk =
        nivel.minServicosRealizados >= complexidade.nivelMinimoExigido.minServicosRealizados;
    return dentroDoRaio && experienciaOk;
  }
}

/// Lista mock de serviços publicados, usada para popular o feed do
/// operário e o painel da instituição no protótipo.
final List<ServiceOrder> mockServiceOrders = [
  ServiceOrder(
    id: 's1',
    titulo: 'Reparo de infiltração no telhado',
    descricao:
        'A creche possui um vazamento no telhado do refeitório que precisa de reparo urgente antes das chuvas de verão.',
    escopo: ServiceScope.manutencaoBasica,
    instituicaoNome: 'Creche Sementinha do Bem',
    instituicaoLocalizacao: 'São Bernardo do Campo, SP',
    distanciaKm: 2.3,
    horasEstimadas: 4,
    candidatos: 2,
  ),
  ServiceOrder(
    id: 's2',
    titulo: 'Pintura do salão comunitário',
    descricao:
        'Precisamos repintar as paredes internas do salão que recebe cerca de 80 famílias por mês para distribuição de doações.',
    escopo: ServiceScope.pintura,
    instituicaoNome: 'Associação Mãos que Ajudam',
    instituicaoLocalizacao: 'São Bernardo do Campo, SP',
    distanciaKm: 3.1,
    horasEstimadas: 8,
    candidatos: 5,
  ),
  ServiceOrder(
    id: 's3',
    titulo: 'Troca de fiação elétrica exposta',
    descricao:
        'A instalação elétrica do abrigo está com fiação exposta em três salas, representando risco aos acolhidos.',
    escopo: ServiceScope.eletricaEspecializada,
    marcadoComoAvancado: true,
    instituicaoNome: 'Abrigo Novo Amanhecer',
    instituicaoLocalizacao: 'Santo André, SP',
    distanciaKm: 6.8,
    horasEstimadas: 6,
    candidatos: 0,
  ),
  ServiceOrder(
    id: 's4',
    titulo: 'Montagem de estantes na biblioteca comunitária',
    descricao:
        'Recebemos uma doação de estantes de livros desmontadas e precisamos de ajuda para montá-las e fixá-las.',
    escopo: ServiceScope.instalacaoMoveis,
    instituicaoNome: 'Biblioteca Comunitária Ler é Viver',
    instituicaoLocalizacao: 'São Bernardo do Campo, SP',
    distanciaKm: 1.4,
    horasEstimadas: 3,
    candidatos: 3,
  ),
  ServiceOrder(
    id: 's5',
    titulo: 'Construção de rampa de acessibilidade',
    descricao:
        'A entrada principal do centro comunitário não possui rampa de acesso para cadeirantes e idosos.',
    escopo: ServiceScope.construcaoCivil,
    instituicaoNome: 'Centro Comunitário Vida Nova',
    instituicaoLocalizacao: 'Diadema, SP',
    distanciaKm: 9.5,
    horasEstimadas: 16,
    candidatos: 1,
  ),
  ServiceOrder(
    id: 's6',
    titulo: 'Limpeza pós-obra do refeitório',
    descricao:
        'Após uma pequena reforma, o refeitório precisa de limpeza pesada antes da reabertura para as crianças.',
    escopo: ServiceScope.limpeza,
    instituicaoNome: 'Creche Sementinha do Bem',
    instituicaoLocalizacao: 'São Bernardo do Campo, SP',
    distanciaKm: 2.3,
    horasEstimadas: 5,
    candidatos: 4,
  ),
];

/// Serviços já concluídos pelo operário (aba "Meus Serviços" > "Realizados").
final List<ServiceOrder> mockServicosRealizados = [
  ServiceOrder(
    id: 'r1',
    titulo: 'Reparo em vazamento de cozinha',
    descricao: 'Substituição de conexões hidráulicas com vazamento na pia industrial.',
    escopo: ServiceScope.eletricaBasica,
    instituicaoNome: 'Cozinha Solidária Pão Nosso',
    instituicaoLocalizacao: 'São Bernardo do Campo, SP',
    distanciaKm: 1.8,
    horasEstimadas: 3,
    status: ServiceStatus.concluido,
    horasRealizadas: 3.5,
    pontosGanhos: 18,
  ),
  ServiceOrder(
    id: 'r2',
    titulo: 'Reforma de piso da sala de aula',
    descricao: 'Nivelamento e reassentamento de pisos soltos na sala de reforço escolar.',
    escopo: ServiceScope.construcaoCivil,
    instituicaoNome: 'Projeto Educar Mais',
    instituicaoLocalizacao: 'São Bernardo do Campo, SP',
    distanciaKm: 4.2,
    horasEstimadas: 10,
    status: ServiceStatus.concluido,
    horasRealizadas: 9,
    pontosGanhos: 90,
  ),
];

/// Serviço aceito pelo operário e em andamento (aba "Meus Serviços" > "Aceitos").
final List<ServiceOrder> mockServicosAceitos = [
  ServiceOrder(
    id: 'a1',
    titulo: 'Instalação de portas do dormitório',
    descricao: 'Instalação de 4 portas novas doadas para o dormitório do abrigo.',
    escopo: ServiceScope.carpintaria,
    instituicaoNome: 'Abrigo Novo Amanhecer',
    instituicaoLocalizacao: 'Santo André, SP',
    distanciaKm: 6.8,
    horasEstimadas: 5,
    status: ServiceStatus.aceito,
  ),
];
