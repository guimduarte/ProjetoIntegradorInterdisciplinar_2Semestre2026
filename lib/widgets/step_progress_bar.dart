import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Indicador visual de progresso para os formulários de cadastro em
/// duas partes (US01.2 e US01.3: "Parte 1" / "Parte 2").
class StepProgressBar extends StatelessWidget {
  final int currentStep;
  final List<String> stepLabels;

  const StepProgressBar({
    super.key,
    required this.currentStep,
    required this.stepLabels,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(stepLabels.length * 2 - 1, (i) {
        if (i.isOdd) {
          final leftStepDone = (i ~/ 2) < currentStep;
          return Expanded(
            child: Container(
              height: 2,
              color: leftStepDone ? AppColors.vermelhoAcao : AppColors.borda,
            ),
          );
        }
        final stepIndex = i ~/ 2;
        final isActive = stepIndex == currentStep;
        final isDone = stepIndex < currentStep;
        return Column(
          children: [
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (isActive || isDone)
                    ? AppColors.vermelhoAcao
                    : AppColors.branco,
                border: Border.all(
                  color: (isActive || isDone)
                      ? AppColors.vermelhoAcao
                      : AppColors.borda,
                  width: 1.5,
                ),
              ),
              child: isDone
                  ? const Icon(Icons.check_rounded, size: 16, color: AppColors.branco)
                  : Text(
                      '${stepIndex + 1}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isActive ? AppColors.branco : AppColors.textoSecundario,
                      ),
                    ),
            ),
            const SizedBox(height: 4),
            Text(
              stepLabels[stepIndex],
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? AppColors.textoPrimario : AppColors.textoSecundario,
              ),
            ),
          ],
        );
      }),
    );
  }
}
