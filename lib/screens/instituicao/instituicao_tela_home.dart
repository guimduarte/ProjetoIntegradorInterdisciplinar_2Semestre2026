import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';

import '../../models/amplify/ModelProvider.dart';
import '../../models/amplify/Service.dart';

import 'package:flutter/material.dart';
import '../../models/instituicao.dart';
import '../../models/ordem_servico.dart';
import '../../services/gerenciador_sessao_usuario.dart';
import '../../theme/tema_do_app.dart';
import '../../widgets/titulo_secao.dart';
import '../../widgets/card_servicos.dart';
import '../shared/tela_notificacoes.dart';
import 'instituicao_tela_novo_servico.dart';

/// Tela inicial da instituição: botão de ação flutuante para criar um 'Novo Serviço'
/// e visão geral dos serviços publicados.
class InstituicaoTelaHome extends StatefulWidget {
  const InstituicaoTelaHome({super.key});

  @override
  State<InstituicaoTelaHome> createState() => _InstituicaoTelaHomeState();
}

class _InstituicaoTelaHomeState extends State<InstituicaoTelaHome> {
  List<OrdemServico> _servicosPublicados = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _buscarServicosAWS();
  }

  // --- READ: Busca serviços no DynamoDB ---
  Future<void> _buscarServicosAWS() async {
    setState(() => _carregando = true);

    try {
      final request = ModelQueries.list(Service.classType);
      final response = await Amplify.API.query(request: request).response;
      final servicosAWSBrutos =
          response.data?.items.whereType<Service>().toList() ?? [];

      final servicosConvertidos =
          servicosAWSBrutos.map<OrdemServico>((servicoAWS) {
        return OrdemServico.fromAWS(servicoAWS);
      }).toList();

      setState(() {
        _servicosPublicados = servicosConvertidos;
        _carregando = false;
      });
    } on ApiException catch (e) {
      debugPrint('Erro ao buscar serviços na AWS: ${e.message}');
      setState(() => _carregando = false);
    }
  }

  // --- DELETE: Confirma e deleta na AWS ---
  Future<void> _deletarServico(OrdemServico servicoVisual) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir Serviço?'),
        content: const Text('Esta ação removerá o serviço permanentemente.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(
              foregroundColor: CoresApp.vermelhoEscuro,
            ),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    if (servicoVisual.awsService == null) {
      setState(() {
        _servicosPublicados.remove(servicoVisual);
      });
      return;
    }

    try {
      final request = ModelMutations.delete(servicoVisual.awsService!);
      await Amplify.API.mutate(request: request).response;

      setState(() {
        _servicosPublicados.remove(servicoVisual);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Serviço excluído com sucesso!')),
        );
      }
    } on ApiException catch (e) {
      debugPrint('Erro ao deletar serviço na AWS: ${e.message}');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao excluir: ${e.message}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: GerenciadorSessaoUsuario.instancia,
      builder: (context, _) {
        final instituicao =
            GerenciadorSessaoUsuario.instancia.instituicaoAtual;

        return Scaffold(
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 90),
              children: [
                _buildHeader(context, instituicao),
                _buildStats(instituicao),
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
                  child: TituloSecao(titulo: 'Seus serviços publicados'),
                ),
                if (_carregando)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(
                          color: CoresApp.vermelhoAcao),
                    ),
                  )
                else if (_servicosPublicados.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Nenhum serviço publicado ainda.'),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: _servicosPublicados
                          .map((s) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: CardServicos(
                                  servico: s,
                                  onDeletar: () => _deletarServico(s),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              final recarregar = await Navigator.of(context).push<bool>(
                MaterialPageRoute(
                    builder: (_) => const InstituicaoTelaNovoServico()),
              );
              if (recarregar == true) {
                _buscarServicosAWS();
              }
            },
            backgroundColor: CoresApp.vermelhoAcao,
            foregroundColor: CoresApp.branco,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Novo Serviço'),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, PerfilInstituicao instituicao) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
      decoration: const BoxDecoration(
        color: CoresApp.azulConfianca,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Bem-vinda,',
                        style:
                            TextStyle(color: Color(0xFFC7D3E6), fontSize: 12)),
                    Text(
                      instituicao.nome,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: CoresApp.branco,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const TelaNotificacoes(ehInstituicao: true),
                  ),
                ),
                child: const Icon(Icons.notifications_none_rounded,
                    color: CoresApp.branco),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.location_on_outlined,
                  color: Color(0xFFFFC96B), size: 14),
              const SizedBox(width: 4),
              Text(
                instituicao.localizacao,
                style: const TextStyle(color: Color(0xFFFFC96B), fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStats(PerfilInstituicao instituicao) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: _statCard(
              icon: Icons.assignment_turned_in_outlined,
              texto: 'Serviços publicados',
              value: '${instituicao.servicosPublicados}',
              color: CoresApp.azulClaro,
              background: CoresApp.azulFundo,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _statCard(
              icon: Icons.volunteer_activism_rounded,
              texto: 'Doado à plataforma',
              value: 'R\$ ${instituicao.totalDoado.toStringAsFixed(0)}',
              color: CoresApp.amareloEscuro,
              background: CoresApp.amareloFundo,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard({
    required IconData icon,
    required String texto,
    required String value,
    required Color color,
    required Color background,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: CoresApp.branco,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CoresApp.borda),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration:
                BoxDecoration(color: background, shape: BoxShape.circle),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(height: 8),
          Text(value,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: CoresApp.textoPrimario)),
          Text(texto,
              style: const TextStyle(
                  fontSize: 10, color: CoresApp.textoSecundario)),
        ],
      ),
    );
  }
}