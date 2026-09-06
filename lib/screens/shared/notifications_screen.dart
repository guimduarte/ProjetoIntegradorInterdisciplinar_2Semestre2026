import 'package:flutter/material.dart';
import '../../models/modelo_aplicacao_de_servico.dart';
import '../../theme/app_theme.dart';

/// Tela "Notificações", presente no menu inferior de ambos os
/// perfis (ÉPICO 02 - US02.1). Exibe alertas de novos serviços no
/// raio (US04.1), decisões de candidatura e créditos de pontos.
class TelaNotificacoes extends StatelessWidget {
  final bool ehInstituicao;

  const TelaNotificacoes({super.key, required this.ehInstituicao});

  @override
  Widget build(BuildContext context) {
    final notificacoes = ehInstituicao ? mockNotificacoesInstituicao : mockNotificacoesOperario;
    return Scaffold(
      appBar: AppBar(title: const Text('Notificações')),
      body: notificacoes.isEmpty
          ? const Center(
              child: Text('Nenhuma notificação por enquanto.',
                  style: TextStyle(color: CoresApp.textoSecundario, fontSize: 13)),
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
                    color: n.lida ? CoresApp.branco : CoresApp.azulFundo,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: CoresApp.borda),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: CoresApp.branco,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          n.lida ? Icons.notifications_none_rounded : Icons.notifications_active_rounded,
                          size: 18,
                          color: n.lida ? CoresApp.textoSecundario : CoresApp.vermelhoAcao,
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
                                style: const TextStyle(fontSize: 12, color: CoresApp.textoSecundario, height: 1.3)),
                            const SizedBox(height: 6),
                            Text(n.tempo,
                                style: const TextStyle(fontSize: 10, color: CoresApp.textoSecundario)),
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
