import 'nivel_experiencia.dart';

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
class PerfilOperario {
  final String id;
  final String nome;
  final String email;
  final String telefone;
  final String cpf;
  final String localizacao;
  final double? latitude;
  final double? longitude;
  final bool portfolioAnexado;
  final String portfolioUrl;
  final String experienciasAnteriores;
  final List<String> escopos;
  final double raioAtendimentoKm;
  final int servicosRealizados;
  final int pontos;
  final double avaliacaoMedia;

  const PerfilOperario({
    this.id = '',
    required this.nome,
    required this.email,
    required this.telefone,
    required this.cpf,
    required this.localizacao,
    this.latitude,
    this.longitude,
    required this.portfolioAnexado,
    this.portfolioUrl = '',
    required this.experienciasAnteriores,
    required this.escopos,
    required this.raioAtendimentoKm,
    required this.servicosRealizados,
    required this.pontos,
    required this.avaliacaoMedia,
  });

  NivelExperiencia get nivelExperiencia =>
      NivelExperienciaX.deServicosRealizados(servicosRealizados);

  String get iniciais {
    final partes = nome.trim().split(' ');
    if (partes.length == 1) return partes.first.substring(0, 1).toUpperCase();
    return (partes.first.substring(0, 1) + partes.last.substring(0, 1))
        .toUpperCase();
  }

  PerfilOperario copyWith({
    String? id,
    String? nome,
    String? email,
    String? telefone,
    String? localizacao,
    double? latitude,
    double? longitude,
    bool? portfolioAnexado,
    String? portfolioUrl,
    double? raioAtendimentoKm,
    List<String>? escopos,
    String? experienciasAnteriores,
  }) {
    return PerfilOperario(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      telefone: telefone ?? this.telefone,
      cpf: cpf,
      localizacao: localizacao ?? this.localizacao,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      portfolioAnexado: portfolioAnexado ?? this.portfolioAnexado,
      portfolioUrl: portfolioUrl ?? this.portfolioUrl,
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
final PerfilOperario mockOperarioAtual = const PerfilOperario(
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
