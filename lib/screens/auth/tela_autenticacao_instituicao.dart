import 'package:flutter/material.dart';
import '../../models/instituicao.dart';
import '../../theme/app_theme.dart';
import '../../widgets/step_progress_bar.dart';
import '../instituicao/instituicao_tela.dart';

/// Tela de autenticação do usuário 'Instituição' (ÉPICO 01 - US01.3):
/// login simples ou cadastro completo em duas etapas (dados
/// institucionais e classificação institucional com campos
/// dinâmicos). Interface apenas — sem chamadas a backend.
class TelaAutenticacaoInstituicao extends StatefulWidget {
  const TelaAutenticacaoInstituicao({super.key});

  @override
  State<TelaAutenticacaoInstituicao> createState() => _TelaAutenticacaoInstituicaoState();
}

class _TelaAutenticacaoInstituicaoState extends State<TelaAutenticacaoInstituicao>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController =
      TabController(length: 2, vsync: this);

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sou Instituição'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Entrar'), Tab(text: 'Cadastrar')],
          labelColor: CoresApp.branco,
          unselectedLabelColor: Color(0xFFB9C3D6),
          indicatorColor: CoresApp.branco,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _InstituicaoLoginForm(),
          _InstituicaoCadastroForm(),
        ],
      ),
    );
  }
}

class _InstituicaoLoginForm extends StatelessWidget {
  const _InstituicaoLoginForm();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          const Text('Bem-vindo de volta!',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          const Text(
            'Entre com os dados da instituição para publicar e gerenciar serviços.',
            style: TextStyle(fontSize: 12, color: CoresApp.textoSecundario),
          ),
          const SizedBox(height: 20),
          const TextField(
            decoration:
                InputDecoration(labelText: 'E-mail institucional', hintText: 'contato@ong.org'),
          ),
          const SizedBox(height: 12),
          const TextField(
            obscureText: true,
            decoration: InputDecoration(labelText: 'Senha'),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const InstituicaoTela()),
              ),
              child: const Text('Entrar'),
            ),
          ),
        ],
      ),
    );
  }
}

class _InstituicaoCadastroForm extends StatefulWidget {
  const _InstituicaoCadastroForm();

  @override
  State<_InstituicaoCadastroForm> createState() => _InstituicaoCadastroFormState();
}

class _InstituicaoCadastroFormState extends State<_InstituicaoCadastroForm> {
  int _step = 0;

  // Parte 1 — Dados institucionais
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _cnpjController = TextEditingController();
  final _localizacaoController = TextEditingController();

  // Parte 2 — Classificação institucional
  final Set<TipoInstituicao> _tiposSelecionados = {};
  final Map<TipoInstituicao, TextEditingController> _camposAdicionais = {
    for (final t in TipoInstituicao.values) t: TextEditingController(),
  };

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _cnpjController.dispose();
    _localizacaoController.dispose();
    for (final c in _camposAdicionais.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
          child: BarraProgressoEtapas(
            etapaAtual: _step,
            rotulosEtapas: const ['Dados institucionais', 'Classificação'],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
            child: _step == 0 ? _buildStepUm() : _buildStepDois(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Row(
            children: [
              if (_step == 1)
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(() => _step = 0),
                    child: const Text('Voltar'),
                  ),
                ),
              if (_step == 1) const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {
                    if (_step == 0) {
                      setState(() => _step = 1);
                    } else {
                      _finalizarCadastro(context);
                    }
                  },
                  child: Text(_step == 0 ? 'Continuar' : 'Concluir cadastro'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepUm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Parte 1 — Dados institucionais',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
        const SizedBox(height: 14),
        TextField(
          controller: _nomeController,
          decoration: const InputDecoration(labelText: 'Nome da instituição'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(labelText: 'E-mail institucional'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _telefoneController,
          decoration: const InputDecoration(labelText: 'Telefone'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _cnpjController,
          decoration: const InputDecoration(labelText: 'CNPJ'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _localizacaoController,
          decoration: const InputDecoration(labelText: 'Localização'),
        ),
        const SizedBox(height: 12),
        const TextField(
          obscureText: true,
          decoration: InputDecoration(labelText: 'Senha'),
        ),
      ],
    );
  }

  Widget _buildStepDois() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Parte 2 — Classificação institucional',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        const Text(
          'Selecione o(s) tipo(s) de entidade que melhor descreve(m) sua instituição.',
          style: TextStyle(fontSize: 12, color: CoresApp.textoSecundario),
        ),
        const SizedBox(height: 10),
        ...TipoInstituicao.values.map((tipo) {
          final selecionado = _tiposSelecionados.contains(tipo);
          return Column(
            children: [
              CheckboxListTile(
                value: selecionado,
                onChanged: (v) => setState(() {
                  v == true ? _tiposSelecionados.add(tipo) : _tiposSelecionados.remove(tipo);
                }),
                title: Text(tipo.texto, style: const TextStyle(fontSize: 13)),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                dense: true,
              ),
              if (selecionado)
                Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 12),
                  child: TextField(
                    controller: _camposAdicionais[tipo],
                    decoration: InputDecoration(labelText: tipo.textoCampoAdicional),
                  ),
                ),
            ],
          );
        }),
      ],
    );
  }

  void _finalizarCadastro(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cadastro institucional concluído com sucesso!')),
    );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const InstituicaoTela()),
    );
  }
}
