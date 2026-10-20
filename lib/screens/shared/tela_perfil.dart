import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/instituicao.dart';
import '../../models/operario.dart';
import '../../services/gerenciador_sessao_usuario.dart';
import '../../services/servico_autenticacao.dart';
import '../../services/servico_geolocalizacao.dart';
import '../../theme/tema_do_app.dart';
import '../../utils/validadores_campos_cadastro.dart';
import '../../widgets/titulo_secao.dart';
import '../tela_selecao_tipo_usuario.dart';
import '../instituicao/instituicao_tela_doacao.dart';

/// Tela "Editar Perfil", presente no menu inferior de ambos os
/// perfis (ÉPICO 02 - US02.1). Permite visualizar, editar, baixar, alterar
/// e remover portfólios e estatutos no S3, e salvar as alterações no AWS AppSync GraphQL.
class TelaPerfil extends StatefulWidget {
  final bool ehInstituicao;

  const TelaPerfil({super.key, required this.ehInstituicao});

  @override
  State<TelaPerfil> createState() => _TelaPerfilState();
}

class _TelaPerfilState extends State<TelaPerfil> {
  final _formKey = GlobalKey<FormState>();
  final _servicoAuth = ServicoAutenticacao.instancia;

  bool _carregandoSalvar = false;
  bool _gerandoUrlS3 = false;
  String? _idPerfilCarregado;

  // Controllers Operário e Instituição
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _cpfCnpjController = TextEditingController();
  final _cepController = TextEditingController();
  final _experienciasController = TextEditingController();

  // Estado Operário
  double _raioKm = 10;
  Set<String> _escoposSelecionados = {};
  String _portfolioUrlS3 = '';
  PlatformFile? _novoArquivoPortfolio;

  // Estado Instituição
  Set<TipoInstituicao> _tiposSelecionadosInstituicao = {};
  String _estatutoUrlS3 = '';
  PlatformFile? _novoArquivoEstatuto;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _cpfCnpjController.dispose();
    _cepController.dispose();
    _experienciasController.dispose();
    super.dispose();
  }

  void _carregarDadosPerfilSeNecessario() {
    if (!widget.ehInstituicao &&
        GerenciadorSessaoUsuario.instancia.temOperarioLogado) {
      final op = GerenciadorSessaoUsuario.instancia.operarioLogado!;
      if (_idPerfilCarregado != op.id) {
        _idPerfilCarregado = op.id;
        _nomeController.text = op.nome;
        _emailController.text = op.email;
        _telefoneController.text = op.telefone;
        _cpfCnpjController.text = op.cpf;
        _cepController.text = op.localizacao;
        _experienciasController.text = op.experienciasAnteriores;
        _raioKm = op.raioAtendimentoKm;
        _escoposSelecionados = Set.from(op.escopos);
        _portfolioUrlS3 = op.portfolioUrl;
      }
    } else if (widget.ehInstituicao &&
        GerenciadorSessaoUsuario.instancia.temInstituicaoLogada) {
      final inst = GerenciadorSessaoUsuario.instancia.instituicaoLogada!;
      final idInst = inst.id.isNotEmpty ? inst.id : inst.emailInstitucional;
      if (_idPerfilCarregado != idInst) {
        _idPerfilCarregado = idInst;
        _nomeController.text = inst.nome;
        _emailController.text = inst.emailInstitucional;
        _telefoneController.text = inst.telefone;
        _cpfCnpjController.text = inst.cnpj;
        _cepController.text = inst.localizacao;
        _tiposSelecionadosInstituicao = Set.from(inst.tipos);
        _estatutoUrlS3 = inst.estatutoSocialUrl;
      }
    }
  }

  Future<void> _fazerLogoutESair() async {
    await _servicoAuth.fazerLogout();
    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const TelaSelecaoTipoUsuario()),
      (route) => false,
    );
  }

  // --- MÉTODOS DO OPERÁRIO (PORTFÓLIO) ---

  Future<void> _selecionarNovoPortfolio() async {
    try {
      final resultado = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'png', 'jpg', 'jpeg'],
        withData: true,
      );

      if (resultado != null && resultado.files.isNotEmpty) {
        setState(() {
          _novoArquivoPortfolio = resultado.files.first;
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

  Future<void> _abrirPortfolioS3() async {
    if (_portfolioUrlS3.isEmpty) return;

    final messengerContext = ScaffoldMessenger.of(context);
    setState(() => _gerandoUrlS3 = true);

    final urlDownload =
        await _servicoAuth.obterUrlDownloadPortfolio(_portfolioUrlS3);

    if (!mounted) return;

    setState(() => _gerandoUrlS3 = false);

    if (urlDownload != null) {
      final uri = Uri.parse(urlDownload);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        messengerContext.showSnackBar(
          const SnackBar(
            content: Text('Não foi possível abrir o link do arquivo.'),
            backgroundColor: CoresApp.vermelhoEscuro,
          ),
        );
      }
    } else {
      messengerContext.showSnackBar(
        const SnackBar(
          content: Text('Erro ao recuperar o arquivo do S3.'),
          backgroundColor: CoresApp.vermelhoEscuro,
        ),
      );
    }
  }

  void _removerPortfolio() {
    setState(() {
      _portfolioUrlS3 = '';
      _novoArquivoPortfolio = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
            'Portfólio removido. Clique em "Salvar alterações" para confirmar.'),
        backgroundColor: CoresApp.amareloEscuro,
      ),
    );
  }

  // --- MÉTODOS DA INSTITUIÇÃO (ESTATUTO SOCIAL) ---

  Future<void> _selecionarNovoEstatutoSocial() async {
    try {
      final resultado = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'png', 'jpg', 'jpeg'],
        withData: true,
      );

      if (resultado != null && resultado.files.isNotEmpty) {
        setState(() {
          _novoArquivoEstatuto = resultado.files.first;
        });
      }
    } catch (erro) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao selecionar documento: $erro'),
          backgroundColor: CoresApp.vermelhoEscuro,
        ),
      );
    }
  }

  Future<void> _abrirEstatutoS3() async {
    if (_estatutoUrlS3.isEmpty) return;

    final messengerContext = ScaffoldMessenger.of(context);
    setState(() => _gerandoUrlS3 = true);

    final urlDownload =
        await _servicoAuth.obterUrlDownloadEstatuto(_estatutoUrlS3);

    if (!mounted) return;

    setState(() => _gerandoUrlS3 = false);

    if (urlDownload != null) {
      final uri = Uri.parse(urlDownload);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        messengerContext.showSnackBar(
          const SnackBar(
            content: Text('Não foi possível abrir o link do arquivo.'),
            backgroundColor: CoresApp.vermelhoEscuro,
          ),
        );
      }
    } else {
      messengerContext.showSnackBar(
        const SnackBar(
          content: Text('Erro ao recuperar o arquivo do S3.'),
          backgroundColor: CoresApp.vermelhoEscuro,
        ),
      );
    }
  }

  void _removerEstatutoSocial() {
    setState(() {
      _estatutoUrlS3 = '';
      _novoArquivoEstatuto = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
            'Estatuto Social removido. Clique em "Salvar alterações" para confirmar.'),
        backgroundColor: CoresApp.amareloEscuro,
      ),
    );
  }

  // --- SALVAMENTO GERAL ---

  Future<void> _salvarAlteracoesPerfil() async {
    if (!_formKey.currentState!.validate()) return;

    final scaffoldContext = ScaffoldMessenger.of(context);
    setState(() => _carregandoSalvar = true);

    try {
      final operarioLogado =
          GerenciadorSessaoUsuario.instancia.operarioLogado;
      final instituicaoLogada =
          GerenciadorSessaoUsuario.instancia.instituicaoLogada;

      final idUsuario = widget.ehInstituicao
          ? (instituicaoLogada?.id.isNotEmpty == true
              ? instituicaoLogada!.id
              : instituicaoLogada?.emailInstitucional ?? '')
          : (operarioLogado?.id ?? '');

      if (idUsuario.isEmpty) {
        scaffoldContext.showSnackBar(
          const SnackBar(
            content: Text('Erro: perfil do usuário não encontrado para atualização.'),
            backgroundColor: CoresApp.vermelhoEscuro,
          ),
        );
        return;
      }

      // 1. Converte o CEP em coordenadas geográficas
      double? lat;
      double? lon;
      final cepDigitado = _cepController.text.trim();
      final coordenadas =
          await ServicoGeolocalizacao.converterCepParaCoordenadas(cepDigitado);

      if (coordenadas != null) {
        lat = coordenadas['latitude'];
        lon = coordenadas['longitude'];
      }

      if (!widget.ehInstituicao) {
        // --- SALVAR PERFIL DO OPERÁRIO ---

        // Se houver novo arquivo de portfólio selecionado, faz upload para o S3
        String? novaUrlS3 = _portfolioUrlS3;
        if (_novoArquivoPortfolio != null) {
          final String? caminhoLocal =
              kIsWeb ? null : _novoArquivoPortfolio!.path;

          final caminhoUpload = await _servicoAuth.enviarArquivoPortfolioParaS3(
            nomeOriginalArquivo: _novoArquivoPortfolio!.name,
            bytesArquivo: _novoArquivoPortfolio!.bytes,
            caminhoArquivoLocal: caminhoLocal,
          );

          if (caminhoUpload != null) {
            novaUrlS3 = caminhoUpload;
          }
        }

        final atualizou = await _servicoAuth.atualizarPerfilUsuarioNoBanco(
          id: idUsuario,
          nome: _nomeController.text,
          telefone: _telefoneController.text,
          enderecoTexto: _cepController.text,
          raioAtendimentoKm: _raioKm.round(),
          escopoOperario: _escoposSelecionados.toList(),
          experienciasAnteriores: _experienciasController.text,
          portfolioUrl: novaUrlS3,
          latitude: lat,
          longitude: lon,
        );

        if (!mounted) return;

        if (atualizou) {
          setState(() {
            _portfolioUrlS3 = novaUrlS3 ?? '';
            _novoArquivoPortfolio = null;
            _idPerfilCarregado = null;
          });

          scaffoldContext.showSnackBar(
            const SnackBar(
              content: Text('Perfil de operário atualizado com sucesso!'),
              backgroundColor: CoresApp.verdeSucesso,
            ),
          );
        } else {
          scaffoldContext.showSnackBar(
            const SnackBar(
              content: Text('Não foi possível atualizar o perfil no banco.'),
              backgroundColor: CoresApp.vermelhoEscuro,
            ),
          );
        }
      } else {
        // --- SALVAR PERFIL DA INSTITUIÇÃO ---

        // Se houver novo arquivo de estatuto selecionado, faz upload para o S3
        String? novaUrlEstatutoS3 = _estatutoUrlS3;
        if (_novoArquivoEstatuto != null) {
          final String? caminhoLocal =
              kIsWeb ? null : _novoArquivoEstatuto!.path;

          final caminhoUpload = await _servicoAuth.enviarEstatutoSocialParaS3(
            nomeOriginalArquivo: _novoArquivoEstatuto!.name,
            bytesArquivo: _novoArquivoEstatuto!.bytes,
            caminhoArquivoLocal: caminhoLocal,
          );

          if (caminhoUpload != null) {
            novaUrlEstatutoS3 = caminhoUpload;
          }
        }

        final textoTipos = _tiposSelecionadosInstituicao
            .map((tipo) => tipo.texto)
            .join(', ');

        final atualizou = await _servicoAuth.atualizarPerfilInstituicaoNoBanco(
          id: idUsuario,
          nomeInstituicao: _nomeController.text,
          telefone: _telefoneController.text,
          enderecoTexto: _cepController.text,
          tipoEntidade: textoTipos,
          estatutoSocialUrl: novaUrlEstatutoS3,
          latitude: lat,
          longitude: lon,
        );

        if (!mounted) return;

        if (atualizou) {
          setState(() {
            _estatutoUrlS3 = novaUrlEstatutoS3 ?? '';
            _novoArquivoEstatuto = null;
            _idPerfilCarregado = null;
          });

          scaffoldContext.showSnackBar(
            const SnackBar(
              content: Text('Perfil institucional atualizado com sucesso!'),
              backgroundColor: CoresApp.verdeSucesso,
            ),
          );
        } else {
          scaffoldContext.showSnackBar(
            const SnackBar(
              content: Text('Não foi possível atualizar a instituição no banco.'),
              backgroundColor: CoresApp.vermelhoEscuro,
            ),
          );
        }
      }
    } catch (erro) {
      debugPrint('Erro ao salvar alterações no perfil: $erro');
      if (!mounted) return;
      scaffoldContext.showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar alterações: $erro'),
          backgroundColor: CoresApp.vermelhoEscuro,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _carregandoSalvar = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        automaticallyImplyLeading: false,
      ),
      body: ListenableBuilder(
        listenable: GerenciadorSessaoUsuario.instancia,
        builder: (context, _) {
          _carregarDadosPerfilSeNecessario();

          final temPerfilReal = widget.ehInstituicao
              ? GerenciadorSessaoUsuario.instancia.temInstituicaoLogada
              : GerenciadorSessaoUsuario.instancia.temOperarioLogado;

          if (!temPerfilReal) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: CoresApp.azulConfianca),
                    SizedBox(height: 16),
                    Text(
                      'Carregando dados do seu perfil da AWS...',
                      style: TextStyle(
                          color: CoresApp.textoSecundario, fontSize: 13),
                    ),
                  ],
                ),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAvatarHeader(),
                  const SizedBox(height: 20),
                  const TituloSecao(titulo: 'Dados cadastrais'),
                  const SizedBox(height: 12),
                  if (widget.ehInstituicao)
                    ..._buildCamposInstituicao()
                  else
                    ..._buildCamposOperario(),
                  const SizedBox(height: 20),
                  if (widget.ehInstituicao) ...[
                    const TituloSecao(titulo: 'Configurações'),
                    const SizedBox(height: 10),
                    _menuTile(
                      context,
                      icon: Icons.volunteer_activism_rounded,
                      iconColor: CoresApp.amareloEscuro,
                      iconBg: CoresApp.amareloFundo,
                      texto: 'Ajude a Aplicação',
                      subtitle: 'Contribua voluntariamente via Pix',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => const InstituicaoTelaDoacao()),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          _carregandoSalvar ? null : _salvarAlteracoesPerfil,
                      child: _carregandoSalvar
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: CoresApp.branco,
                              ),
                            )
                          : const Text('Salvar alterações'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _fazerLogoutESair(),
                      icon: const Icon(Icons.logout_rounded, size: 18),
                      label: const Text('Sair'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: CoresApp.vermelhoEscuro,
                        side: const BorderSide(color: CoresApp.vermelhoEscuro),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAvatarHeader() {
    final nome = widget.ehInstituicao
        ? GerenciadorSessaoUsuario.instancia.instituicaoAtual.nome
        : GerenciadorSessaoUsuario.instancia.operarioAtual.nome;
    final subtitulo = widget.ehInstituicao ? 'Instituição' : 'Operário';
    final inicial = nome.trim().isNotEmpty
        ? nome.trim().substring(0, 1).toUpperCase()
        : 'U';

    return Row(
      children: [
        CircleAvatar(
          radius: 32,
          backgroundColor: CoresApp.azulFundo,
          child: Text(
            inicial,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: CoresApp.azulClaro,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(nome,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: CoresApp.vermelhoFundo,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  subtitulo,
                  style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: CoresApp.vermelhoEscuro),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildCamposOperario() {
    return [
      TextFormField(
        controller: _nomeController,
        decoration: const InputDecoration(labelText: 'Nome completo'),
        validator: ValidadoresCamposCadastro.obrigatorio,
      ),
      const SizedBox(height: 12),
      TextFormField(
        controller: _emailController,
        readOnly: true,
        decoration: const InputDecoration(
            labelText: 'E-mail (Leitura)',
            fillColor: CoresApp.bloqueadoFundo),
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
        controller: _cpfCnpjController,
        readOnly: true,
        decoration: const InputDecoration(
            labelText: 'CPF (Leitura)',
            fillColor: CoresApp.bloqueadoFundo),
      ),
      const SizedBox(height: 12),
      TextFormField(
        controller: _cepController,
        decoration: const InputDecoration(
            labelText: 'CEP (Apenas números)', hintText: '00000-000'),
        validator: ValidadoresCamposCadastro.cep,
        inputFormatters: [FormatadorCep()],
        keyboardType: TextInputType.number,
      ),
      const SizedBox(height: 16),
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
      const SizedBox(height: 12),
      TextFormField(
        controller: _experienciasController,
        maxLines: 3,
        decoration: const InputDecoration(
          labelText: 'Experiências anteriores',
          alignLabelWithHint: true,
        ),
        validator: ValidadoresCamposCadastro.obrigatorio,
      ),
      const SizedBox(height: 16),
      const Text('Escopo de trabalho',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
      const SizedBox(height: 6),
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
      const SizedBox(height: 20),
      const Text('Portfólio Profissional',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
      const SizedBox(height: 8),
      _buildSecaoPortfolioOperario(),
      const SizedBox(height: 12),
    ];
  }

  Widget _buildSecaoPortfolioOperario() {
    // 1. Novo arquivo selecionado aguardando salvar
    if (_novoArquivoPortfolio != null) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: CoresApp.verdeFundo,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: CoresApp.verdeSucesso),
        ),
        child: Row(
          children: [
            const Icon(Icons.file_present_rounded, color: CoresApp.verdeSucesso),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _novoArquivoPortfolio!.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: CoresApp.verdeEscuro),
                  ),
                  Text(
                    'Novo arquivo selecionado (${(_novoArquivoPortfolio!.size / 1024).toStringAsFixed(1)} KB)',
                    style: const TextStyle(
                        fontSize: 10, color: CoresApp.textoSecundario),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close_rounded,
                  size: 18, color: CoresApp.vermelhoEscuro),
              onPressed: () => setState(() => _novoArquivoPortfolio = null),
            ),
          ],
        ),
      );
    }

    // 2. Arquivo gravado no S3
    if (_portfolioUrlS3.isNotEmpty) {
      final nomeExibicaoArquivo = _portfolioUrlS3.contains('_')
          ? _portfolioUrlS3.split('_').last
          : _portfolioUrlS3.split('/').last;

      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: CoresApp.azulFundo,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: CoresApp.azulClaro),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.task_rounded, color: CoresApp.azulClaro),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nomeExibicaoArquivo,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: CoresApp.azulConfianca),
                      ),
                      const Text(
                        'Portfólio cadastrado no Amazon S3',
                        style: TextStyle(
                            fontSize: 10, color: CoresApp.textoSecundario),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _gerandoUrlS3 ? null : _abrirPortfolioS3,
                    icon: _gerandoUrlS3
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.download_rounded, size: 16),
                    label: const Text('Visualizar / Baixar',
                        style: TextStyle(fontSize: 11)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: CoresApp.azulConfianca,
                      side: const BorderSide(color: CoresApp.azulConfianca),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _selecionarNovoPortfolio,
                    icon: const Icon(Icons.edit_rounded, size: 16),
                    label: const Text('Alterar', style: TextStyle(fontSize: 11)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: CoresApp.amareloEscuro,
                      side: const BorderSide(color: CoresApp.amareloSolidario),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _removerPortfolio,
                  icon: const Icon(Icons.delete_outline_rounded,
                      color: CoresApp.vermelhoEscuro),
                  tooltip: 'Remover Portfólio',
                ),
              ],
            ),
          ],
        ),
      );
    }

    // 3. Sem portfólio
    return OutlinedButton.icon(
      onPressed: _selecionarNovoPortfolio,
      icon: const Icon(Icons.upload_file_rounded, size: 18),
      label: const Text('Anexar Portfólio (PDF, Word ou imagem)',
          style: TextStyle(fontSize: 12)),
      style: OutlinedButton.styleFrom(
        foregroundColor: CoresApp.azulConfianca,
        side: const BorderSide(color: CoresApp.borda),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
    );
  }

  List<Widget> _buildCamposInstituicao() {
    return [
      TextFormField(
        controller: _nomeController,
        decoration: const InputDecoration(labelText: 'Nome da instituição'),
        validator: ValidadoresCamposCadastro.obrigatorio,
      ),
      const SizedBox(height: 12),
      TextFormField(
        controller: _emailController,
        readOnly: true,
        decoration: const InputDecoration(
            labelText: 'E-mail institucional (Leitura)',
            fillColor: CoresApp.bloqueadoFundo),
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
        controller: _cpfCnpjController,
        readOnly: true,
        decoration: const InputDecoration(
            labelText: 'CNPJ (Leitura)',
            fillColor: CoresApp.bloqueadoFundo),
      ),
      const SizedBox(height: 12),
      TextFormField(
        controller: _cepController,
        decoration: const InputDecoration(
            labelText: 'CEP (Apenas números)', hintText: '00000-000'),
        validator: ValidadoresCamposCadastro.cep,
        inputFormatters: [FormatadorCep()],
        keyboardType: TextInputType.number,
      ),
      const SizedBox(height: 16),
      const Text('Tipo de Entidade',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
      const SizedBox(height: 6),
      Wrap(
        spacing: 8,
        runSpacing: 4,
        children: TipoInstituicao.values.map((tipo) {
          final selected = _tiposSelecionadosInstituicao.contains(tipo);
          return FilterChip(
            label: Text(tipo.texto, style: const TextStyle(fontSize: 11)),
            selected: selected,
            onSelected: (v) => setState(() {
              v
                  ? _tiposSelecionadosInstituicao.add(tipo)
                  : _tiposSelecionadosInstituicao.remove(tipo);
            }),
            selectedColor: CoresApp.vermelhoFundo,
            checkmarkColor: CoresApp.vermelhoAcao,
            side: BorderSide(
                color: selected ? CoresApp.vermelhoAcao : CoresApp.borda),
          );
        }).toList(),
      ),
      const SizedBox(height: 20),
      const Text('Estatuto Social / Documentação Oficial',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
      const SizedBox(height: 8),
      _buildSecaoEstatutoInstituicao(),
      const SizedBox(height: 12),
    ];
  }

  Widget _buildSecaoEstatutoInstituicao() {
    // 1. Novo arquivo selecionado aguardando salvar
    if (_novoArquivoEstatuto != null) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: CoresApp.verdeFundo,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: CoresApp.verdeSucesso),
        ),
        child: Row(
          children: [
            const Icon(Icons.file_present_rounded, color: CoresApp.verdeSucesso),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _novoArquivoEstatuto!.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: CoresApp.verdeEscuro),
                  ),
                  Text(
                    'Novo estatuto selecionado (${(_novoArquivoEstatuto!.size / 1024).toStringAsFixed(1)} KB)',
                    style: const TextStyle(
                        fontSize: 10, color: CoresApp.textoSecundario),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close_rounded,
                  size: 18, color: CoresApp.vermelhoEscuro),
              onPressed: () => setState(() => _novoArquivoEstatuto = null),
            ),
          ],
        ),
      );
    }

    // 2. Arquivo gravado no S3
    if (_estatutoUrlS3.isNotEmpty) {
      final nomeExibicaoArquivo = _estatutoUrlS3.contains('_')
          ? _estatutoUrlS3.split('_').last
          : _estatutoUrlS3.split('/').last;

      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: CoresApp.azulFundo,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: CoresApp.azulClaro),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.task_rounded, color: CoresApp.azulClaro),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nomeExibicaoArquivo,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: CoresApp.azulConfianca),
                      ),
                      const Text(
                        'Estatuto Social cadastrado no Amazon S3',
                        style: TextStyle(
                            fontSize: 10, color: CoresApp.textoSecundario),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _gerandoUrlS3 ? null : _abrirEstatutoS3,
                    icon: _gerandoUrlS3
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.download_rounded, size: 16),
                    label: const Text('Visualizar / Baixar',
                        style: TextStyle(fontSize: 11)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: CoresApp.azulConfianca,
                      side: const BorderSide(color: CoresApp.azulConfianca),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _selecionarNovoEstatutoSocial,
                    icon: const Icon(Icons.edit_rounded, size: 16),
                    label: const Text('Alterar', style: TextStyle(fontSize: 11)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: CoresApp.amareloEscuro,
                      side: const BorderSide(color: CoresApp.amareloSolidario),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _removerEstatutoSocial,
                  icon: const Icon(Icons.delete_outline_rounded,
                      color: CoresApp.vermelhoEscuro),
                  tooltip: 'Remover Estatuto Social',
                ),
              ],
            ),
          ],
        ),
      );
    }

    // 3. Sem estatuto social
    return OutlinedButton.icon(
      onPressed: _selecionarNovoEstatutoSocial,
      icon: const Icon(Icons.upload_file_rounded, size: 18),
      label: const Text('Anexar Estatuto Social (PDF, Word ou imagem)',
          style: TextStyle(fontSize: 12)),
      style: OutlinedButton.styleFrom(
        foregroundColor: CoresApp.azulConfianca,
        side: const BorderSide(color: CoresApp.borda),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
    );
  }

  Widget _menuTile(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String texto,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: CoresApp.branco,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: CoresApp.borda),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: iconBg, borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(texto,
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w700)),
                    Text(subtitle,
                        style: const TextStyle(
                            fontSize: 11, color: CoresApp.textoSecundario)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded,
                  size: 14, color: CoresApp.textoSecundario),
            ],
          ),
        ),
      ),
    );
  }
}
