import 'package:flutter/material.dart';
import '../models/service_order.dart';

/// Selo colorido que indica o nível de complexidade de um serviço e,
/// opcionalmente, a taxa de pontos por hora correspondente (US03.1 e
/// US05.1).
class ComplexityBadge extends StatelessWidget {
  final ServiceComplexity complexity;
  final bool showPoints;

  const ComplexityBadge({
    super.key,
    required this.complexity,
    this.showPoints = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: complexity.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        showPoints
            ? '${complexity.label} · ${complexity.pontosPorHora.toStringAsFixed(1)} pts/h'
            : complexity.label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: complexity.color,
        ),
      ),
    );
  }
}
