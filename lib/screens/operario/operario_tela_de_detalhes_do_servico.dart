import 'package:flutter/material.dart';
import '../../models/candidatura_de_servico.dart';
import '../../models/nivel_experiencia.dart';
import '../../models/ordem_servico.dart';
import '../../services/gerenciador_sessao_usuario.dart';
import '../../theme/tema_do_app.dart';
import '../../widgets/selo_de_complexidade.dart';

class OperarioTelaDeDetalhesDoServico extends StatefulWidget {
  final OrdemServico servico;

  const OperarioTelaDeDetalhesDoServico({super.key, required this.servico});

  @override
  State<OperarioTelaDeDetalhesDoServico> createState() =>
      _OperarioTelaDeDetalhesDoServicoState();
}

class _OperarioTelaDeDetalhesDoServicoState
    extends State<OperarioTelaDeDetalhesDoServico> {
  bool _candidatado = false;
  bool _enviando = false;

  Future<void> _candidatar(BuildContext context) async {
    setState(() => _enviando = true);

    final operario = GerenciadorSessaoUsuario.instancia.operarioAtual;

    final sucesso = await CandidaturaDeServico.criarCandidaturaAWS(
      servicoId: widget.servico.id,
      servicoTitulo: widget.servico.titulo,
      operarioId: operario.nome, // ou ID do usuario Cognito
      operarioNome: operario.nome,
      operarioEmail: operario.email,
      operarioTelefone: operario.telefone,
      escopoPrincipal: widget.servico.escopo.texto,
      nivelExperiencia: operario.nivelExperiencia,
    );

    setState(() => _enviando = false);

    if (sucesso) {
      setState(() => _candidatado = true);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Candidatura enviada para ${widget.servico.instituicaoNome}. Você será notificado sobre a decisão.',
            ),
          ),
        );
        // Retorna 'true' para atualizar a tela anterior
        Navigator.pop(context, true);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao enviar candidatura. Tente novamente.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.servico;
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do serviço')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: CoresApp.azulFundo,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(s.escopo.icone, color: CoresApp.azulClaro, size: 28),
            ),
            const SizedBox(height: 14),
            Text(
              s.titulo,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: CoresApp.textoPrimario,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              s.instituicaoNome,
              style: const TextStyle(
                fontSize: 13,
                color: CoresApp.textoSecundario,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                SeloDeComplexidade(
                  complexidade: s.complexidade,
                  showPoints: true,
                ),
                _tagIndicador(
                  Icons.place_outlined,
                  '${s.distanciaKm.toStringAsFixed(1)} km · ${s.instituicaoLocalizacao}',
                ),
                _tagIndicador(
                  Icons.schedule_rounded,
                  '~${s.horasEstimadas.toStringAsFixed(0)} horas estimadas',
                ),
                _tagIndicador(
                  Icons.groups_outlined,
                  '${s.candidatos} candidato(s)',
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Descrição',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              s.descricao,
              style: const TextStyle(
                fontSize: 13,
                color: CoresApp.textoSecundario,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Requisito de experiência',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              s.complexidade.nivelMinimoExigido.descricao,
              style: const TextStyle(
                fontSize: 13,
                color: CoresApp.textoSecundario,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (_candidatado || _enviando)
                    ? null
                    : () => _candidatar(context),
                style: ElevatedButton.styleFrom(
                  disabledBackgroundColor: CoresApp.verdeSucesso,
                  disabledForegroundColor: CoresApp.branco,
                ),
                child: _enviando
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        _candidatado
                            ? 'Candidatura enviada ✓'
                            : 'Candidatar-se a este serviço',
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tagIndicador(IconData icon, String texto) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: CoresApp.fundoTela,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: CoresApp.borda),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: CoresApp.textoSecundario),
          const SizedBox(width: 4),
          Text(
            texto,
            style: const TextStyle(
              fontSize: 11,
              color: CoresApp.textoSecundario,
            ),
          ),
        ],
      ),
    );
  }
}