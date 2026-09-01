import 'package:flutter/material.dart';
import '../../models/instituicao.dart';
import '../../models/service_order.dart';
import '../../theme/app_theme.dart';
import '../../widgets/section_title.dart';
import '../../widgets/service_card.dart';
import '../shared/notifications_screen.dart';
import 'new_service_screen.dart';

/// Tela inicial da instituição (ÉPICO 02 - US02.2): botão de ação
/// flutuante para criar um 'Novo Serviço' e visão geral dos serviços
/// publicados.
class InstitutionHomeScreen extends StatefulWidget {
  const InstitutionHomeScreen({super.key});

  @override
  State<InstitutionHomeScreen> createState() => _InstitutionHomeScreenState();
}

class _InstitutionHomeScreenState extends State<InstitutionHomeScreen> {
  final List<ServiceOrder> _publicados = List.of(mockServiceOrders.take(3));

  @override
  Widget build(BuildContext context) {
    final instituicao = mockInstituicaoAtual;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 90),
          children: [
            _buildHeader(context, instituicao),
            _buildStats(instituicao),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: SectionTitle(title: 'Seus serviços publicados'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: _publicados
                    .map((s) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: ServiceCard(service: s),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final novo = await Navigator.of(context).push<ServiceOrder>(
            MaterialPageRoute(builder: (_) => const NewServiceScreen()),
          );
          if (novo != null) {
            setState(() => _publicados.insert(0, novo));
          }
        },
        backgroundColor: AppColors.vermelhoAcao,
        foregroundColor: AppColors.branco,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Novo Serviço'),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, InstituicaoProfile instituicao) {
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Bem-vinda,',
                        style: TextStyle(color: Color(0xFFC7D3E6), fontSize: 12)),
                    Text(
                      instituicao.nome,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.branco,
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
                    builder: (_) => const NotificationsScreen(isInstituicao: true),
                  ),
                ),
                child: const Icon(Icons.notifications_none_rounded, color: AppColors.branco),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, color: Color(0xFFFFC96B), size: 14),
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

  Widget _buildStats(InstituicaoProfile instituicao) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: _statCard(
              icon: Icons.assignment_turned_in_outlined,
              label: 'Serviços publicados',
              value: '${instituicao.servicosPublicados}',
              color: AppColors.azulClaro,
              background: AppColors.azulFundo,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _statCard(
              icon: Icons.volunteer_activism_rounded,
              label: 'Doado à plataforma',
              value: 'R\$ ${instituicao.totalDoado.toStringAsFixed(0)}',
              color: AppColors.amareloEscuro,
              background: AppColors.amareloFundo,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required Color background,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.branco,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borda),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: background, shape: BoxShape.circle),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(height: 8),
          Text(value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textoPrimario)),
          Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textoSecundario)),
        ],
      ),
    );
  }
}
