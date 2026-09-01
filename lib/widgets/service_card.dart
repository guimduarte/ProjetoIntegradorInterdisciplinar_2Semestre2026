import 'package:flutter/material.dart';
import '../models/service_order.dart';
import '../theme/app_theme.dart';
import 'complexity_badge.dart';

/// Card de serviço exibido no feed do operário (US04.1) e no painel
/// de serviços publicados pela instituição. Quando [locked] é
/// verdadeiro, o card é exibido de forma esmaecida com um cadeado,
/// indicando que o operário não atende ao raio ou ao nível de
/// experiência exigido (US04.2).
class ServiceCard extends StatelessWidget {
  final ServiceOrder service;
  final bool locked;
  final String? lockedReason;
  final VoidCallback? onTap;
  final Widget? trailingAction;

  const ServiceCard({
    super.key,
    required this.service,
    this.locked = false,
    this.lockedReason,
    this.onTap,
    this.trailingAction,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: locked ? 0.55 : 1,
      child: Material(
        color: AppColors.branco,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: locked ? null : onTap,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borda),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.azulFundo,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(service.escopo.icon,
                          color: AppColors.azulClaro, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service.titulo,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textoPrimario,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            service.instituicaoNome,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textoSecundario,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (locked)
                      const Icon(Icons.lock_outline_rounded,
                          size: 18, color: AppColors.bloqueado),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    ComplexityBadge(complexity: service.complexidade, showPoints: true),
                    _InfoChip(
                      icon: Icons.place_outlined,
                      label: '${service.distanciaKm.toStringAsFixed(1)} km',
                    ),
                    _InfoChip(
                      icon: Icons.schedule_rounded,
                      label: '~${service.horasEstimadas.toStringAsFixed(0)} h',
                    ),
                    if (service.status != ServiceStatus.aberto)
                      _InfoChip(
                        icon: Icons.flag_outlined,
                        label: service.status.label,
                        color: service.status.color,
                      ),
                  ],
                ),
                if (locked && lockedReason != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    lockedReason!,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.bloqueado,
                    ),
                  ),
                ],
                if (trailingAction != null) ...[
                  const SizedBox(height: 10),
                  trailingAction!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const _InfoChip({required this.icon, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.textoSecundario;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: c),
        const SizedBox(width: 3),
        Text(label, style: TextStyle(fontSize: 11, color: c)),
      ],
    );
  }
}
