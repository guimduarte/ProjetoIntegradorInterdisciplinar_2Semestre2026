import 'package:flutter/material.dart';
import '../../models/service_order.dart';
import '../../theme/app_theme.dart';
import '../../widgets/complexity_badge.dart';

/// Aba "Meus Serviços" do operário, separando chamados 'Aceitos'
/// (em andamento) de 'Realizados' (com horas gastas e pontos
/// angariados) — US05.2.
class MyServicesScreen extends StatelessWidget {
  const MyServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Meus Serviços'),
          bottom: const TabBar(
            tabs: [Tab(text: 'Aceitos'), Tab(text: 'Realizados')],
          ),
        ),
        body: TabBarView(
          children: [
            _ServicesList(services: mockServicosAceitos, showResultado: false),
            _ServicesList(services: mockServicosRealizados, showResultado: true),
          ],
        ),
      ),
    );
  }
}

class _ServicesList extends StatelessWidget {
  final List<ServiceOrder> services;
  final bool showResultado;

  const _ServicesList({required this.services, required this.showResultado});

  @override
  Widget build(BuildContext context) {
    if (services.isEmpty) {
      return Center(
        child: Text(
          showResultado ? 'Nenhum serviço realizado ainda.' : 'Nenhum serviço em andamento.',
          style: const TextStyle(color: AppColors.textoSecundario, fontSize: 13),
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: services.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final s = services[index];
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
              Row(
                children: [
                  Expanded(
                    child: Text(
                      s.titulo,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                  ),
                  ComplexityBadge(complexity: s.complexidade),
                ],
              ),
              const SizedBox(height: 4),
              Text(s.instituicaoNome,
                  style: const TextStyle(fontSize: 11, color: AppColors.textoSecundario)),
              const SizedBox(height: 10),
              if (showResultado) ...[
                Row(
                  children: [
                    _statPill(Icons.schedule_rounded,
                        '${s.horasRealizadas?.toStringAsFixed(1) ?? '-'} h trabalhadas'),
                    const SizedBox(width: 8),
                    _statPill(Icons.toll_rounded, '+${s.pontosGanhos ?? 0} pts',
                        color: AppColors.amareloEscuro),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _avaliarServico(context, s),
                    icon: const Icon(Icons.star_border_rounded, size: 16),
                    label: const Text('Avaliar instituição', style: TextStyle(fontSize: 12)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.amareloEscuro,
                      side: const BorderSide(color: AppColors.amareloSolidario),
                    ),
                  ),
                ),
              ] else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.amareloFundo,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Em andamento',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.amareloEscuro),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _statPill(IconData icon, String label, {Color? color}) {
    final c = color ?? AppColors.textoSecundario;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.fundoTela,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: c),
          const SizedBox(width: 3),
          Text(label, style: TextStyle(fontSize: 11, color: c, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  void _avaliarServico(BuildContext context, ServiceOrder s) {
    int estrelas = 5;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Avaliar ${s.instituicaoNome}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  final filled = i < estrelas;
                  return IconButton(
                    onPressed: () => setModalState(() => estrelas = i + 1),
                    icon: Icon(
                      filled ? Icons.star_rounded : Icons.star_border_rounded,
                      color: AppColors.amareloSolidario,
                      size: 32,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Avaliação enviada. Obrigado!')),
                    );
                  },
                  child: const Text('Enviar avaliação'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
