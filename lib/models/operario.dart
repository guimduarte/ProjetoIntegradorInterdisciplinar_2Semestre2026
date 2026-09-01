import 'experience_level.dart';

/// Escopos de trabalho manual que um operário pode selecionar em seu
/// cadastro profissional (US01.2, Parte 2).
const List<String> escoposDisponiveis = [
  'Instalação de móveis/eletros',
  'Manutenção básica',
  'Limpeza',
  'Pintura',
  'Elétrica/Encanamento básico',
  'Elétrica/Encanamento especializado',
  'Carpintaria/Marcenaria',
  'Construção civil',
];

/// Perfil completo do usuário 'Operário' (ÉPICO 01 - US01.2).
class OperarioProfile {
  final String nome;
  final String email;
  final String telefone;
  final String cpf;
  final String localizacao;
  final bool portfolioAnexado;
  final String experienciasAnteriores;
  final List<String> escopos;
  final double raioAtendimentoKm;
  final int servicosRealizados;
  final int pontos;
  final double avaliacaoMedia;

  const OperarioProfile({
    required this.nome,
    required this.email,
    required this.telefone,
    required this.cpf,
    required this.localizacao,
    required this.portfolioAnexado,
    required this.experienciasAnteriores,
    required this.escopos,
    required this.raioAtendimentoKm,
    required this.servicosRealizados,
    required this.pontos,
    required this.avaliacaoMedia,
  });

  ExperienceLevel get nivelExperiencia =>
      ExperienceLevelX.fromServicosRealizados(servicosRealizados);

  String get iniciais {
    final partes = nome.trim().split(' ');
    if (partes.length == 1) return partes.first.substring(0, 1).toUpperCase();
    return (partes.first.substring(0, 1) + partes.last.substring(0, 1))
        .toUpperCase();
  }

  OperarioProfile copyWith({
    String? nome,
    String? email,
    String? telefone,
    String? localizacao,
    double? raioAtendimentoKm,
    List<String>? escopos,
    String? experienciasAnteriores,
  }) {
    return OperarioProfile(
      nome: nome ?? this.nome,
      email: email ?? this.email,
      telefone: telefone ?? this.telefone,
      cpf: cpf,
      localizacao: localizacao ?? this.localizacao,
      portfolioAnexado: portfolioAnexado,
      experienciasAnteriores:
          experienciasAnteriores ?? this.experienciasAnteriores,
      escopos: escopos ?? this.escopos,
      raioAtendimentoKm: raioAtendimentoKm ?? this.raioAtendimentoKm,
      servicosRealizados: servicosRealizados,
      pontos: pontos,
      avaliacaoMedia: avaliacaoMedia,
    );
  }
}

/// Perfil mock usado para simular a sessão autenticada do operário
/// no protótipo (sem integração com backend/AWS).
final OperarioProfile mockOperarioAtual = const OperarioProfile(
  nome: 'Carlos Alberto Ferreira',
  email: 'carlos.alberto@email.com',
  telefone: '(11) 98765-4321',
  cpf: '123.456.789-00',
  localizacao: 'São Bernardo do Campo, SP',
  portfolioAnexado: true,
  experienciasAnteriores:
      'Mais de 8 anos de experiência em alvenaria, reboco e pequenos reparos residenciais.',
  escopos: ['Manutenção básica', 'Construção civil', 'Pintura'],
  raioAtendimentoKm: 10,
  servicosRealizados: 4,
  pontos: 187,
  avaliacaoMedia: 4.8,
);
