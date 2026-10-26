import 'package:flutter/material.dart';
import '../models/nivel_experiencia.dart';
import '../models/candidatura_de_servico.dart';
import '../theme/tema_do_app.dart';

class CardCandidaturaDeOperario extends StatelessWidget {
  final CandidaturaDeServico candidatura;
  final VoidCallback onAceitar;
  final VoidCallback onRecusar;
  final VoidCallback? onIniciarServico;
  final VoidCallback? onCancelar;

  const CardCandidaturaDeOperario({
    super.key,
    required this.candidatura,
    required this.onAceitar,
    required this.onRecusar,
    this.onIniciarServico,
    this.onCancelar,
  });

  @override
  Widget build(BuildContext context) {
    final bool pendente = candidatura.status == StatusCandidatura.pendente;
    final bool aceito = candidatura.status == StatusCandidatura.aceita;

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
                  candidatura.operarioNome.isNotEmpty
                      ? candidatura.operarioNome.substring(0, 1)
                      : 'O',
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
              if (!pendente)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: aceito ? CoresApp.verdeFundo : CoresApp.vermelhoFundo,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    aceito ? 'Aceita' : 'Recusada',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: aceito ? CoresApp.verdeEscuro : CoresApp.vermelhoEscuro,
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
          
          // Ações para Candidatura Pendente
          if (pendente) ...[
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

          // Ações para Candidatura Aceita (Iniciar / Cancelar)
          if (aceito) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: onCancelar,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: CoresApp.vermelhoEscuro,
                    side: const BorderSide(color: CoresApp.vermelhoEscuro),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  child: const Text('Cancelar', style: TextStyle(fontSize: 12)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: onIniciarServico,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CoresApp.verdeSucesso,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  child: const Text('Iniciar serviço', style: TextStyle(fontSize: 12, color: Colors.white)),
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