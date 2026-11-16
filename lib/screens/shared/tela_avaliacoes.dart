import 'package:flutter/material.dart';
import '../../services/gerenciador_sessao_usuario.dart';
import '../../services/servico_avaliacoes.dart';
import '../../theme/tema_do_app.dart';
import '../../widgets/titulo_secao.dart';

/// Tela "Avaliar Serviços", presente no menu inferior de ambos os
/// perfis (ÉPICO 02 - US02.1): mostra a reputação recebida e permite
/// visualizar as avaliações reais atribuídas na plataforma.
class TelaAvaliacoes extends StatelessWidget {
  final bool ehInstituicao;

  const TelaAvaliacoes({super.key, required this.ehInstituicao});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ServicoAvaliacoes.instancia,
      builder: (context, _) {
        final emailOperario =
            GerenciadorSessaoUsuario.instancia.operarioAtual.email;

        final List<AvaliacaoItem> reviews = ehInstituicao
            ? const []
            : ServicoAvaliacoes.instancia
                .obterAvaliacoesDoOperario(emailOperario);

        final nomeExibicao = ehInstituicao
            ? GerenciadorSessaoUsuario.instancia.instituicaoAtual.nome
            : GerenciadorSessaoUsuario.instancia.operarioAtual.nome;

        final double media = ehInstituicao
            ? 5.0
            : ServicoAvaliacoes.instancia
                .calcularMediaOperario(emailOperario);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Avaliar Serviços'),
            automaticallyImplyLeading: false,
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: CoresApp.branco,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: CoresApp.borda),
                ),
                child: Column(
                  children: [
                    Text(
                      nomeExibicao,
                      style: const TextStyle(
                          fontSize: 13, color: CoresApp.textoSecundario),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      media.toStringAsFixed(1),
                      style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: CoresApp.textoPrimario),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (i) {
                        final filled = i < media.round();
                        return Icon(
                          filled
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          color: CoresApp.amareloSolidario,
                          size: 20,
                        );
                      }),
                    ),
                    const SizedBox(height: 4),
                    Text('${reviews.length} avaliações recebidas',
                        style: const TextStyle(
                            fontSize: 11, color: CoresApp.textoSecundario)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const TituloSecao(titulo: 'Avaliações recebidas'),
              const SizedBox(height: 10),
              if (reviews.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: CoresApp.fundoTela,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: CoresApp.borda),
                  ),
                  child: const Text(
                    'Nenhuma avaliação recebida ainda.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: CoresApp.textoSecundario,
                    ),
                  ),
                )
              else
                ...reviews.map(
                  (r) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: CoresApp.branco,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: CoresApp.borda),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(r.autor,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700)),
                              Row(
                                children: List.generate(
                                  5,
                                  (i) => Icon(
                                    i < r.estrelas
                                        ? Icons.star_rounded
                                        : Icons.star_border_rounded,
                                    size: 14,
                                    color: CoresApp.amareloSolidario,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (r.comentario.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text(
                              r.comentario,
                              style: const TextStyle(
                                fontSize: 12,
                                color: CoresApp.textoSecundario,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
