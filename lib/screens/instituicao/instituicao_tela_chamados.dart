import 'package:flutter/material.dart';
import '../../models/candidatura_de_servico.dart';
import '../../theme/tema_do_app.dart';
import '../../widgets/card_candidatura_de_operario.dart';

/// Central de chamados da instituição (ÉPICO 03 - US03.2): lista as
/// candidaturas recebidas com a visualização restrita do perfil do
/// operário e as ações de aceitar/recusar.
class InstituicaoTelaChamados extends StatefulWidget {
  const InstituicaoTelaChamados({super.key});

  @override
  State<InstituicaoTelaChamados> createState() => _InstituicaoTelaChamadosState();
}

class _InstituicaoTelaChamadosState extends State<InstituicaoTelaChamados> {
  final List<CandidaturaDeServico> _applications = mockCandidaturas;

  @override
  Widget build(BuildContext context) {
    final pendentes = _applications.where((a) => a.status == StatusCandidatura.pendente).toList();
    final decididas = _applications.where((a) => a.status != StatusCandidatura.pendente).toList();

    return Scaffold(
      appBar: AppBar(
          title: const Text('Central de Chamados'),
          automaticallyImplyLeading: false
      ),
      body: _applications.isEmpty
          ? const Center(
              child: Text('Nenhuma candidatura recebida ainda.',
                  style: TextStyle(color: CoresApp.textoSecundario, fontSize: 13)),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (pendentes.isNotEmpty) ...[
                  Text('Pendentes (${pendentes.length})',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  ...pendentes.map((a) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: CardCandidaturaDeOperario(
                          candidatura: a,
                          onAceitar: () => _decidir(a, StatusCandidatura.aceita),
                          onRecusar: () => _decidir(a, StatusCandidatura.recusada),
                        ),
                      )),
                ],
                if (decididas.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  const Text('Já decididas',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  ...decididas.map((a) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: CardCandidaturaDeOperario(
                          candidatura: a,
                          onAceitar: () {},
                          onRecusar: () {},
                        ),
                      )),
                ],
              ],
            ),
    );
  }

  void _decidir(CandidaturaDeServico a, StatusCandidatura status) {
    setState(() => a.status = status);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          status == StatusCandidatura.aceita
              ? '${a.operarioNome} foi aceito para o serviço.'
              : 'Candidatura de ${a.operarioNome} recusada.',
        ),
      ),
    );
  }
}
