import 'package:flutter/material.dart';
import '../theme/tema_do_app.dart';
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

/// Tipo de serviço dentro do escopo solidário (US03.1). Cada opção
/// mapeia automaticamente para um nível de complexidade — a
/// classificação "Avançado" é aplicada quando a instituição sinaliza
/// um serviço 'Difícil' como especialmente extenso/urgente, exigindo
/// operários com 5+ serviços realizados.
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

  /// Classificação automática de complexidade a partir do escopo
  /// (US03.1: "Sistema categoriza automaticamente a complexidade").
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

  /// Somente escopos 'Difícil' podem ser reclassificados como
  /// 'Avançado' pela instituição no momento da publicação.
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
  final double distanciaKm;
  final double horasEstimadas;
  final int candidatos;
  StatusServico status;
  final double? horasRealizadas;
  final int? pontosGanhos;

  OrdemServico({
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
    this.status = StatusServico.aberto,
    this.horasRealizadas,
    this.pontosGanhos,
  });

  ComplexidadeServico get complexidade {
    if (marcadoComoAvancado && escopo.permiteMarcarAvancado) {
      return ComplexidadeServico.avancado;
    }
    return escopo.complexidadeBase;
  }

  /// Se o operário logado no protótipo atende ao raio e ao nível de
  /// experiência mínimo exigido para este serviço.
  bool operarioEstaApto(double raioOperarioKm, int servicosRealizados) {
    final dentroDoRaio = distanciaKm <= raioOperarioKm;
    final nivel = NivelExperienciaX.deServicosRealizados(servicosRealizados);
    final experienciaOk =
        nivel.minServicosRealizados >= complexidade.nivelMinimoExigido.minServicosRealizados;
    return dentroDoRaio && experienciaOk;
  }
}

/// Lista mock de serviços publicados, usada para popular o feed do
/// operário e o painel da instituição no protótipo.
final List<OrdemServico> mockOrdensServico = [
  OrdemServico(
    id: 's1',
    titulo: 'Reparo de infiltração no telhado',
    descricao:
        'A creche possui um vazamento no telhado do refeitório que precisa de reparo urgente antes das chuvas de verão.',
    escopo: EscopoServico.manutencaoBasica,
    instituicaoNome: 'Creche Sementinha do Bem',
    instituicaoLocalizacao: 'São Bernardo do Campo, SP',
    distanciaKm: 2.3,
    horasEstimadas: 4,
    candidatos: 2,
  ),
  OrdemServico(
    id: 's2',
    titulo: 'Pintura do salão comunitário',
    descricao:
        'Precisamos repintar as paredes internas do salão que recebe cerca de 80 famílias por mês para distribuição de doações.',
    escopo: EscopoServico.pintura,
    instituicaoNome: 'Associação Mãos que Ajudam',
    instituicaoLocalizacao: 'São Bernardo do Campo, SP',
    distanciaKm: 3.1,
    horasEstimadas: 8,
    candidatos: 5,
  ),
  OrdemServico(
    id: 's3',
    titulo: 'Troca de fiação elétrica exposta',
    descricao:
        'A instalação elétrica do abrigo está com fiação exposta em três salas, representando risco aos acolhidos.',
    escopo: EscopoServico.eletricaEspecializada,
    marcadoComoAvancado: true,
    instituicaoNome: 'Abrigo Novo Amanhecer',
    instituicaoLocalizacao: 'Santo André, SP',
    distanciaKm: 6.8,
    horasEstimadas: 6,
    candidatos: 0,
  ),
  OrdemServico(
    id: 's4',
    titulo: 'Montagem de estantes na biblioteca comunitária',
    descricao:
        'Recebemos uma doação de estantes de livros desmontadas e precisamos de ajuda para montá-las e fixá-las.',
    escopo: EscopoServico.instalacaoMoveis,
    instituicaoNome: 'Biblioteca Comunitária Ler é Viver',
    instituicaoLocalizacao: 'São Bernardo do Campo, SP',
    distanciaKm: 1.4,
    horasEstimadas: 3,
    candidatos: 3,
  ),
  OrdemServico(
    id: 's5',
    titulo: 'Construção de rampa de acessibilidade',
    descricao:
        'A entrada principal do centro comunitário não possui rampa de acesso para cadeirantes e idosos.',
    escopo: EscopoServico.construcaoCivil,
    instituicaoNome: 'Centro Comunitário Vida Nova',
    instituicaoLocalizacao: 'Diadema, SP',
    distanciaKm: 9.5,
    horasEstimadas: 16,
    candidatos: 1,
  ),
  OrdemServico(
    id: 's6',
    titulo: 'Limpeza pós-obra do refeitório',
    descricao:
        'Após uma pequena reforma, o refeitório precisa de limpeza pesada antes da reabertura para as crianças.',
    escopo: EscopoServico.limpeza,
    instituicaoNome: 'Creche Sementinha do Bem',
    instituicaoLocalizacao: 'São Bernardo do Campo, SP',
    distanciaKm: 2.3,
    horasEstimadas: 5,
    candidatos: 4,
  ),
];

/// Serviços já concluídos pelo operário (aba "Meus Serviços" > "Realizados").
final List<OrdemServico> mockServicosRealizados = [
  OrdemServico(
    id: 'r1',
    titulo: 'Reparo em vazamento de cozinha',
    descricao: 'Substituição de conexões hidráulicas com vazamento na pia industrial.',
    escopo: EscopoServico.eletricaBasica,
    instituicaoNome: 'Cozinha Solidária Pão Nosso',
    instituicaoLocalizacao: 'São Bernardo do Campo, SP',
    distanciaKm: 1.8,
    horasEstimadas: 3,
    status: StatusServico.concluido,
    horasRealizadas: 3.5,
    pontosGanhos: 18,
  ),
  OrdemServico(
    id: 'r2',
    titulo: 'Reforma de piso da sala de aula',
    descricao: 'Nivelamento e reassentamento de pisos soltos na sala de reforço escolar.',
    escopo: EscopoServico.construcaoCivil,
    instituicaoNome: 'Projeto Educar Mais',
    instituicaoLocalizacao: 'São Bernardo do Campo, SP',
    distanciaKm: 4.2,
    horasEstimadas: 10,
    status: StatusServico.concluido,
    horasRealizadas: 9,
    pontosGanhos: 90,
  ),
];

/// Serviço aceito pelo operário e em andamento (aba "Meus Serviços" > "Aceitos").
final List<OrdemServico> mockServicosAceitos = [
  OrdemServico(
    id: 'a1',
    titulo: 'Instalação de portas do dormitório',
    descricao: 'Instalação de 4 portas novas doadas para o dormitório do abrigo.',
    escopo: EscopoServico.carpintaria,
    instituicaoNome: 'Abrigo Novo Amanhecer',
    instituicaoLocalizacao: 'Santo André, SP',
    distanciaKm: 6.8,
    horasEstimadas: 5,
    status: StatusServico.aceito,
  ),
];
