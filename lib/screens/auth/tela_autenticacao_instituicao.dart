import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../models/instituicao.dart';
import '../../theme/tema_do_app.dart';
import '../../utils/validadores_campos_cadastro.dart';
import '../../widgets/barra_progresso_etapas.dart';
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

class _InstituicaoLoginForm extends StatefulWidget {
  const _InstituicaoLoginForm();

  @override
  State<_InstituicaoLoginForm> createState() => _InstituicaoLoginFormState();
}

class _InstituicaoLoginFormState extends State<_InstituicaoLoginForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
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
            TextFormField(
              decoration:
                  const InputDecoration(labelText: 'E-mail institucional', hintText: 'contato@ong.org'),
              validator: ValidadoresCamposCadastro.email,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Senha'),
              validator: ValidadoresCamposCadastro.obrigatorio,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const InstituicaoTela()),
                    );
                  }
                },
                child: const Text('Entrar'),
              ),
            ),
          ],
        ),
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
  final _formKeyUm = GlobalKey<FormState>();
  final _formKeyDois = GlobalKey<FormState>();

  final _cnpjMask = MaskTextInputFormatter(
    mask: '##.###.###/####-##',
    filter: {"#": RegExp(r'[0-9]')},
  );
  final _telefoneMask = MaskTextInputFormatter(
    mask: '(##) ####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

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
            child: Form(
              key: _step == 0 ? _formKeyUm : _formKeyDois,
              child: _step == 0 ? _formularioPassoUm() : _formularioPassoDois(),
            ),
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
                      if (_formKeyUm.currentState!.validate()) {
                        setState(() => _step = 1);
                      }
                    } else {
                      final formValido = _formKeyDois.currentState!.validate();
                      if (_tiposSelecionados.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Selecione pelo menos um tipo de instituição.'),
                            backgroundColor: CoresApp.vermelhoEscuro,
                          ),
                        );
                        return;
                      }
                      if (formValido) {
                        _finalizarCadastro(context);
                      }
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

  Widget _formularioPassoUm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Parte 1 — Dados institucionais',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
        const SizedBox(height: 14),
        TextFormField(
          controller: _nomeController,
          decoration: const InputDecoration(labelText: 'Nome da instituição'),
          validator: ValidadoresCamposCadastro.obrigatorio,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(labelText: 'E-mail institucional'),
          validator: ValidadoresCamposCadastro.email,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _telefoneController,
          decoration: const InputDecoration(labelText: 'Telefone', hintText: '(00) 0000-0000'),
          validator: ValidadoresCamposCadastro.telefone,
          inputFormatters: [_telefoneMask],
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _cnpjController,
          decoration: const InputDecoration(labelText: 'CNPJ', hintText: '00.000.000/0000-00'),
          validator: ValidadoresCamposCadastro.cnpj,
          inputFormatters: [_cnpjMask],
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _localizacaoController,
          decoration: const InputDecoration(labelText: 'Localização'),
          validator: ValidadoresCamposCadastro.obrigatorio,
        ),
        const SizedBox(height: 12),
        TextFormField(
          obscureText: true,
          decoration: const InputDecoration(labelText: 'Senha'),
          validator: (v) {
            if (v == null || v.isEmpty) return 'Campo obrigatório';
            if (v.length < 3) return 'A senha deve ter pelo menos 3 caracteres';
            return null;
          },
        ),
      ],
    );
  }

  Widget _formularioPassoDois() {
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
                  child: TextFormField(
                    controller: _camposAdicionais[tipo],
                    decoration: InputDecoration(labelText: tipo.textoCampoAdicional),
                    validator: ValidadoresCamposCadastro.obrigatorio,
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
