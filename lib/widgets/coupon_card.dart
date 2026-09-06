import 'package:flutter/material.dart';
import '../models/reward.dart';
import '../theme/app_theme.dart';

/// Card de cupom exibido na vitrine da Carteira de Benefícios
/// (US05.2), com o custo em pontos e a opção de resgate.
class CardCupom extends StatelessWidget {
  final Cupom cupom;
  final int saldoPontos;
  final VoidCallback aoResgatar;

  const CardCupom({
    super.key,
    required this.cupom,
    required this.saldoPontos,
    required this.aoResgatar,
  });

  @override
  Widget build(BuildContext context) {
    final podeResgatar = saldoPontos >= cupom.custoPontos;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CoresApp.branco,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CoresApp.borda),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: CoresApp.amareloFundo,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(cupom.categoria.icone,
                color: CoresApp.amareloEscuro, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cupom.titulo,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: CoresApp.textoPrimario,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  cupom.parceiro,
                  style: const TextStyle(fontSize: 11, color: CoresApp.textoSecundario),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.toll_rounded, size: 13, color: CoresApp.amareloEscuro),
                    const SizedBox(width: 3),
                    Text(
                      '${cupom.custoPontos} pontos',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: CoresApp.amareloEscuro,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 84,
            child: ElevatedButton(
              onPressed: podeResgatar ? aoResgatar : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 8),
                disabledBackgroundColor: CoresApp.bloqueadoFundo,
                disabledForegroundColor: CoresApp.bloqueado,
              ),
              child: const Text('Resgatar', style: TextStyle(fontSize: 11)),
            ),
          ),
        ],
      ),
    );
  }
}
