import 'package:flutter/material.dart';
import '../../models/instituicao.dart';
import '../../models/operario.dart';
import '../../theme/app_theme.dart';
import '../../widgets/section_title.dart';
import '../tela_selecao_tipo_usuario.dart';
import '../instituicao/donate_screen.dart';

/// Tela "Editar Perfil", presente no menu inferior de ambos os
/// perfis (ÉPICO 02 - US02.1). Para a instituição, também concentra
/// o acesso direto ao menu "Ajude a Aplicação" (US02.2).
class ProfileScreen extends StatelessWidget {
  final bool isInstituicao;

  const ProfileScreen({super.key, required this.isInstituicao});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Perfil')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildAvatarHeader(),
          const SizedBox(height: 20),
          const SectionTitle(title: 'Dados cadastrais'),
          const SizedBox(height: 10),
          ...isInstituicao ? _buildCamposInstituicao() : _buildCamposOperario(),
          const SizedBox(height: 20),
          if (isInstituicao) ...[
            const SectionTitle(title: 'Configurações'),
            const SizedBox(height: 10),
            _menuTile(
              context,
              icon: Icons.volunteer_activism_rounded,
              iconColor: AppColors.amareloEscuro,
              iconBg: AppColors.amareloFundo,
              label: 'Ajude a Aplicação',
              subtitle: 'Contribua voluntariamente via Pix',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const DonateScreen()),
              ),
            ),
            const SizedBox(height: 20),
          ],
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Salvar alterações'),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const TelaSelecaoTipoUsuario()),
                (route) => false,
              ),
              icon: const Icon(Icons.logout_rounded, size: 18),
              label: const Text('Sair'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.vermelhoEscuro,
                side: const BorderSide(color: AppColors.vermelhoEscuro),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarHeader() {
    final nome = isInstituicao ? mockInstituicaoAtual.nome : mockOperarioAtual.nome;
    final subtitulo = isInstituicao ? 'Instituição' : 'Operário';
    return Row(
      children: [
        CircleAvatar(
          radius: 32,
          backgroundColor: AppColors.azulFundo,
          child: Text(
            nome.substring(0, 1).toUpperCase(),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.azulClaro,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(nome,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.vermelhoFundo,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  subtitulo,
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.vermelhoEscuro),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildCamposOperario() {
    final o = mockOperarioAtual;
    return [
      _field('Nome completo', o.nome),
      _field('E-mail', o.email),
      _field('Telefone', o.telefone),
      _field('Localização de referência', o.localizacao),
      _field('Raio de atendimento (km)', o.raioAtendimentoKm.toStringAsFixed(0)),
    ];
  }

  List<Widget> _buildCamposInstituicao() {
    final i = mockInstituicaoAtual;
    return [
      _field('Nome da instituição', i.nome),
      _field('E-mail institucional', i.emailInstitucional),
      _field('Telefone', i.telefone),
      _field('CNPJ', i.cnpj),
      _field('Localização', i.localizacao),
      _field('Tipo de entidade', i.tipos.map((t) => t.label).join(', ')),
    ];
  }

  Widget _field(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        initialValue: value,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }

  Widget _menuTile(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: AppColors.branco,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borda),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                    Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textoSecundario)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textoSecundario),
            ],
          ),
        ),
      ),
    );
  }
}
