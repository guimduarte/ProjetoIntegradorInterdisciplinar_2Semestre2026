import 'package:flutter/material.dart';
import '../models/service_order.dart';
import '../theme/app_theme.dart';
import 'selo_de_complexidade.dart';

/// Card de serviço exibido no feed do operário (US04.1) e no painel
/// de serviços publicados pela instituição. Quando [locked] é
/// verdadeiro, o card é exibido de forma esmaecida com um cadeado,
/// indicando que o operário não atende ao raio ou ao nível de
/// experiência exigido (US04.2).
class CardServicos extends StatelessWidget {
  final OrdemServico servico;
  final bool locked;
  final String? lockedReason;
  final VoidCallback? onTap;
  final Widget? trailingAction;

  const CardServicos({
    super.key,
    required this.servico,
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
        color: CoresApp.branco,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: locked ? null : onTap,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: CoresApp.borda),
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
                        color: CoresApp.azulFundo,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(servico.escopo.icone,
                          color: CoresApp.azulClaro, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            servico.titulo,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: CoresApp.textoPrimario,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            servico.instituicaoNome,
                            style: const TextStyle(
                              fontSize: 11,
                              color: CoresApp.textoSecundario,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (locked)
                      const Icon(Icons.lock_outline_rounded,
                          size: 18, color: CoresApp.bloqueado),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    SeloDeComplexidade(complexidade: servico.complexidade, showPoints: true),
                    _InformacaoTag(
                      icon: Icons.place_outlined,
                      texto: '${servico.distanciaKm.toStringAsFixed(1)} km',
                    ),
                    _InformacaoTag(
                      icon: Icons.schedule_rounded,
                      texto: '~${servico.horasEstimadas.toStringAsFixed(0)} h',
                    ),
                    if (servico.status != StatusServico.aberto)
                      _InformacaoTag(
                        icon: Icons.flag_outlined,
                        texto: servico.status.texto,
                        color: servico.status.cor,
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
                      color: CoresApp.bloqueado,
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

class _InformacaoTag extends StatelessWidget {
  final IconData icon;
  final String texto;
  final Color? color;

  const _InformacaoTag({required this.icon, required this.texto, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? CoresApp.textoSecundario;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: c),
        const SizedBox(width: 3),
        Text(texto, style: TextStyle(fontSize: 11, color: c)),
      ],
    );
  }
}
