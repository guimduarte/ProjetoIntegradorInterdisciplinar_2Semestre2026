/// Tipo de entidade selecionável no cadastro institucional
/// (US01.3, Parte 2).
enum InstitutionType { igreja, causasSociais, ong, outros }

extension InstitutionTypeX on InstitutionType {
  String get label {
    switch (this) {
      case InstitutionType.igreja:
        return 'Igreja';
      case InstitutionType.causasSociais:
        return 'Causas Sociais';
      case InstitutionType.ong:
        return 'ONGs';
      case InstitutionType.outros:
        return 'Outros';
    }
  }

  /// Rótulo do campo dinâmico adicional exibido quando este tipo é
  /// selecionado (US01.3: "Campos dinâmicos de informações oficiais
  /// adicionais solicitados com base no tipo de instituição").
  String get campoAdicionalLabel {
    switch (this) {
      case InstitutionType.igreja:
        return 'Denominação/Diocese vinculada';
      case InstitutionType.causasSociais:
        return 'Área social de atuação';
      case InstitutionType.ong:
        return 'Número de registro (CNAS/CNPJ social)';
      case InstitutionType.outros:
        return 'Especifique o tipo de instituição';
    }
  }
}

/// Perfil completo do usuário 'Instituição' (ÉPICO 01 - US01.3).
class InstituicaoProfile {
  final String nome;
  final String emailInstitucional;
  final String telefone;
  final String cnpj;
  final String localizacao;
  final List<InstitutionType> tipos;
  final Map<InstitutionType, String> informacoesAdicionais;
  final double totalDoado;
  final int servicosPublicados;

  const InstituicaoProfile({
    required this.nome,
    required this.emailInstitucional,
    required this.telefone,
    required this.cnpj,
    required this.localizacao,
    required this.tipos,
    required this.informacoesAdicionais,
    required this.totalDoado,
    required this.servicosPublicados,
  });
}

/// Perfil mock usado para simular a sessão autenticada da instituição
/// no protótipo (sem integração com backend/AWS).
final InstituicaoProfile mockInstituicaoAtual = InstituicaoProfile(
  nome: 'Associação Mãos que Ajudam',
  emailInstitucional: 'contato@maosqueajudam.org',
  telefone: '(11) 3456-7890',
  cnpj: '12.345.678/0001-90',
  localizacao: 'São Bernardo do Campo, SP',
  tipos: const [InstitutionType.ong],
  informacoesAdicionais: const {
    InstitutionType.ong: 'CNAS 71.023.456/0001-12',
  },
  totalDoado: 340,
  servicosPublicados: 12,
);
