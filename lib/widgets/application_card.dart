import 'package:flutter/material.dart';
import '../models/experience_level.dart';
import '../models/service_application.dart';
import '../theme/app_theme.dart';

/// Card exibido na central de chamados da instituição com a
/// visualização restrita do perfil do operário candidato: apenas
/// Nome, E-mail, Telefone, Escopo de Serviço e Nível de Experiência
/// (US03.2), com ações de Aceitar/Recusar.
class ApplicationCard extends StatelessWidget {
  final ServiceApplication application;
  final VoidCallback onAceitar;
  final VoidCallback onRecusar;

  const ApplicationCard({
    super.key,
    required this.application,
    required this.onAceitar,
    required this.onRecusar,
  });

  @override
  Widget build(BuildContext context) {
    final decidido = application.status != ApplicationStatus.pendente;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.branco,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borda),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            application.servicoTitulo,
            style: const TextStyle(fontSize: 11, color: AppColors.textoSecundario),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.azulFundo,
                child: Text(
                  application.operarioNome.substring(0, 1),
                  style: const TextStyle(
                    color: AppColors.azulClaro,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      application.operarioNome,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textoPrimario,
                      ),
                    ),
                    Text(
                      application.escopoPrincipal,
                      style: const TextStyle(fontSize: 11, color: AppColors.textoSecundario),
                    ),
                  ],
                ),
              ),
              if (decidido)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: application.status == ApplicationStatus.aceita
                        ? AppColors.verdeFundo
                        : AppColors.vermelhoFundo,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    application.status == ApplicationStatus.aceita ? 'Aceita' : 'Recusada',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: application.status == ApplicationStatus.aceita
                          ? AppColors.verdeEscuro
                          : AppColors.vermelhoEscuro,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          _linha(Icons.mail_outline_rounded, application.operarioEmail),
          const SizedBox(height: 4),
          _linha(Icons.call_outlined, application.operarioTelefone),
          const SizedBox(height: 4),
          _linha(Icons.workspace_premium_outlined, application.nivelExperiencia.label),
          if (!decidido) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onRecusar,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.vermelhoEscuro,
                      side: const BorderSide(color: AppColors.vermelhoEscuro),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: const Text('Recusar', style: TextStyle(fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onAceitar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.verdeSucesso,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: const Text('Aceitar', style: TextStyle(fontSize: 12)),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _linha(IconData icon, String texto) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textoSecundario),
        const SizedBox(width: 6),
        Text(texto, style: const TextStyle(fontSize: 12, color: AppColors.textoSecundario)),
      ],
    );
  }
}
