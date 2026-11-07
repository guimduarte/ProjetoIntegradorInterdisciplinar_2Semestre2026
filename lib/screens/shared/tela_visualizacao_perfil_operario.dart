import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/nivel_experiencia.dart';
import '../../models/operario.dart';
import '../../services/gerenciador_sessao_usuario.dart';
import '../../services/servico_autenticacao.dart';
import '../../theme/tema_do_app.dart';
import '../../widgets/titulo_secao.dart';

/// Tela de visualização pública do perfil do Operário (Somente Leitura).
/// Permite à Instituição conferir histórico, escopos, avaliações, contato
/// e abrir o arquivo de Portfólio no Amazon S3 Storage.
class TelaVisualizacaoPerfilOperario extends StatefulWidget {
  final String? emailOperario;
  final PerfilOperario? operarioPreCarregado;

  const TelaVisualizacaoPerfilOperario({
    super.key,
    this.emailOperario,
    this.operarioPreCarregado,
  });

  @override
  State<TelaVisualizacaoPerfilOperario> createState() =>
      _TelaVisualizacaoPerfilOperarioState();
}

class _TelaVisualizacaoPerfilOperarioState
    extends State<TelaVisualizacaoPerfilOperario> {
  final _servicoAuth = ServicoAutenticacao.instancia;

  PerfilOperario? _operario;
  bool _carregando = true;
  bool _gerandoUrlS3 = false;

  @override
  void initState() {
    super.initState();
    _carregarPerfil();
  }

  Future<void> _carregarPerfil() async {
    if (widget.operarioPreCarregado != null) {
      setState(() {
        _operario = widget.operarioPreCarregado;
        _carregando = false;
      });
      return;
    }

    if (widget.emailOperario != null && widget.emailOperario!.isNotEmpty) {
      final mapa =
          await _servicoAuth.obterPerfilUsuarioPorEmail(widget.emailOperario!);
      if (mapa != null) {
        setState(() {
          _operario = GerenciadorSessaoUsuario.converterMapParaOperario(mapa);
          _carregando = false;
        });
        return;
      }
    }

    setState(() => _carregando = false);
  }

  Future<void> _abrirPortfolioS3() async {
    if (_operario == null || _operario!.portfolioUrl.isEmpty) return;

    final messengerContext = ScaffoldMessenger.of(context);
    setState(() => _gerandoUrlS3 = true);

    final urlDownload = await _servicoAuth
        .obterUrlDownloadPortfolio(_operario!.portfolioUrl);

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
        title: const Text('Perfil do Operário'),
      ),
      body: _carregando
          ? const Center(
              child: CircularProgressIndicator(color: CoresApp.azulConfianca),
            )
          : _operario == null
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'Não foi possível encontrar as informações deste operário na AWS.',
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
                            Icons.mail_outline_rounded, 'E-mail', _operario!.email),
                        const Divider(height: 16),
                        _itemLinha(Icons.call_outlined, 'Telefone',
                            _operario!.telefone),
                        const Divider(height: 16),
                        _itemLinha(Icons.location_on_outlined, 'Localização/CEP',
                            _operario!.localizacao),
                      ]),
                      const SizedBox(height: 20),
                      const TituloSecao(titulo: 'Desempenho Profissional'),
                      const SizedBox(height: 10),
                      _cardInfo([
                        _itemLinha(
                          Icons.workspace_premium_outlined,
                          'Nível de Experiência',
                          _operario!.nivelExperiencia.texto,
                        ),
                        const Divider(height: 16),
                        _itemLinha(
                          Icons.build_circle_outlined,
                          'Serviços Realizados',
                          '${_operario!.servicosRealizados} serviço(s) concluído(s)',
                        ),
                        const Divider(height: 16),
                        _itemLinha(
                          Icons.star_border_rounded,
                          'Pontuação do Sistema',
                          '${_operario!.pontos} pontos acumulados',
                        ),
                        const Divider(height: 16),
                        _itemLinha(
                          Icons.map_outlined,
                          'Raio de Atendimento',
                          'Até ${_operario!.raioAtendimentoKm.toStringAsFixed(0)} km de distância',
                        ),
                      ]),
                      const SizedBox(height: 20),
                      const TituloSecao(titulo: 'Escopo de Trabalho'),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: _operario!.escopos.map((escopo) {
                          return Chip(
                            label: Text(
                              escopo,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: CoresApp.azulConfianca,
                              ),
                            ),
                            backgroundColor: CoresApp.azulFundo,
                            side: const BorderSide(color: CoresApp.azulClaro),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                      const TituloSecao(titulo: 'Experiências Anteriores'),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: CoresApp.fundoTela,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: CoresApp.borda),
                        ),
                        child: Text(
                          _operario!.experienciasAnteriores.isNotEmpty
                              ? _operario!.experienciasAnteriores
                              : 'Sem experiências adicionais declaradas.',
                          style: const TextStyle(
                            fontSize: 12,
                            color: CoresApp.textoPrimario,
                            height: 1.4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const TituloSecao(titulo: 'Portfólio Profissional'),
                      const SizedBox(height: 8),
                      _buildSecaoPortfolio(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 34,
          backgroundColor: CoresApp.azulFundo,
          child: Text(
            _operario!.iniciais,
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
                _operario!.nome,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: CoresApp.textoPrimario,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: CoresApp.amareloFundo,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _operario!.nivelExperiencia.texto,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: CoresApp.amareloEscuro,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.star_rounded,
                      size: 16, color: CoresApp.amareloSolidario),
                  const SizedBox(width: 2),
                  Text(
                    _operario!.avaliacaoMedia.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: CoresApp.textoPrimario,
                    ),
                  ),
                ],
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

  Widget _buildSecaoPortfolio() {
    if (_operario!.portfolioUrl.isNotEmpty) {
      final nomeArquivo = _operario!.portfolioUrl.contains('_')
          ? _operario!.portfolioUrl.split('_').last
          : _operario!.portfolioUrl.split('/').last;

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
                    'Portfólio registrado no Amazon S3',
                    style: TextStyle(
                        fontSize: 10, color: CoresApp.textoSecundario),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: _gerandoUrlS3 ? null : _abrirPortfolioS3,
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
        'Nenhum documento de portfólio anexado por este operário.',
        style: TextStyle(fontSize: 12, color: CoresApp.textoSecundario),
      ),
    );
  }
}
