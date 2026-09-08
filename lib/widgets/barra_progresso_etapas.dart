import 'package:flutter/material.dart';
import '../theme/tema_do_app.dart';

/// Indicador visual de progresso para os formulários de cadastro em
/// duas partes (US01.2 e US01.3: "Parte 1" / "Parte 2").
class BarraProgressoEtapas extends StatelessWidget {
  final int etapaAtual;
  final List<String> rotulosEtapas;

  const BarraProgressoEtapas({
    super.key,
    required this.etapaAtual,
    required this.rotulosEtapas,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(rotulosEtapas.length * 2 - 1, (i) {
        if (i.isOdd) {
          final leftStepDone = (i ~/ 2) < etapaAtual;
          return Expanded(
            child: Container(
              height: 2,
              color: leftStepDone ? CoresApp.vermelhoAcao : CoresApp.borda,
            ),
          );
        }
        final stepIndex = i ~/ 2;
        final isActive = stepIndex == etapaAtual;
        final isDone = stepIndex < etapaAtual;
        return Column(
          children: [
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (isActive || isDone)
                    ? CoresApp.vermelhoAcao
                    : CoresApp.branco,
                border: Border.all(
                  color: (isActive || isDone)
                      ? CoresApp.vermelhoAcao
                      : CoresApp.borda,
                  width: 1.5,
                ),
              ),
              child: isDone
                  ? const Icon(Icons.check_rounded, size: 16, color: CoresApp.branco)
                  : Text(
                      '${stepIndex + 1}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isActive ? CoresApp.branco : CoresApp.textoSecundario,
                      ),
                    ),
            ),
            const SizedBox(height: 4),
            Text(
              rotulosEtapas[stepIndex],
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? CoresApp.textoPrimario : CoresApp.textoSecundario,
              ),
            ),
          ],
        );
      }),
    );
  }
}
