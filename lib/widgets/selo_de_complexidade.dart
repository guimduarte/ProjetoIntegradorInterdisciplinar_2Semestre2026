import 'package:flutter/material.dart';
import '../models/ordem_servico.dart';

/// Selo colorido que indica o nível de complexidade de um serviço e,
/// opcionalmente, a taxa de pontos por hora correspondente (US03.1 e
/// US05.1).
class SeloDeComplexidade extends StatelessWidget {
  final ComplexidadeServico complexidade;
  final bool showPoints;

  const SeloDeComplexidade({
    super.key,
    required this.complexidade,
    this.showPoints = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: complexidade.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        showPoints
            ? '${complexidade.texto} · ${complexidade.pontosPorHora.toStringAsFixed(1)} pts/h'
            : complexidade.texto,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: complexidade.cor,
        ),
      ),
    );
  }
}
