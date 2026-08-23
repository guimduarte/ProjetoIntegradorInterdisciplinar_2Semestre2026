import 'package:flutter/material.dart';
import '../models/profissional.dart';
import '../theme/app_theme.dart';

/// Card que exibe os dados de um profissional disponível para
/// prestar serviço, incluindo avaliação, distância e selos de
/// confiança (verificado por ONG ou serviço voluntário).
class CardProfissional extends StatelessWidget {
  final Profissional profissional;
  final VoidCallback? onRequest;
  final bool compact;

  const CardProfissional({
    super.key,
    required this.profissional,
    this.onRequest,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
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
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.azulFundo,
                child: Text(
                  profissional.iniciais,
                  style: const TextStyle(
                    color: AppColors.azulClaro,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profissional.nome,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textoPrimario,
                      ),
                    ),
                    Text(
                      compact
                          ? profissional.especialidade
                          : '${profissional.especialidade} · ${profissional.distanciaKm.toStringAsFixed(1)} km',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textoSecundario,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.star_rounded,
                      color: AppColors.amareloSolidario, size: 16),
                  const SizedBox(width: 2),
                  Text(
                    profissional.avaliacao.toStringAsFixed(1),
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          if (!compact) ...[
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (profissional.isNgoVerified) _buildBadge(
                  label: 'Selo ONG verificado',
                  background: AppColors.azulFundo,
                  foreground: AppColors.azulClaro,
                ) else if (profissional.isVolunteerService) _buildBadge(
                  label: 'Serviço solidário',
                  background: AppColors.amareloFundo,
                  foreground: AppColors.amareloEscuro,
                ) else const SizedBox.shrink(),
                ElevatedButton(
                  onPressed: onRequest,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  child: const Text('Solicitar'),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBadge({
    required String label,
    required Color background,
    required Color foreground,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: foreground,
        ),
      ),
    );
  }
}
