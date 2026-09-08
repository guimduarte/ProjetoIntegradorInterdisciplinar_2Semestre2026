import 'package:flutter/material.dart';
import '../../models/instituicao.dart';
import '../../models/operario.dart';
import '../../theme/tema_do_app.dart';
import '../../widgets/titulo_secao.dart';

class _Review {
  final String autor;
  final int estrelas;
  final String comentario;
  const _Review(this.autor, this.estrelas, this.comentario);
}

const List<_Review> _reviewsOperario = [
  _Review('Creche Sementinha do Bem', 5, 'Muito pontual e cuidadoso com os detalhes, recomendamos!'),
  _Review('Projeto Educar Mais', 5, 'Serviço rápido e de ótima qualidade.'),
  _Review('Cozinha Solidária Pão Nosso', 4, 'Bom trabalho, apenas atrasou um pouco o início.'),
];

const List<_Review> _reviewsInstituicao = [
  _Review('Carlos Alberto', 5, 'Instituição organizada, materiais prontos no dia combinado.'),
  _Review('João Ricardo', 4, 'Comunicação clara sobre o escopo do serviço.'),
];

/// Tela "Avaliar Serviços", presente no menu inferior de ambos os
/// perfis (ÉPICO 02 - US02.1): mostra a reputação recebida e permite
/// avaliar a outra ponta após a conclusão de um serviço.
class TelaAvaliacoes extends StatelessWidget {
  final bool ehInstituicao;

  const TelaAvaliacoes({super.key, required this.ehInstituicao});

  @override
  Widget build(BuildContext context) {
    final reviews = ehInstituicao ? _reviewsInstituicao : _reviewsOperario;
    final media = ehInstituicao ? 4.6 : mockOperarioAtual.avaliacaoMedia;
    final nomeExibicao = ehInstituicao ? mockInstituicaoAtual.nome : mockOperarioAtual.nome;

    return Scaffold(
      appBar: AppBar(
          title: const Text('Avaliar Serviços'),
          automaticallyImplyLeading: false, //desativar a seta de voltar da topbar
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
                Text(nomeExibicao,
                    style: const TextStyle(fontSize: 13, color: CoresApp.textoSecundario)),
                const SizedBox(height: 6),
                Text(
                  media.toStringAsFixed(1),
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: CoresApp.textoPrimario),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (i) {
                    final filled = i < media.round();
                    return Icon(
                      filled ? Icons.star_rounded : Icons.star_border_rounded,
                      color: CoresApp.amareloSolidario,
                      size: 20,
                    );
                  }),
                ),
                const SizedBox(height: 4),
                Text('${reviews.length} avaliações recebidas',
                    style: const TextStyle(fontSize: 11, color: CoresApp.textoSecundario)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const TituloSecao(titulo: 'Avaliações recebidas'),
          const SizedBox(height: 10),
          ...reviews.map((r) => Padding(
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
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                          Row(
                            children: List.generate(
                              5,
                              (i) => Icon(
                                i < r.estrelas ? Icons.star_rounded : Icons.star_border_rounded,
                                size: 14,
                                color: CoresApp.amareloSolidario,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(r.comentario,
                          style: const TextStyle(fontSize: 12, color: CoresApp.textoSecundario, height: 1.4)),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
