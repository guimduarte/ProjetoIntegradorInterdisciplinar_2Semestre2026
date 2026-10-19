import 'package:flutter/material.dart';
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

  /// Busca os serviços na AWS e filtra pelos status 'aceito' e 'concluido'
  Future<void> _carregarServicos() async {
    setState(() => _carregando = true);

    final operario = GerenciadorSessaoUsuario.instancia.operarioAtual;

    final todosServicos = await OrdemServico.buscarServicosAWS(
      latitudeOperario: operario.latitude,
      longitudeOperario: operario.longitude,
    );

    setState(() {
      _servicosAceitos = todosServicos
          .where((s) => s.status == StatusServico.aceito)
          .toList();

      _servicosRealizados = todosServicos
          .where((s) => s.status == StatusServico.concluido)
          .toList();

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
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _avaliarServico(context, s),
                    icon: const Icon(Icons.star_border_rounded, size: 16),
                    label: const Text(
                      'Avaliar instituição',
                      style: TextStyle(fontSize: 12),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: CoresApp.amareloEscuro,
                      side: const BorderSide(color: CoresApp.amareloSolidario),
                    ),
                  ),
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

  void _avaliarServico(BuildContext context, OrdemServico s) {
    int estrelas = 5;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Avaliar ${s.instituicaoNome}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  final filled = i < estrelas;
                  return IconButton(
                    onPressed: () => setModalState(() => estrelas = i + 1),
                    icon: Icon(
                      filled ? Icons.star_rounded : Icons.star_border_rounded,
                      color: CoresApp.amareloSolidario,
                      size: 32,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Avaliação enviada. Obrigado!'),
                      ),
                    );
                  },
                  child: const Text('Enviar avaliação'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}