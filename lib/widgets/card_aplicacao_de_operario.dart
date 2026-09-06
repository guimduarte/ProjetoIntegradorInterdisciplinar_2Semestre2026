import 'package:flutter/material.dart';
import '../models/experience_level.dart';
import '../models/modelo_aplicacao_de_servico.dart';
import '../theme/app_theme.dart';

/// Card exibido na central de chamados da instituição com a
/// visualização restrita do perfil do operário candidato: apenas
/// Nome, E-mail, Telefone, Escopo de Serviço e Nível de Experiência
/// (US03.2), com ações de Aceitar/Recusar.
class CardAplicacaoDeOperario extends StatelessWidget {
  final AplicacaoDeServico candidatura;
  final VoidCallback onAceitar;
  final VoidCallback onRecusar;

  const CardAplicacaoDeOperario({
    super.key,
    required this.candidatura,
    required this.onAceitar,
    required this.onRecusar,
  });

  @override
  Widget build(BuildContext context) {
    final decidido = candidatura.status != StatusCandidatura.pendente;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: CoresApp.branco,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CoresApp.borda),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            candidatura.servicoTitulo,
            style: const TextStyle(fontSize: 11, color: CoresApp.textoSecundario),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: CoresApp.azulFundo,
                child: Text(
                  candidatura.operarioNome.substring(0, 1),
                  style: const TextStyle(
                    color: CoresApp.azulClaro,
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
                      candidatura.operarioNome,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: CoresApp.textoPrimario,
                      ),
                    ),
                    Text(
                      candidatura.escopoPrincipal,
                      style: const TextStyle(fontSize: 11, color: CoresApp.textoSecundario),
                    ),
                  ],
                ),
              ),
              if (decidido)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: candidatura.status == StatusCandidatura.aceita
                        ? CoresApp.verdeFundo
                        : CoresApp.vermelhoFundo,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    candidatura.status == StatusCandidatura.aceita ? 'Aceita' : 'Recusada',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: candidatura.status == StatusCandidatura.aceita
                          ? CoresApp.verdeEscuro
                          : CoresApp.vermelhoEscuro,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          _linha(Icons.mail_outline_rounded, candidatura.operarioEmail),
          const SizedBox(height: 4),
          _linha(Icons.call_outlined, candidatura.operarioTelefone),
          const SizedBox(height: 4),
          _linha(Icons.workspace_premium_outlined, candidatura.nivelExperiencia.texto),
          if (!decidido) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onRecusar,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: CoresApp.vermelhoEscuro,
                      side: const BorderSide(color: CoresApp.vermelhoEscuro),
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
                      backgroundColor: CoresApp.verdeSucesso,
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
        Icon(icon, size: 14, color: CoresApp.textoSecundario),
        const SizedBox(width: 6),
        Text(texto, style: const TextStyle(fontSize: 12, color: CoresApp.textoSecundario)),
      ],
    );
  }
}
