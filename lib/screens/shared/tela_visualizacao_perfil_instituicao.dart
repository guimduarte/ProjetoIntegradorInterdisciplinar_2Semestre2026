import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/instituicao.dart';
import '../../services/gerenciador_sessao_usuario.dart';
import '../../services/servico_autenticacao.dart';
import '../../theme/tema_do_app.dart';
import '../../widgets/titulo_secao.dart';

/// Tela de visualização pública do perfil da Instituição (Somente Leitura).
/// Permite ao Operário conferir dados da entidade, contato, CNPJ, localização
/// e abrir o arquivo do Estatuto Social no Amazon S3 Storage.
class TelaVisualizacaoPerfilInstituicao extends StatefulWidget {
  final String? nomeOuEmailInstituicao;
  final PerfilInstituicao? instituicaoPreCarregada;

  const TelaVisualizacaoPerfilInstituicao({
    super.key,
    this.nomeOuEmailInstituicao,
    this.instituicaoPreCarregada,
  });

  @override
  State<TelaVisualizacaoPerfilInstituicao> createState() =>
      _TelaVisualizacaoPerfilInstituicaoState();
}

class _TelaVisualizacaoPerfilInstituicaoState
    extends State<TelaVisualizacaoPerfilInstituicao> {
  final _servicoAuth = ServicoAutenticacao.instancia;

  PerfilInstituicao? _instituicao;
  bool _carregando = true;
  bool _gerandoUrlS3 = false;

  @override
  void initState() {
    super.initState();
    _carregarPerfil();
  }

  Future<void> _carregarPerfil() async {
    if (widget.instituicaoPreCarregada != null) {
      setState(() {
        _instituicao = widget.instituicaoPreCarregada;
        _carregando = false;
      });
      return;
    }

    if (widget.nomeOuEmailInstituicao != null &&
        widget.nomeOuEmailInstituicao!.isNotEmpty) {
      final mapa = await _servicoAuth
          .obterPerfilInstituicaoPorNome(widget.nomeOuEmailInstituicao!);
      if (mapa != null) {
        setState(() {
          _instituicao =
              GerenciadorSessaoUsuario.converterMapParaInstituicao(mapa);
          _carregando = false;
        });
        return;
      }
    }

    setState(() => _carregando = false);
  }

  Future<void> _abrirEstatutoS3() async {
    if (_instituicao == null || _instituicao!.estatutoSocialUrl.isEmpty) return;

    final messengerContext = ScaffoldMessenger.of(context);
    setState(() => _gerandoUrlS3 = true);

    final urlDownload = await _servicoAuth
        .obterUrlDownloadEstatuto(_instituicao!.estatutoSocialUrl);

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
          content: Text('Erro ao recuperar arquivo do S3.'),
          backgroundColor: CoresApp.vermelhoEscuro,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil da Instituição'),
      ),
      body: _carregando
          ? const Center(
              child: CircularProgressIndicator(color: CoresApp.azulConfianca),
            )
          : _instituicao == null
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'Não foi possível encontrar as informações desta instituição na AWS.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: CoresApp.textoSecundario, fontSize: 13),
                    ),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 20),
                      const TituloSecao(titulo: 'Contato e Localização'),
                      const SizedBox(height: 10),
                      _cardInfo([
                        _itemLinha(
                          Icons.mail_outline_rounded,
                          'E-mail Institucional',
                          _instituicao!.emailInstitucional,
                        ),
                        const Divider(height: 16),
                        _itemLinha(
                          Icons.call_outlined,
                          'Telefone',
                          _instituicao!.telefone,
                        ),
                        const Divider(height: 16),
                        _itemLinha(
                          Icons.location_on_outlined,
                          'Localização/Endereço',
                          _instituicao!.localizacao,
                        ),
                      ]),
                      const SizedBox(height: 20),
                      const TituloSecao(titulo: 'Classificação Institucional'),
                      const SizedBox(height: 10),
                      _cardInfo([
                        _itemLinha(
                          Icons.badge_outlined,
                          'CNPJ',
                          _instituicao!.cnpj,
                        ),
                        const Divider(height: 16),
                        _itemLinha(
                          Icons.account_balance_outlined,
                          'Tipo de Entidade',
                          _instituicao!.tipos
                              .map((t) => t.texto)
                              .join(', '),
                        ),
                      ]),
                      const SizedBox(height: 20),
                      const TituloSecao(
                          titulo: 'Estatuto Social / Documentação Oficial'),
                      const SizedBox(height: 8),
                      _buildSecaoEstatuto(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
    );
  }

  Widget _buildHeader() {
    final inicial = _instituicao!.nome.trim().isNotEmpty
        ? _instituicao!.nome.trim().substring(0, 1).toUpperCase()
        : 'I';

    return Row(
      children: [
        CircleAvatar(
          radius: 34,
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
              Text(
                _instituicao!.nome,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: CoresApp.textoPrimario,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: CoresApp.vermelhoFundo,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Instituição Solidária',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: CoresApp.vermelhoEscuro,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _cardInfo(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: CoresApp.branco,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CoresApp.borda),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _itemLinha(IconData icon, String label, String valor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: CoresApp.azulConfianca),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                    fontSize: 11, color: CoresApp.textoSecundario),
              ),
              const SizedBox(height: 2),
              Text(
                valor.isNotEmpty ? valor : 'Não informado',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: CoresApp.textoPrimario,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSecaoEstatuto() {
    if (_instituicao!.estatutoSocialUrl.isNotEmpty) {
      final nomeArquivo = _instituicao!.estatutoSocialUrl.contains('_')
          ? _instituicao!.estatutoSocialUrl.split('_').last
          : _instituicao!.estatutoSocialUrl.split('/').last;

      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: CoresApp.azulFundo,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: CoresApp.azulClaro),
        ),
        child: Row(
          children: [
            const Icon(Icons.file_present_rounded, color: CoresApp.azulClaro),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nomeArquivo,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: CoresApp.azulConfianca,
                    ),
                  ),
                  const Text(
                    'Estatuto registrado no Amazon S3',
                    style: TextStyle(
                        fontSize: 10, color: CoresApp.textoSecundario),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: _gerandoUrlS3 ? null : _abrirEstatutoS3,
              icon: _gerandoUrlS3
                  ? const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: CoresApp.branco,
                      ),
                    )
                  : const Icon(Icons.download_rounded, size: 16),
              label: const Text('Visualizar', style: TextStyle(fontSize: 11)),
              style: ElevatedButton.styleFrom(
                backgroundColor: CoresApp.azulConfianca,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: CoresApp.fundoTela,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: CoresApp.borda),
      ),
      child: const Text(
        'Nenhum documento de Estatuto Social anexado por esta instituição.',
        style: TextStyle(fontSize: 12, color: CoresApp.textoSecundario),
      ),
    );
  }
}
