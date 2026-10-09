import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../models/operario.dart';
import '../../services/servico_autenticacao.dart';
import '../../theme/tema_do_app.dart';
import '../../utils/validadores_campos_cadastro.dart';
import '../../widgets/barra_progresso_etapas.dart';
import '../../widgets/dialogo_confirmacao_codigo.dart';
import '../operario/operario_tela.dart';
import '../../services/servico_geolocalizacao.dart';

/// Tela de autenticação do usuário 'Operário' (ÉPICO 01 - US01.2):
/// login e cadastro em duas etapas integrado com AWS Amplify.
class TelaAutenticacaoOperario extends StatefulWidget {
  const TelaAutenticacaoOperario({super.key});

  @override
  State<TelaAutenticacaoOperario> createState() =>
      _TelaAutenticacaoOperarioState();
}

class _TelaAutenticacaoOperarioState extends State<TelaAutenticacaoOperario>
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
        title: const Text('Sou Operário'),
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
          _OperarioLoginFormulario(),
          _OperarioCadastroFormulario(),
        ],
      ),
    );
  }
}

class _OperarioLoginFormulario extends StatefulWidget {
  const _OperarioLoginFormulario();

  @override
  State<_OperarioLoginFormulario> createState() =>
      _OperarioLoginFormularioState();
}

class _OperarioLoginFormularioState extends State<_OperarioLoginFormulario> {
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
        MaterialPageRoute(builder: (_) => const OperarioTela()),
      );
    } else if (resultado.requerConfirmacaoCodigo) {
      final confirmouCodigo = await DialogoConfirmacaoCodigo.exibir(
        contexto: context,
        emailUsuario: _emailController.text.trim(),
      );

      if (confirmouCodigo == true && mounted) {
        navContext.pushReplacement(
          MaterialPageRoute(builder: (_) => const OperarioTela()),
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
              'Entre com seus dados para ver os serviços disponíveis na sua região.',
              style: TextStyle(fontSize: 12, color: CoresApp.textoSecundario),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                  labelText: 'E-mail', hintText: 'seuemail@exemplo.com'),
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

class _OperarioCadastroFormulario extends StatefulWidget {
  const _OperarioCadastroFormulario();

  @override
  State<_OperarioCadastroFormulario> createState() =>
      _OperarioCadastroFormularioState();
}

class _OperarioCadastroFormularioState
    extends State<_OperarioCadastroFormulario> {
  int _step = 0;
  final _formKeyUm = GlobalKey<FormState>();
  final _formKeyDois = GlobalKey<FormState>();
  final _servicoAuth = ServicoAutenticacao.instancia;

  bool _carregandoCadastro = false;

  final _cpfMask = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  // Parte 1 — Dados pessoais
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _cpfController = TextEditingController();
  final _localizacaoController = TextEditingController();
  final _senhaController = TextEditingController();

  // Parte 2 — Perfil profissional e Portfólio
  PlatformFile? _arquivoPortfolioSelecionado;
  final _experienciasController = TextEditingController();
  final Set<String> _escoposSelecionados = {};
  int _nivelDeclarado = 0; // 0, 3 ou 5 serviços
  double _raioKm = 10;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _cpfController.dispose();
    _localizacaoController.dispose();
    _senhaController.dispose();
    _experienciasController.dispose();
    super.dispose();
  }

  Future<void> _selecionarArquivoPortfolio() async {
    try {
      final resultado = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'png', 'jpg', 'jpeg'],
        withData: true, // <--- Importante para carregar bytes no Flutter Web!
      );

      if (resultado != null && resultado.files.isNotEmpty) {
        setState(() {
          _arquivoPortfolioSelecionado = resultado.files.first;
        });
      }
    } catch (erro) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao selecionar arquivo: $erro'),
          backgroundColor: CoresApp.vermelhoEscuro,
        ),
      );
    }
  }

  Future<void> _finalizarCadastro(BuildContext context) async {
    if (!_formKeyDois.currentState!.validate()) return;

    final navContext = Navigator.of(context);
    final scaffoldContext = ScaffoldMessenger.of(context);

    setState(() => _carregandoCadastro = true);

    try {
      // 1. Tentar criar usuário no Cognito
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

      // 2. Se for uma nova conta, exibe diálogo de confirmação do código recebido por e-mail
      if (!contaJaExistia && resultadoCognito.requerConfirmacaoCodigo) {
        final confirmou = await DialogoConfirmacaoCodigo.exibir(
          contexto: context,
          emailUsuario: _emailController.text.trim(),
        );
        if (confirmou != true || !mounted) {
          return;
        }
      }

      // 3. Fazer login temporário para estabelecer sessão autenticada
      await _servicoAuth.fazerLogin(
        email: _emailController.text,
        senha: _senhaController.text,
      );

      // 4. Se o usuário selecionou um portfólio, tenta enviar para o Amazon S3 Storage
      String? urlPortfolioS3;
      if (_arquivoPortfolioSelecionado != null) {
        try {
          final String? caminhoLocal =
              kIsWeb ? null : _arquivoPortfolioSelecionado!.path;

          urlPortfolioS3 = await _servicoAuth.enviarArquivoPortfolioParaS3(
            nomeOriginalArquivo: _arquivoPortfolioSelecionado!.name,
            bytesArquivo: _arquivoPortfolioSelecionado!.bytes,
            caminhoArquivoLocal: caminhoLocal,
          );
        } catch (erroS3) {
          debugPrint('Aviso: Falha ao enviar arquivo para o S3: $erroS3');
        }
      }

// --- NOVO PASSO: Converter CEP em Coordenadas ---
      double? latitudeBase;
      double? longitudeBase;

      final cepDigitado = _localizacaoController.text.trim();
      final coordenadas = await ServicoGeolocalizacao.converterCepParaCoordenadas(cepDigitado);

      if (coordenadas != null) {
        latitudeBase = coordenadas['latitude'];
        longitudeBase = coordenadas['longitude'];
      } else {
        // Se o CEP for inválido, bloqueia o registo e avisa o utilizador
        if (!mounted) return;
        scaffoldContext.showSnackBar(
          const SnackBar(
            content: Text('CEP inválido ou não encontrado. Verifique o seu endereço.'),
            backgroundColor: CoresApp.vermelhoEscuro,
          ),
        );
        setState(() => _carregandoCadastro = false);
        return; 
      }
      // -------------------------------------------------

      // 5. Salvar dados completos do perfil na tabela User do AppSync GraphQL
      await _servicoAuth.salvarPerfilUsuarioNoBanco(
        perfil: 'operario',
        email: _emailController.text.trim(),
        telefone: _telefoneController.text.trim(),
        enderecoTexto: _localizacaoController.text.trim(),
        nome: _nomeController.text.trim(),
        cpf: _cpfController.text.trim(),
        escopoOperario: _escoposSelecionados.toList(),
        nivelOperario: _nivelDeclarado.toString(),
        quantidadeServicosRealizados: _nivelDeclarado,
        raioAtendimentoKm: _raioKm.round(),
        experienciasAnteriores: _experienciasController.text.trim(),
        portfolioUrl: urlPortfolioS3,
        latitude: latitudeBase,
        longitude: longitudeBase,
      );

      if (!mounted) return;

      scaffoldContext.showSnackBar(
        const SnackBar(
          content: Text('Cadastro de operário concluído com sucesso!'),
          backgroundColor: CoresApp.verdeSucesso,
        ),
      );

      navContext.pushReplacement(
        MaterialPageRoute(builder: (_) => const OperarioTela()),
      );
    } catch (erroGeral) {
      debugPrint('Erro na finalização do cadastro de operário: $erroGeral');
      if (!mounted) return;

      // Mesmo que haja exceção no meio, tenta direcionar se a sessão estiver ativa
      navContext.pushReplacement(
        MaterialPageRoute(builder: (_) => const OperarioTela()),
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
            rotulosEtapas: const ['Dados pessoais', 'Perfil profissional'],
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
        const Text('Parte 1 — Dados pessoais',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
        const SizedBox(height: 14),
        TextFormField(
          controller: _nomeController,
          decoration: const InputDecoration(labelText: 'Nome completo'),
          validator: ValidadoresCamposCadastro.obrigatorio,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(labelText: 'E-mail'),
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
          controller: _cpfController,
          decoration: const InputDecoration(
              labelText: 'CPF', hintText: '000.000.000-00'),
          validator: ValidadoresCamposCadastro.cpf,
          inputFormatters: [_cpfMask],
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _localizacaoController,
          decoration: const InputDecoration(
            labelText: 'CEP (Apenas números)',
            hintText: '00000-000'),
          validator: ValidadoresCamposCadastro.obrigatorio,
          keyboardType: TextInputType.number,
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
        const Text('Parte 2 — Perfil profissional',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
        const SizedBox(height: 14),
        InkWell(
          onTap: _selecionarArquivoPortfolio,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _arquivoPortfolioSelecionado != null
                  ? CoresApp.verdeFundo
                  : CoresApp.branco,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _arquivoPortfolioSelecionado != null
                    ? CoresApp.verdeSucesso
                    : CoresApp.borda,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _arquivoPortfolioSelecionado != null
                      ? Icons.file_present_rounded
                      : Icons.upload_file_rounded,
                  color: _arquivoPortfolioSelecionado != null
                      ? CoresApp.verdeSucesso
                      : CoresApp.textoSecundario,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _arquivoPortfolioSelecionado != null
                            ? _arquivoPortfolioSelecionado!.name
                            : 'Anexar portfólio (PDF, Word ou imagem)',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _arquivoPortfolioSelecionado != null
                              ? CoresApp.verdeEscuro
                              : CoresApp.textoPrimario,
                        ),
                      ),
                      if (_arquivoPortfolioSelecionado != null)
                        Text(
                          '${(_arquivoPortfolioSelecionado!.size / 1024).toStringAsFixed(1)} KB · Clique para alterar',
                          style: const TextStyle(
                            fontSize: 10,
                            color: CoresApp.textoSecundario,
                          ),
                        ),
                    ],
                  ),
                ),
                if (_arquivoPortfolioSelecionado != null)
                  IconButton(
                    icon: const Icon(Icons.close_rounded,
                        size: 18, color: CoresApp.vermelhoEscuro),
                    onPressed: () =>
                        setState(() => _arquivoPortfolioSelecionado = null),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: _experienciasController,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Experiências anteriores',
            hintText: 'Conte um pouco sobre seus trabalhos já realizados',
            alignLabelWithHint: true,
          ),
          validator: ValidadoresCamposCadastro.obrigatorio,
        ),
        const SizedBox(height: 16),
        const Text('Escopo de trabalho',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: escoposDisponiveis.map((escopo) {
            final selected = _escoposSelecionados.contains(escopo);
            return FilterChip(
              label: Text(escopo, style: const TextStyle(fontSize: 11)),
              selected: selected,
              onSelected: (v) => setState(() {
                v
                    ? _escoposSelecionados.add(escopo)
                    : _escoposSelecionados.remove(escopo);
              }),
              selectedColor: CoresApp.vermelhoFundo,
              checkmarkColor: CoresApp.vermelhoAcao,
              side: BorderSide(
                  color: selected ? CoresApp.vermelhoAcao : CoresApp.borda),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        const Text('Nível de experiência',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
        Column(
          children: [
            _radioNivel(0, '0+ serviços realizados (iniciante)'),
            _radioNivel(3, '3+ serviços realizados'),
            _radioNivel(5, '5+ serviços realizados'),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Raio de distância máximo de atendimento: ${_raioKm.round()} km',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        ),
        Slider(
          value: _raioKm,
          min: 1,
          max: 30,
          divisions: 29,
          label: '${_raioKm.round()} km',
          onChanged: (v) => setState(() => _raioKm = v),
        ),
      ],
    );
  }

  Widget _radioNivel(int valor, String label) {
    return RadioListTile<int>(
      value: valor,
      groupValue: _nivelDeclarado,
      onChanged: (v) => setState(() => _nivelDeclarado = v ?? 0),
      title: Text(label, style: const TextStyle(fontSize: 12)),
      dense: true,
      contentPadding: EdgeInsets.zero,
    );
  }
}
