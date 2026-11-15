import 'package:flutter/material.dart';
import '../models/profissional.dart';
import '../theme/tema_do_app.dart';
import '../widgets/card_profissional.dart';

/// Tela que lista os profissionais/serviços disponíveis na AWS, com
/// filtro por categoria e opção de solicitar atendimento.
class TelaServicosDisponiveis extends StatefulWidget {
  final String categoriaInicial;

  const TelaServicosDisponiveis({super.key, this.categoriaInicial = 'Todos'});

  @override
  State<TelaServicosDisponiveis> createState() =>
      _TelaServicosDisponiveisState();
}

class _TelaServicosDisponiveisState extends State<TelaServicosDisponiveis> {
  static const List<String> _categorias = [
    'Todos',
    'Pedreiro',
    'Carpinteiro',
    'Pintor',
    'Eletricista',
  ];

  late String _categoriaSelecionada = widget.categoriaInicial;
  String _termoBusca = '';
  final TextEditingController _buscaController = TextEditingController();

  List<Profissional> _profissionaisAWS = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarProfissionaisAWS();
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  Future<void> _carregarProfissionaisAWS() async {
    setState(() => _carregando = true);
    final lista = await Profissional.buscarProfissionaisAWS();
    if (!mounted) return;
    setState(() {
      _profissionaisAWS = lista;
      _carregando = false;
    });
  }

  List<Profissional> get _profissionaisFiltrados {
    return _profissionaisAWS.where((p) {
      final atendeCategoria = _categoriaSelecionada == 'Todos' ||
          p.especialidade.toLowerCase().contains(
                _categoriaSelecionada.toLowerCase().substring(
                      0,
                      _categoriaSelecionada.length > 5
                          ? 5
                          : _categoriaSelecionada.length,
                    ),
              );

      final atendeBusca = _termoBusca.isEmpty ||
          p.nome.toLowerCase().contains(_termoBusca.toLowerCase()) ||
          p.especialidade.toLowerCase().contains(_termoBusca.toLowerCase());

      return atendeCategoria && atendeBusca;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Serviços disponíveis'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: TextField(
              controller: _buscaController,
              onChanged: (v) => setState(() => _termoBusca = v),
              decoration: InputDecoration(
                hintText: 'Filtrar por especialidade ou nome',
                prefixIcon:
                    const Icon(Icons.search, color: CoresApp.textoSecundario),
                suffixIcon: _termoBusca.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _buscaController.clear();
                          setState(() => _termoBusca = '');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              itemCount: _categorias.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final categoria = _categorias[index];
                final selecionado = categoria == _categoriaSelecionada;
                return ChoiceChip(
                  label: Text(categoria),
                  selected: selecionado,
                  onSelected: (_) =>
                      setState(() => _categoriaSelecionada = categoria),
                  selectedColor: CoresApp.vermelhoAcao,
                  backgroundColor: CoresApp.branco,
                  labelStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color:
                        selecionado ? CoresApp.branco : CoresApp.azulConfianca,
                  ),
                  shape: StadiumBorder(
                    side: BorderSide(
                      color: selecionado
                          ? CoresApp.vermelhoAcao
                          : CoresApp.azulConfianca,
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: _carregando
                ? const Center(
                    child: CircularProgressIndicator(
                        color: CoresApp.vermelhoAcao),
                  )
                : RefreshIndicator(
                    onRefresh: _carregarProfissionaisAWS,
                    color: CoresApp.vermelhoAcao,
                    child: _profissionaisFiltrados.isEmpty
                        ? ListView(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                child: const Center(
                                  child: Text(
                                    'Nenhum profissional cadastrado para esta categoria.',
                                    style: TextStyle(
                                      color: CoresApp.textoSecundario,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                            itemCount: _profissionaisFiltrados.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final profissional =
                                  _profissionaisFiltrados[index];
                              return CardProfissional(
                                profissional: profissional,
                                onRequest: () => _showRequestConfirmation(
                                    context, profissional),
                              );
                            },
                          ),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) Navigator.of(context).pop();
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.handyman_outlined),
            label: 'Serviços',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_rounded),
            label: 'Pedidos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }

  void _showRequestConfirmation(
      BuildContext context, Profissional professional) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Solicitar ${professional.especialidade.toLowerCase()}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              'Sua entidade será conectada com ${professional.nome}. '
              'Confirme para enviar os detalhes da obra.',
              style:
                  const TextStyle(color: CoresApp.textoSecundario, fontSize: 13),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Confirmar solicitação'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
