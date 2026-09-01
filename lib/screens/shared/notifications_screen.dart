import 'package:flutter/material.dart';
import '../../models/service_application.dart';
import '../../theme/app_theme.dart';

/// Tela "Notificações", presente no menu inferior de ambos os
/// perfis (ÉPICO 02 - US02.1). Exibe alertas de novos serviços no
/// raio (US04.1), decisões de candidatura e créditos de pontos.
class NotificationsScreen extends StatelessWidget {
  final bool isInstituicao;

  const NotificationsScreen({super.key, required this.isInstituicao});

  @override
  Widget build(BuildContext context) {
    final notificacoes = isInstituicao ? mockNotificacoesInstituicao : mockNotificacoesOperario;
    return Scaffold(
      appBar: AppBar(title: const Text('Notificações')),
      body: notificacoes.isEmpty
          ? const Center(
              child: Text('Nenhuma notificação por enquanto.',
                  style: TextStyle(color: AppColors.textoSecundario, fontSize: 13)),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: notificacoes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final n = notificacoes[index];
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: n.lida ? AppColors.branco : AppColors.azulFundo,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borda),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: AppColors.branco,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          n.lida ? Icons.notifications_none_rounded : Icons.notifications_active_rounded,
                          size: 18,
                          color: n.lida ? AppColors.textoSecundario : AppColors.vermelhoAcao,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(n.titulo,
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 3),
                            Text(n.mensagem,
                                style: const TextStyle(fontSize: 12, color: AppColors.textoSecundario, height: 1.3)),
                            const SizedBox(height: 6),
                            Text(n.tempo,
                                style: const TextStyle(fontSize: 10, color: AppColors.textoSecundario)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
