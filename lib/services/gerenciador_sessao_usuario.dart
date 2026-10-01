import 'package:flutter/foundation.dart';
import '../models/instituicao.dart';
import '../models/operario.dart';

/// Gerenciador de estado global para a sessão ativa do usuário logado.
/// Armazena em memória o perfil do Operário ou da Instituição recuperado da AWS.
class GerenciadorSessaoUsuario extends ChangeNotifier {
  GerenciadorSessaoUsuario._();
  static final GerenciadorSessaoUsuario instancia =
      GerenciadorSessaoUsuario._();

  PerfilOperario? _operarioLogado;
  PerfilInstituicao? _instituicaoLogada;

  PerfilOperario? get operarioLogado => _operarioLogado;
  PerfilInstituicao? get instituicaoLogada => _instituicaoLogada;

  /// Retorna o perfil do operário logado ou o objeto padrão caso não haja perfil carregado.
  PerfilOperario get operarioAtual => _operarioLogado ?? mockOperarioAtual;

  /// Retorna o perfil da instituição logada ou o objeto padrão caso não haja perfil carregado.
  PerfilInstituicao get instituicaoAtual =>
      _instituicaoLogada ?? mockInstituicaoAtual;

  bool get temOperarioLogado => _operarioLogado != null;
  bool get temInstituicaoLogada => _instituicaoLogada != null;

  void definirOperarioLogado(PerfilOperario perfil) {
    _operarioLogado = perfil;
    _instituicaoLogada = null;
    notifyListeners();
  }

  void definirInstituicaoLogada(PerfilInstituicao perfil) {
    _instituicaoLogada = perfil;
    _operarioLogado = null;
    notifyListeners();
  }

  void limparSessao() {
    _operarioLogado = null;
    _instituicaoLogada = null;
    notifyListeners();
  }

  /// Converte o mapa JSON de usuário retornado pelo AppSync GraphQL em uma instância de [PerfilOperario].
  static PerfilOperario converterMapParaOperario(Map<String, dynamic> mapa) {
    final escoposBrutos = mapa['escopo_operario'];
    final List<String> escoposLista = escoposBrutos is List
        ? escoposBrutos.map((e) => e.toString()).toList()
        : ['Manutenção básica'];

    final int servicos =
        (mapa['quantidade_servicos_realizados'] as num?)?.toInt() ??
            int.tryParse(mapa['nivel_operario'] ?? '0') ??
            0;

    final double raio =
        (mapa['raio_atendimento_km'] as num?)?.toDouble() ?? 10.0;

    return PerfilOperario(
      nome: mapa['nome'] as String? ?? 'Operário Solidário',
      email: mapa['email'] as String? ?? '',
      telefone: mapa['telefone'] as String? ?? '',
      cpf: mapa['cpf'] as String? ?? '',
      localizacao: mapa['endereco_texto'] as String? ?? 'São Paulo, SP',
      portfolioAnexado: mapa['portfolio_url'] != null &&
          (mapa['portfolio_url'] as String).isNotEmpty,
      experienciasAnteriores: mapa['experiencias_anteriores'] as String? ??
          'Sem experiências registradas',
      escopos: escoposLista.isEmpty ? ['Manutenção básica'] : escoposLista,
      raioAtendimentoKm: raio,
      servicosRealizados: servicos,
      pontos: servicos * 25 + 10,
      avaliacaoMedia: 5.0,
    );
  }

  /// Converte o mapa JSON de usuário retornado pelo AppSync GraphQL em uma instância de [PerfilInstituicao].
  static PerfilInstituicao converterMapParaInstituicao(
      Map<String, dynamic> mapa) {
    final textoTipo = mapa['tipo_entidade'] as String? ?? 'ONGs';

    List<TipoInstituicao> tiposEncontrados = [TipoInstituicao.ong];
    if (textoTipo.toLowerCase().contains('igreja')) {
      tiposEncontrados = [TipoInstituicao.igreja];
    } else if (textoTipo.toLowerCase().contains('causa')) {
      tiposEncontrados = [TipoInstituicao.causasSociais];
    } else if (textoTipo.toLowerCase().contains('outro')) {
      tiposEncontrados = [TipoInstituicao.outros];
    }

    return PerfilInstituicao(
      nome: mapa['nome_instituicao'] as String? ??
          mapa['nome'] as String? ??
          'Instituição Solidária',
      emailInstitucional: mapa['email'] as String? ?? '',
      telefone: mapa['telefone'] as String? ?? '',
      cnpj: mapa['cnpj'] as String? ?? '',
      localizacao: mapa['endereco_texto'] as String? ?? 'São Paulo, SP',
      tipos: tiposEncontrados,
      informacoesAdicionais: const {},
      totalDoado: 0.0,
      servicosPublicados: 1,
    );
  }
}
