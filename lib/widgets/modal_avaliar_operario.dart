import 'package:flutter/material.dart';
import '../models/candidatura_de_servico.dart';
import '../services/gerenciador_sessao_usuario.dart';
import '../services/servico_avaliacoes.dart';
import '../theme/tema_do_app.dart';

/// Modal para a Instituição atribuir estrelas e registrar comentário
/// de avaliação sobre o serviço concluído pelo Operário.
class ModalAvaliarOperario extends StatefulWidget {
  final CandidaturaDeServico candidatura;

  const ModalAvaliarOperario({super.key, required this.candidatura});

  static Future<void> exibir(
    BuildContext context, {
    required CandidaturaDeServico candidatura,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => ModalAvaliarOperario(candidatura: candidatura),
    );
  }

  @override
  State<ModalAvaliarOperario> createState() => _ModalAvaliarOperarioState();
}

class _ModalAvaliarOperarioState extends State<ModalAvaliarOperario> {
  int _estrelas = 5;
  final _comentarioController = TextEditingController();
  bool _enviando = false;

  @override
  void dispose() {
    _comentarioController.dispose();
    super.dispose();
  }

  Future<void> _enviarAvaliacao() async {
    setState(() => _enviando = true);

    final instituicao = GerenciadorSessaoUsuario.instancia.instituicaoAtual;
    final c = widget.candidatura;

    final sucesso = await ServicoAvaliacoes.instancia.salvarAvaliacaoOperario(
      operarioEmail: c.operarioEmail,
      instituicaoNome: instituicao.nome,
      estrelas: _estrelas,
      comentario: _comentarioController.text.trim(),
    );

    if (!mounted) return;
    setState(() => _enviando = false);

    if (sucesso) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Avaliação enviada para ${c.operarioNome}. Obrigado!'),
          backgroundColor: CoresApp.verdeSucesso,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao enviar avaliação. Tente novamente.'),
          backgroundColor: CoresApp.vermelhoEscuro,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.candidatura;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Avaliar ${c.operarioNome}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: CoresApp.textoPrimario,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 20),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Serviço: ${c.servicoTitulo}',
            style: const TextStyle(fontSize: 12, color: CoresApp.textoSecundario),
          ),
          const SizedBox(height: 16),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) {
                final filled = i < _estrelas;
                return IconButton(
                  onPressed: () => setState(() => _estrelas = i + 1),
                  icon: Icon(
                    filled ? Icons.star_rounded : Icons.star_border_rounded,
                    color: CoresApp.amareloSolidario,
                    size: 36,
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _comentarioController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Comentário sobre a execução (opcional)',
              hintText: 'Ex: Excelente profissional, muito cuidadoso e pontual.',
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _enviando ? null : _enviarAvaliacao,
              child: _enviando
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: CoresApp.branco,
                      ),
                    )
                  : const Text('Enviar avaliação'),
            ),
          ),
        ],
      ),
    );
  }
}
