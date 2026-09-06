import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Cabeçalho de seção padrão usado nas telas do app, com título e
/// uma ação opcional ("ver tudo", "filtrar" etc.).
class TituloSecao extends StatelessWidget {
  final String titulo;
  final String? rotuloAcao;
  final VoidCallback? aoExecutarAcao;

  const TituloSecao({
    super.key,
    required this.titulo,
    this.rotuloAcao,
    this.aoExecutarAcao,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          titulo,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: CoresApp.textoPrimario,
          ),
        ),
        if (rotuloAcao != null)
          GestureDetector(
            onTap: aoExecutarAcao,
            child: Text(
              rotuloAcao!,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: CoresApp.vermelhoAcao,
              ),
            ),
          ),
      ],
    );
  }
}
