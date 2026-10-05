import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../models/instituicao.dart';
import '../../services/servico_autenticacao.dart';
import '../../theme/tema_do_app.dart';
import '../../utils/validadores_campos_cadastro.dart';
import '../../widgets/barra_progresso_etapas.dart';
import '../../widgets/dialogo_confirmacao_codigo.dart';
import '../instituicao/instituicao_tela.dart';

/// Tela de autenticação do usuário 'Instituição' (ÉPICO 01 - US01.3):
/// login e cadastro em duas etapas integrado com AWS Amplify.
class TelaAutenticacaoInstituicao extends StatefulWidget {
  const TelaAutenticacaoInstituicao({super.key});

  @override
  State<TelaAutenticacaoInstituicao> createState() =>
      _TelaAutenticacaoInstituicaoState();
}

class _TelaAutenticacaoInstituicaoState
    extends State<TelaAutenticacaoInstituicao>
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
          unselectedLabelColor: const Color(0xFFB9C3D6),
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
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _servicoAuth = ServicoAutenticacao.instancia;

  bool _carregandoLogin = false;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _processarLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final messengerContext = ScaffoldMessenger.of(context);
    final navContext = Navigator.of(context);

    setState(() => _carregandoLogin = true);

    final resultado = await _servicoAuth.fazerLogin(
      email: _emailController.text,
      senha: _senhaController.text,
    );

    if (!mounted) return;

    setState(() => _carregandoLogin = false);

    if (resultado.sucesso) {
      navContext.pushReplacement(
        MaterialPageRoute(builder: (_) => const InstituicaoTela()),
      );
    } else if (resultado.requerConfirmacaoCodigo) {
      final confirmouCodigo = await DialogoConfirmacaoCodigo.exibir(
        contexto: context,
        emailUsuario: _emailController.text.trim(),
      );

      if (confirmouCodigo == true && mounted) {
        navContext.pushReplacement(
          MaterialPageRoute(builder: (_) => const InstituicaoTela()),
        );
      }
    } else {
      messengerContext.showSnackBar(
        SnackBar(
          content: Text(
              resultado.mensagemErro ?? 'Erro ao realizar login no sistema.'),
          backgroundColor: CoresApp.vermelhoEscuro,
        ),
      );
    }
  }

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
              controller: _emailController,
              decoration: const InputDecoration(
                  labelText: 'E-mail institucional', hintText: 'contato@ong.org'),
              validator: ValidadoresCamposCadastro.email,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _senhaController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Senha'),
              validator: ValidadoresCamposCadastro.obrigatorio,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _carregandoLogin ? null : _processarLogin,
                child: _carregandoLogin
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: CoresApp.branco,
                        ),
                      )
                    : const Text('Entrar'),
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
  State<_InstituicaoCadastroForm> createState() =>
      _InstituicaoCadastroFormState();
}

class _InstituicaoCadastroFormState extends State<_InstituicaoCadastroForm> {
  int _step = 0;
  final _formKeyUm = GlobalKey<FormState>();
  final _formKeyDois = GlobalKey<FormState>();
  final _servicoAuth = ServicoAutenticacao.instancia;

  bool _carregandoCadastro = false;

  final _cnpjMask = MaskTextInputFormatter(
    mask: '##.###.###/####-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  // Parte 1 — Dados institucionais
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _cnpjController = TextEditingController();
  final _localizacaoController = TextEditingController();
  final _senhaController = TextEditingController();

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
    _senhaController.dispose();
    for (final c in _camposAdicionais.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _finalizarCadastro(BuildContext context) async {
    if (!_formKeyDois.currentState!.validate()) return;

    if (_tiposSelecionados.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione pelo menos um tipo de instituição.'),
          backgroundColor: CoresApp.vermelhoEscuro,
        ),
      );
      return;
    }

    final navContext = Navigator.of(context);
    final scaffoldContext = ScaffoldMessenger.of(context);

    setState(() => _carregandoCadastro = true);

    try {
      // 1. Criar usuário no Cognito
      final resultadoCognito = await _servicoAuth.cadastrarUsuarioCognito(
        email: _emailController.text,
        senha: _senhaController.text,
      );

      if (!mounted) return;

      bool contaJaExistia = false;

      if (!resultadoCognito.sucesso) {
        if (resultadoCognito.mensagemErro?.contains('Já existe uma conta') ==
            true) {
          contaJaExistia = true;
        } else {
          scaffoldContext.showSnackBar(
            SnackBar(
              content: Text(resultadoCognito.mensagemErro ??
                  'Erro ao realizar cadastro no sistema.'),
              backgroundColor: CoresApp.vermelhoEscuro,
            ),
          );
          return;
        }
      }

      // 2. Se for nova conta, exibe diálogo de confirmação do código recebido por e-mail
      if (!contaJaExistia && resultadoCognito.requerConfirmacaoCodigo) {
        if (!mounted) return;
        final confirmou = await DialogoConfirmacaoCodigo.exibir(
          contexto: context,
          emailUsuario: _emailController.text.trim(),
        );
        if (confirmou != true || !mounted) {
          return;
        }
      }

      // 3. Processos pós-confirmação (Login e Cadastro GraphQL)
      await _servicoAuth.fazerLogin(
        email: _emailController.text,
        senha: _senhaController.text,
      );

      // 4. Salvar dados completos do perfil na tabela User do AppSync GraphQL
      final textoTipos =
          _tiposSelecionados.map((tipo) => tipo.texto).join(', ');

      await _servicoAuth.salvarPerfilUsuarioNoBanco(
        perfil: 'instituicao',
        email: _emailController.text.trim(),
        telefone: _telefoneController.text.trim(),
        enderecoTexto: _localizacaoController.text.trim(),
        nomeInstituicao: _nomeController.text.trim(),
        cnpj: _cnpjController.text.trim(),
        tipoEntidade: textoTipos,
      );

      if (!mounted) return;

      scaffoldContext.showSnackBar(
        const SnackBar(
          content: Text('Cadastro institucional concluído com sucesso!'),
          backgroundColor: CoresApp.verdeSucesso,
        ),
      );

      navContext.pushReplacement(
        MaterialPageRoute(builder: (_) => const InstituicaoTela()),
      );
    } catch (erroGeral) {
      debugPrint('Erro na finalização do cadastro de instituição: $erroGeral');
      if (!mounted) return;

      navContext.pushReplacement(
        MaterialPageRoute(builder: (_) => const InstituicaoTela()),
      );
    } finally {
      if (mounted) {
        setState(() => _carregandoCadastro = false);
      }
    }
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
                    onPressed: _carregandoCadastro
                        ? null
                        : () => setState(() => _step = 0),
                    child: const Text('Voltar'),
                  ),
                ),
              if (_step == 1) const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _carregandoCadastro
                      ? null
                      : () {
                          if (_step == 0) {
                            if (_formKeyUm.currentState!.validate()) {
                              setState(() => _step = 1);
                            }
                          } else {
                            _finalizarCadastro(context);
                          }
                        },
                  child: _carregandoCadastro
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: CoresApp.branco,
                          ),
                        )
                      : Text(_step == 0 ? 'Continuar' : 'Concluir cadastro'),
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
          decoration:
              const InputDecoration(labelText: 'E-mail institucional'),
          validator: ValidadoresCamposCadastro.email,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _telefoneController,
          decoration: const InputDecoration(
              labelText: 'Telefone (Fixo ou Celular)',
              hintText: '(00) 0000-0000 ou (00) 00000-0000'),
          validator: ValidadoresCamposCadastro.telefone,
          inputFormatters: [FormatadorTelefoneDinamico()],
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _cnpjController,
          decoration: const InputDecoration(
              labelText: 'CNPJ', hintText: '00.000.000/0000-00'),
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
          controller: _senhaController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Senha de acesso',
            hintText: 'Ex: Senha@123 (A-z, 0-9, símbolos)',
          ),
          validator: ValidadoresCamposCadastro.senha,
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
                  v == true
                      ? _tiposSelecionados.add(tipo)
                      : _tiposSelecionados.remove(tipo);
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
                    decoration:
                        InputDecoration(labelText: tipo.textoCampoAdicional),
                    validator: ValidadoresCamposCadastro.obrigatorio,
                  ),
                ),
            ],
          );
        }),
      ],
    );
  }
}
