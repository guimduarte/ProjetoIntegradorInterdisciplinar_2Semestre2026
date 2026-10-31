import 'package:flutter/material.dart';
import '../../models/candidatura_de_servico.dart';
import '../../models/ordem_servico.dart';
import '../../services/gerenciador_sessao_usuario.dart';
import '../../theme/tema_do_app.dart';
import '../../widgets/card_candidatura_de_operario.dart';
import 'modal_controle_chamado.dart';

class InstituicaoTelaChamados extends StatefulWidget {
  const InstituicaoTelaChamados({super.key});

  @override
  State<InstituicaoTelaChamados> createState() => _InstituicaoTelaChamadosState();
}

class _InstituicaoTelaChamadosState extends State<InstituicaoTelaChamados> {
  List<CandidaturaDeServico> _applications = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarCandidaturas();
  }

  Future<void> _carregarCandidaturas() async {
    setState(() => _carregando = true);

    final instituicao = GerenciadorSessaoUsuario.instancia.instituicaoAtual;

    final lista = await CandidaturaDeServico.buscarCandidaturasAWS(
      instituicaoId: instituicao.nome,
    );

    setState(() {
      _applications = lista;
      _carregando = false;
    });
  }

  Future<void> _decidir(CandidaturaDeServico a, StatusCandidatura status) async {
    final sucesso = await CandidaturaDeServico.atualizarStatusAWS(
      candidatura: a,
      novoStatus: status,
    );

    if (sucesso) {
      setState(() => a.status = status);
      if (mounted) {
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
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao registrar decisão na AWS.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final pendentes = _applications.where((a) => a.status == StatusCandidatura.pendente).toList();
    final aceitas = _applications.where((a) => a.status == StatusCandidatura.aceita).toList();
    final recusadas = _applications.where((a) => a.status == StatusCandidatura.recusada).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Central de Chamados'),
        automaticallyImplyLeading: false,
      ),
      body: _carregando
          ? const Center(
              child: CircularProgressIndicator(color: CoresApp.vermelhoAcao),
            )
          : RefreshIndicator(
              onRefresh: _carregarCandidaturas,
              color: CoresApp.vermelhoAcao,
              child: _applications.isEmpty
                  ? ListView(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: const Center(
                            child: Text(
                              'Nenhuma candidatura recebida ainda.',
                              style: TextStyle(color: CoresApp.textoSecundario, fontSize: 13),
                            ),
                          ),
                        ),
                      ],
                    )
                  : ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        if (pendentes.isNotEmpty) ...[
                          Text(
                            'Pendentes (${pendentes.length})',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                          ),
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
                        if (aceitas.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Text(
                            'Em Andamento / Aceitas (${aceitas.length})',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 10),
                          ...aceitas.map((a) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: CardCandidaturaDeOperario(
                                  candidatura: a,
                                  onAceitar: () {},
                                  onRecusar: () {},
                                  onCancelar: () => _decidir(a, StatusCandidatura.recusada),
                                  onIniciarServico: () {
                                    ModalControleChamado.exibir(
                                      context,
                                      candidatura: a,
                                      horasEstimadas: 4.0,
                                      onEncerrar: (horas, pontos) async {
                                        // Atualiza o status do serviço na AWS automaticamente para 'Concluído'
                                        await OrdemServico.atualizarStatusServicoAWS(
                                          servicoId: a.servicoId,
                                          novoStatus: StatusServico.concluido,
                                        );
                                        _carregarCandidaturas();
                                      },
                                    );
                                  },
                                ),
                              )),
                        ],
                        if (recusadas.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Text(
                            'Recusadas (${recusadas.length})',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 10),
                          ...recusadas.map((a) => Padding(
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
            ),
    );
  }
}