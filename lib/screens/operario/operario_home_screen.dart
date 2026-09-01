import 'package:flutter/material.dart';
import '../../models/experience_level.dart';
import '../../models/operario.dart';
import '../../models/service_order.dart';
import '../../theme/app_theme.dart';
import '../../widgets/section_title.dart';
import '../../widgets/service_card.dart';
import '../shared/notifications_screen.dart';
import 'my_services_screen.dart';
import 'service_detail_screen.dart';

/// Tela inicial do operário (ÉPICO 04): exibe apenas os serviços
/// dentro do raio de deslocamento cadastrado (US04.1) e sinaliza,
/// sem esconder por completo, os serviços fora do nível de
/// experiência exigido (US04.2 adaptado para fins de transparência
/// no protótipo — cards aparecem bloqueados com o motivo).
class OperarioHomeScreen extends StatefulWidget {
  const OperarioHomeScreen({super.key});

  @override
  State<OperarioHomeScreen> createState() => _OperarioHomeScreenState();
}

class _OperarioHomeScreenState extends State<OperarioHomeScreen> {
  ServiceScope? _filtroEscopo;

  @override
  Widget build(BuildContext context) {
    final operario = mockOperarioAtual;
    final servicos = mockServiceOrders.where((s) {
      if (_filtroEscopo == null) return true;
      return s.escopo == _filtroEscopo;
    }).toList();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 20),
          children: [
            _buildHeader(context, operario),
            _buildImpactBanner(),
            _buildQuickAccess(context),
            _buildScopeFilter(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: SectionTitle(
                title: 'Serviços no seu raio (${operario.raioAtendimentoKm.toStringAsFixed(0)} km)',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: servicos.map((s) {
                  final apto = s.operarioEstaApto(
                    operario.raioAtendimentoKm,
                    operario.servicosRealizados,
                  );
                  final dentroDoRaio = s.distanciaKm <= operario.raioAtendimentoKm;
                  String? motivo;
                  if (!dentroDoRaio) {
                    motivo = 'Fora do seu raio de atendimento';
                  } else if (!apto) {
                    motivo =
                        'Requer nível ${s.complexidade.nivelMinimoExigido.label}';
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ServiceCard(
                      service: s,
                      locked: !apto,
                      lockedReason: motivo,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ServiceDetailScreen(service: s),
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
  }

  Widget _buildHeader(BuildContext context, OperarioProfile operario) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
      decoration: const BoxDecoration(
        color: AppColors.azulConfianca,
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
                    operario.nome.split(' ').first,
                    style: const TextStyle(
                      color: AppColors.branco,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const NotificationsScreen(isInstituicao: false),
                  ),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.notifications_none_rounded, color: AppColors.branco),
                    Positioned(
                      right: -4,
                      top: -4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: AppColors.amareloSolidario,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          '2',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.amareloEscuro,
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
              const Icon(Icons.location_on_outlined, color: Color(0xFFFFC96B), size: 14),
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
              prefixIcon: Icon(Icons.search, color: AppColors.textoSecundario),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImpactBanner() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.amareloSolidario,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.workspace_premium_rounded, color: AppColors.amareloEscuro, size: 26),
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
                      color: AppColors.amareloEscuro,
                    ),
                  ),
                  Text(
                    '${mockOperarioAtual.pontos} pontos · ${mockOperarioAtual.servicosRealizados} serviços realizados',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF633806)),
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
                MaterialPageRoute(builder: (_) => const MyServicesScreen()),
              ),
              icon: const Icon(Icons.assignment_outlined, size: 18),
              label: const Text('Meus Serviços', style: TextStyle(fontSize: 12)),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.azulConfianca,
                side: const BorderSide(color: AppColors.azulConfianca),
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
          const SectionTitle(title: 'Filtrar por escopo'),
          const SizedBox(height: 10),
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: ServiceScope.values.length + 1,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                if (index == 0) {
                  final selected = _filtroEscopo == null;
                  return _chip('Todos', selected, () => setState(() => _filtroEscopo = null));
                }
                final escopo = ServiceScope.values[index - 1];
                final selected = _filtroEscopo == escopo;
                return _chip(
                  escopo.label,
                  selected,
                  () => setState(() => _filtroEscopo = selected ? null : escopo),
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
      selectedColor: AppColors.vermelhoAcao,
      backgroundColor: AppColors.branco,
      labelStyle: TextStyle(color: selected ? AppColors.branco : AppColors.azulConfianca),
      shape: StadiumBorder(
        side: BorderSide(color: selected ? AppColors.vermelhoAcao : AppColors.azulConfianca),
      ),
    );
  }
}
