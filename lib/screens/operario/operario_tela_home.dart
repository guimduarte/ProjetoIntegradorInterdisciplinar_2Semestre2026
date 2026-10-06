import 'package:flutter/material.dart';
import '../../models/nivel_experiencia.dart';
import '../../models/operario.dart';
import '../../models/ordem_servico.dart';
import '../../services/gerenciador_sessao_usuario.dart';
import '../../theme/tema_do_app.dart';
import '../../widgets/titulo_secao.dart';
import '../../widgets/card_servicos.dart';
import '../shared/tela_notificacoes.dart';
import 'operario_tela_servicos.dart';
import 'operario_tela_de_detalhes_do_servico.dart';

/// Tela inicial do operário (ÉPICO 04): exibe apenas os serviços
/// dentro do raio de deslocamento cadastrado (US04.1) e sinaliza,
/// sem esconder por completo, os serviços fora do nível de
/// experiência exigido.
class OperarioTelaHome extends StatefulWidget {
  const OperarioTelaHome({super.key});

  @override
  State<OperarioTelaHome> createState() => _OperarioTelaHomeState();
}

class _OperarioTelaHomeState extends State<OperarioTelaHome> {
  EscopoServico? _filtroEscopo;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: GerenciadorSessaoUsuario.instancia,
      builder: (context, _) {
        final operario = GerenciadorSessaoUsuario.instancia.operarioAtual;
        final servicos = mockOrdensServico.where((s) {
          if (_filtroEscopo == null) return true;
          return s.escopo == _filtroEscopo;
        }).toList();

        return Scaffold(
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 20),
              children: [
                _buildHeader(context, operario),
                _buildImpactBanner(operario),
                _buildQuickAccess(context),
                _buildScopeFilter(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                  child: TituloSecao(
                    titulo:
                        'Serviços no seu raio (${operario.raioAtendimentoKm.toStringAsFixed(0)} km)',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: servicos.map((s) {
                      final estaApto = s.operarioEstaApto(
                        operario.raioAtendimentoKm,
                        operario.servicosRealizados,
                      );
                      final dentroDoRaio =
                          s.distanciaKm <= operario.raioAtendimentoKm;
                      String? motivo;
                      if (!dentroDoRaio) {
                        motivo = 'Fora do seu raio de atendimento';
                      } else if (!estaApto) {
                        motivo =
                            'Requer nível ${s.complexidade.nivelMinimoExigido.texto}';
                      }
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: CardServicos(
                          servico: s,
                          locked: !estaApto,
                          lockedReason: motivo,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  OperarioTelaDeDetalhesDoServico(servico: s),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, PerfilOperario operario) {
    final primeiroNome = operario.nome.trim().isNotEmpty
        ? operario.nome.trim().split(' ').first
        : 'Operário';

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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Olá,',
                    style: TextStyle(color: Color(0xFFC7D3E6), fontSize: 12),
                  ),
                  Text(
                    primeiroNome,
                    style: const TextStyle(
                      color: CoresApp.branco,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const TelaNotificacoes(ehInstituicao: false),
                  ),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.notifications_none_rounded,
                        color: CoresApp.branco),
                    Positioned(
                      right: -4,
                      top: -4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: CoresApp.amareloSolidario,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          '2',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: CoresApp.amareloEscuro,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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
                operario.localizacao,
                style: const TextStyle(color: Color(0xFFFFC96B), fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const TextField(
            decoration: InputDecoration(
              hintText: 'Buscar serviço solidário',
              prefixIcon: Icon(Icons.search, color: CoresApp.textoSecundario),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImpactBanner(PerfilOperario operario) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: CoresApp.amareloSolidario,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.workspace_premium_rounded,
                color: CoresApp.amareloEscuro, size: 26),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Seu impacto solidário',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: CoresApp.amareloEscuro,
                    ),
                  ),
                  Text(
                    '${operario.pontos} pontos · ${operario.servicosRealizados} serviços realizados',
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFF633806)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccess(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (_) => const OperarioTelaServicos()),
              ),
              icon: const Icon(Icons.assignment_outlined, size: 18),
              label: const Text('Meus Serviços',
                  style: TextStyle(fontSize: 12)),
              style: OutlinedButton.styleFrom(
                foregroundColor: CoresApp.azulConfianca,
                side: const BorderSide(color: CoresApp.azulConfianca),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScopeFilter() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TituloSecao(titulo: 'Filtrar por escopo'),
          const SizedBox(height: 10),
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: EscopoServico.values.length + 1,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                if (index == 0) {
                  final selected = _filtroEscopo == null;
                  return _chip('Todos', selected,
                      () => setState(() => _filtroEscopo = null));
                }
                final escopo = EscopoServico.values[index - 1];
                final selected = _filtroEscopo == escopo;
                return _chip(
                  escopo.texto,
                  selected,
                  () =>
                      setState(() => _filtroEscopo = selected ? null : escopo),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, bool selected, VoidCallback onTap) {
    return ChoiceChip(
      label: Text(label, style: const TextStyle(fontSize: 11)),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: CoresApp.vermelhoAcao,
      backgroundColor: CoresApp.branco,
      labelStyle: TextStyle(
          color: selected ? CoresApp.branco : CoresApp.azulConfianca),
      shape: StadiumBorder(
        side: BorderSide(
            color: selected ? CoresApp.vermelhoAcao : CoresApp.azulConfianca),
      ),
    );
  }
}
