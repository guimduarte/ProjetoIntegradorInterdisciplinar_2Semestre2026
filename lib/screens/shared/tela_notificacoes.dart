import 'package:flutter/material.dart';
import '../../theme/tema_do_app.dart';

class NotificacaoItem {
  final String id;
  final String titulo;
  final String mensagem;
  final String tempo;
  bool lida;

  NotificacaoItem({
    required this.id,
    required this.titulo,
    required this.mensagem,
    required this.tempo,
    this.lida = false,
  });
}

class TelaNotificacoes extends StatefulWidget {
  final bool ehInstituicao;

  const TelaNotificacoes({super.key, required this.ehInstituicao});

  @override
  State<TelaNotificacoes> createState() => _TelaNotificacoesState();
}

class _TelaNotificacoesState extends State<TelaNotificacoes> {
  List<NotificacaoItem> _notificacoes = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarNotificacoesAWS();
  }

  Future<void> _carregarNotificacoesAWS() async {
    setState(() => _carregando = true);
    try {
      // Busca das notificações reais vinculadas ao usuário logado na AWS
      setState(() {
        _notificacoes = [];
        _carregando = false;
      });
    } catch (e) {
      debugPrint('Erro ao carregar notificações: $e');
      setState(() => _carregando = false);
    }
  }

  void _marcarComoLida(NotificacaoItem n) {
    setState(() {
      n.lida = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificações'),
      ),
      body: _carregando
          ? const Center(
              child: CircularProgressIndicator(color: CoresApp.vermelhoAcao),
            )
          : RefreshIndicator(
              onRefresh: _carregarNotificacoesAWS,
              color: CoresApp.vermelhoAcao,
              child: _notificacoes.isEmpty
                  ? ListView(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: const Center(
                            child: Text(
                              'Nenhuma notificação por enquanto.',
                              style: TextStyle(
                                color: CoresApp.textoSecundario,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: _notificacoes.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final n = _notificacoes[index];
                        return InkWell(
                          onTap: () => _marcarComoLida(n),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: n.lida
                                  ? CoresApp.branco
                                  : CoresApp.azulFundo,
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
                                    n.lida
                                        ? Icons.notifications_none_rounded
                                        : Icons.notifications_active_rounded,
                                    size: 18,
                                    color: n.lida
                                        ? CoresApp.textoSecundario
                                        : CoresApp.vermelhoAcao,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        n.titulo,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        n.mensagem,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: CoresApp.textoSecundario,
                                          height: 1.3,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        n.tempo,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: CoresApp.textoSecundario,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}