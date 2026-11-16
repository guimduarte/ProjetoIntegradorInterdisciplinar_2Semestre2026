import 'package:flutter/material.dart';
import '../../models/candidatura_de_servico.dart';
import '../../models/ordem_servico.dart';
import '../../services/gerenciador_sessao_usuario.dart';
import '../../theme/tema_do_app.dart';
import '../../widgets/selo_de_complexidade.dart';

/// Aba "Meus Serviços" do operário, separando chamados 'Aceitos'
/// (em andamento) de 'Realizados' (com horas gastas e pontos
/// angariados) — US05.2.
class OperarioTelaServicos extends StatefulWidget {
  const OperarioTelaServicos({super.key});

  @override
  State<OperarioTelaServicos> createState() => _OperarioTelaServicosState();
}

class _OperarioTelaServicosState extends State<OperarioTelaServicos> {
  List<OrdemServico> _servicosAceitos = [];
  List<OrdemServico> _servicosRealizados = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarServicos();
  }

  /// Busca as candidaturas do operário logado na AWS para popular as abas 'Aceitos' e 'Realizados'
  Future<void> _carregarServicos() async {
    setState(() => _carregando = true);

    final operario = GerenciadorSessaoUsuario.instancia.operarioAtual;
    final idOperario =
        operario.email.isNotEmpty ? operario.email : operario.nome;

    final candidaturas =
        await CandidaturaDeServico.buscarCandidaturasDoOperarioAWS(idOperario);

    final List<OrdemServico> aceitos = [];
    final List<OrdemServico> realizados = [];

    for (final c in candidaturas) {
      OrdemServico ordemBase;
      if (c.awsService != null) {
        ordemBase = OrdemServico.fromAWS(c.awsService!);
      } else {
        ordemBase = OrdemServico(
          id: c.servicoId,
          titulo: c.servicoTitulo,
          descricao: c.escopoPrincipal,
          escopo: EscopoServico.manutencaoBasica,
          instituicaoNome: 'Instituição Solidária',
          instituicaoLocalizacao: 'São Paulo, SP',
          horasEstimadas: 4.0,
          status: c.status == StatusCandidatura.concluida
              ? StatusServico.concluido
              : StatusServico.aceito,
        );
      }

      // Calcula pontos reais e horas com base na complexidade calculada pela AWS
      final horas = ordemBase.horasEstimadas;
      final pontosCalculados =
          (horas * ordemBase.complexidade.pontosPorHora).round();

      final ordemAtualizada = OrdemServico(
        id: ordemBase.id,
        titulo: ordemBase.titulo,
        descricao: ordemBase.descricao,
        escopo: ordemBase.escopo,
        marcadoComoAvancado: ordemBase.marcadoComoAvancado,
        instituicaoNome: ordemBase.instituicaoNome,
        instituicaoLocalizacao: ordemBase.instituicaoLocalizacao,
        latitude: ordemBase.latitude,
        longitude: ordemBase.longitude,
        distanciaKm: ordemBase.distanciaKm,
        horasEstimadas: horas,
        horasRealizadas: horas,
        pontosGanhos: pontosCalculados,
        status: c.status == StatusCandidatura.concluida
            ? StatusServico.concluido
            : StatusServico.aceito,
        awsService: ordemBase.awsService,
      );

      if (c.status == StatusCandidatura.aceita) {
        aceitos.add(ordemAtualizada);
      } else if (c.status == StatusCandidatura.concluida) {
        realizados.add(ordemAtualizada);
      }
    }

    if (!mounted) return;

    setState(() {
      _servicosAceitos = aceitos;
      _servicosRealizados = realizados;
      _carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Meus Serviços'),
          automaticallyImplyLeading: false,
          bottom: const TabBar(
            tabs: [Tab(text: 'Aceitos'), Tab(text: 'Realizados')],
          ),
        ),
        body: _carregando
            ? const Center(
                child: CircularProgressIndicator(color: CoresApp.vermelhoAcao),
              )
            : TabBarView(
                children: [
                  RefreshIndicator(
                    onRefresh: _carregarServicos,
                    color: CoresApp.vermelhoAcao,
                    child: _ListaDeServicos(
                      servicos: _servicosAceitos,
                      showResultado: false,
                    ),
                  ),
                  RefreshIndicator(
                    onRefresh: _carregarServicos,
                    color: CoresApp.vermelhoAcao,
                    child: _ListaDeServicos(
                      servicos: _servicosRealizados,
                      showResultado: true,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _ListaDeServicos extends StatelessWidget {
  final List<OrdemServico> servicos;
  final bool showResultado;

  const _ListaDeServicos({
    required this.servicos,
    required this.showResultado,
  });

  @override
  Widget build(BuildContext context) {
    if (servicos.isEmpty) {
      return ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Center(
              child: Text(
                showResultado
                    ? 'Nenhum serviço realizado ainda.'
                    : 'Nenhum serviço em andamento.',
                style: const TextStyle(
                  color: CoresApp.textoSecundario,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: servicos.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final s = servicos[index];
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
              Row(
                children: [
                  Expanded(
                    child: Text(
                      s.titulo,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SeloDeComplexidade(complexidade: s.complexidade),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                s.instituicaoNome,
                style: const TextStyle(
                  fontSize: 11,
                  color: CoresApp.textoSecundario,
                ),
              ),
              const SizedBox(height: 10),
              if (showResultado) ...[
                Row(
                  children: [
                    _textinhoStatus(
                      Icons.schedule_rounded,
                      '${s.horasRealizadas?.toStringAsFixed(1) ?? '-'} h trabalhadas',
                    ),
                    const SizedBox(width: 8),
                    _textinhoStatus(
                      Icons.toll_rounded,
                      '+${s.pontosGanhos ?? 0} pts',
                      cor: CoresApp.amareloEscuro,
                    ),
                  ],
                ),
              ] else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: CoresApp.amareloFundo,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Em andamento',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: CoresApp.amareloEscuro,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _textinhoStatus(IconData icone, String texto, {Color? cor}) {
    final c = cor ?? CoresApp.textoSecundario;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: CoresApp.fundoTela,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icone, size: 12, color: c),
          const SizedBox(width: 3),
          Text(
            texto,
            style: TextStyle(
              fontSize: 11,
              color: c,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
