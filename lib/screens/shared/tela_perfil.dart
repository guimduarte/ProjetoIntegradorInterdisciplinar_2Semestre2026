import 'package:flutter/material.dart';
import '../../models/instituicao.dart';
import '../../services/gerenciador_sessao_usuario.dart';
import '../../services/servico_autenticacao.dart';
import '../../theme/tema_do_app.dart';
import '../../widgets/titulo_secao.dart';
import '../tela_selecao_tipo_usuario.dart';
import '../instituicao/instituicao_tela_doacao.dart';

/// Tela "Editar Perfil", presente no menu inferior de ambos os
/// perfis (ÉPICO 02 - US02.1). Exibe e permite visualizar/editar os dados reais
/// do usuário autenticado no AWS AppSync.
class TelaPerfil extends StatelessWidget {
  final bool ehInstituicao;

  const TelaPerfil({super.key, required this.ehInstituicao});

  Future<void> _fazerLogoutESair(BuildContext context) async {
    await ServicoAutenticacao.instancia.fazerLogout();
    if (!context.mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const TelaSelecaoTipoUsuario()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        automaticallyImplyLeading: false, // desativar a seta de voltar da topbar
      ),
      body: ListenableBuilder(
        listenable: GerenciadorSessaoUsuario.instancia,
        builder: (context, _) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildAvatarHeader(),
            const SizedBox(height: 20),
            const TituloSecao(titulo: 'Dados cadastrais'),
            const SizedBox(height: 10),
            ...ehInstituicao
                ? _buildCamposInstituicao()
                : _buildCamposOperario(),
            const SizedBox(height: 20),
            if (ehInstituicao) ...[
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
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Alterações salvas com sucesso!'),
                      backgroundColor: CoresApp.verdeSucesso,
                    ),
                  );
                },
                child: const Text('Salvar alterações'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _fazerLogoutESair(context),
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
  }

  Widget _buildAvatarHeader() {
    final nome = ehInstituicao
        ? GerenciadorSessaoUsuario.instancia.instituicaoAtual.nome
        : GerenciadorSessaoUsuario.instancia.operarioAtual.nome;
    final subtitulo = ehInstituicao ? 'Instituição' : 'Operário';
    final inicial =
        nome.trim().isNotEmpty ? nome.trim().substring(0, 1).toUpperCase() : 'U';

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
    final o = GerenciadorSessaoUsuario.instancia.operarioAtual;
    return [
      _field('Nome completo', o.nome),
      _field('E-mail', o.email),
      _field('Telefone', o.telefone),
      _field('CPF', o.cpf),
      _field('Localização de referência', o.localizacao),
      _field('Raio de atendimento (km)', o.raioAtendimentoKm.toStringAsFixed(0)),
      _field('Experiências anteriores', o.experienciasAnteriores),
      _field('Escopos de trabalho', o.escopos.join(', ')),
    ];
  }

  List<Widget> _buildCamposInstituicao() {
    final i = GerenciadorSessaoUsuario.instancia.instituicaoAtual;
    return [
      _field('Nome da instituição', i.nome),
      _field('E-mail institucional', i.emailInstitucional),
      _field('Telefone', i.telefone),
      _field('CNPJ', i.cnpj),
      _field('Localização', i.localizacao),
      _field('Tipo de entidade', i.tipos.map((t) => t.texto).join(', ')),
    ];
  }

  Widget _field(String rotulo, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        key: ValueKey('$rotulo-$value'),
        initialValue: value,
        decoration: InputDecoration(labelText: rotulo),
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
