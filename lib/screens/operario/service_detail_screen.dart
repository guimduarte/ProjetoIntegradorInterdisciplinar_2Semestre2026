import 'package:flutter/material.dart';
import '../../models/experience_level.dart';
import '../../models/service_order.dart';
import '../../theme/app_theme.dart';
import '../../widgets/complexity_badge.dart';

/// Tela de detalhe de um serviço publicado, com opção de candidatura
/// pelo operário (US03.1 / US03.2 — candidatura gera um chamado para
/// a instituição avaliar).
class ServiceDetailScreen extends StatefulWidget {
  final ServiceOrder service;

  const ServiceDetailScreen({super.key, required this.service});

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  bool _candidatado = false;

  @override
  Widget build(BuildContext context) {
    final s = widget.service;
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do serviço')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.azulFundo,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(s.escopo.icon, color: AppColors.azulClaro, size: 28),
            ),
            const SizedBox(height: 14),
            Text(
              s.titulo,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textoPrimario),
            ),
            const SizedBox(height: 4),
            Text(
              s.instituicaoNome,
              style: const TextStyle(fontSize: 13, color: AppColors.textoSecundario),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ComplexityBadge(complexity: s.complexidade, showPoints: true),
                _tagChip(Icons.place_outlined, '${s.distanciaKm.toStringAsFixed(1)} km · ${s.instituicaoLocalizacao}'),
                _tagChip(Icons.schedule_rounded, '~${s.horasEstimadas.toStringAsFixed(0)} horas estimadas'),
                _tagChip(Icons.groups_outlined, '${s.candidatos} candidato(s)'),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Descrição', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(
              s.descricao,
              style: const TextStyle(fontSize: 13, color: AppColors.textoSecundario, height: 1.5),
            ),
            const SizedBox(height: 20),
            const Text('Requisito de experiência', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(
              s.complexidade.nivelMinimoExigido.description,
              style: const TextStyle(fontSize: 13, color: AppColors.textoSecundario, height: 1.5),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _candidatado ? null : () => _candidatar(context),
                style: ElevatedButton.styleFrom(
                  disabledBackgroundColor: AppColors.verdeSucesso,
                  disabledForegroundColor: AppColors.branco,
                ),
                child: Text(_candidatado ? 'Candidatura enviada ✓' : 'Candidatar-se a este serviço'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tagChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.fundoTela,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borda),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.textoSecundario),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textoSecundario)),
        ],
      ),
    );
  }

  void _candidatar(BuildContext context) {
    setState(() => _candidatado = true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Candidatura enviada para ${widget.service.instituicaoNome}. Você será notificado sobre a decisão.',
        ),
      ),
    );
  }
}
