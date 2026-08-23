import 'package:flutter/material.dart';
import '../models/profissional.dart';
import '../theme/app_theme.dart';
import '../widgets/item_categoria.dart';
import '../widgets/card_profissional.dart';
import 'tela_servicos.dart';

/// Tela inicial: apresenta busca, indicador de impacto social,
/// categorias de serviço e profissionais em destaque.
class TelaPrincipal extends StatelessWidget {
  const TelaPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _construirCabecalho(context),
              _construirBanner(),
              _construirSecaoCategoria(context),
              _construirSecaoProfissionaisDestaque(),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _construirBottomNav(context, currentIndex: 0),
    );
  }

  Widget _construirCabecalho(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
      decoration: const BoxDecoration(
        color: AppColors.azulConfianca,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row( // ROW DO TOPO (BOTÃO MENU LATERAL, TÍTULO DO APP E BOTÃO NOTIFICAÇÕES)
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.menu_rounded, color: AppColors.branco),
              const Text(
                'Mãos Solidárias',
                style: TextStyle(
                  color: AppColors.branco,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.notifications_none_rounded,
                      color: AppColors.branco),
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.amareloSolidario,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '3',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.amareloEscuro,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Row( // ROW DO LOCAL (SÃO BERNARDO DO CAMPO, SP)
            children: [
              Icon(Icons.location_on_outlined,
                  color: Color(0xFFFFC96B), size: 14),
              SizedBox(width: 4),
              Text(
                'São Bernardo do Campo, SP',
                style: TextStyle(color: Color(0xFFFFC96B), fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            decoration: InputDecoration(
              hintText: 'Buscar serviço ou profissional',
              prefixIcon: const Icon(Icons.search, color: AppColors.textoSecundario),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirBanner() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.amareloSolidario,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          children: [
            Icon(Icons.volunteer_activism_rounded,
                color: AppColors.amareloEscuro, size: 26),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Impacto solidário',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.amareloEscuro,
                    ),
                  ),
                  Text(
                    '1.240 obras entregues a ONGs este ano',
                    style: TextStyle(fontSize: 12, color: Color(0xFF633806)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _construirSecaoCategoria(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Categorias',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textoPrimario,
            ),
          ),
          const SizedBox(height: 12),
          LayoutBuilder( //Esse LayoutBuilder envolve a row que contém os ícones coloridos, para que eles reduzam de tamanho caso não haja espaço o suficiente.
            builder: (context, constraints) {
              final categorias = [
                (Icons.construction_rounded, 'Pedreiro', AppColors.vermelhoFundo, AppColors.vermelhoEscuro),
                (Icons.carpenter_rounded, 'Carpinteiro', AppColors.azulFundo, AppColors.azulClaro),
                (Icons.format_paint_rounded, 'Pintor', AppColors.amareloFundo, AppColors.amareloEscuro),
                (Icons.bolt_rounded, 'Eletricista', AppColors.vermelhoFundo, AppColors.vermelhoEscuro),
                (Icons.build_rounded, 'Técnico', AppColors.azulFundo, AppColors.azulClaro),
                (Icons.plumbing_rounded, 'Encanador', AppColors.amareloFundo, AppColors.amareloEscuro),
              ];

              const double larguraIdealPorItem = 64; // 52 do círculo + folga
              final double larguraNecessaria = larguraIdealPorItem * categorias.length;
              double scale = constraints.maxWidth / larguraNecessaria;
              scale = scale.clamp(0.65, 1.0); // nunca deixa ficar ilegível

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: categorias.map((c) {
                  final (icon, label, bg, iconColor) = c;
                  return ItemCategoria(
                    icon: icon,
                    label: label,
                    background: bg,
                    iconColor: iconColor,
                    scale: scale,
                    onTap: () => _navegarTelaServicos(context, label),
                  );
                }).toList(),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _construirSecaoProfissionaisDestaque() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Profissionais em destaque em sua região',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textoPrimario,
            ),
          ),
          const SizedBox(height: 12),
          ...mockProfessionals.take(2).map(
                (p) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: CardProfissional(profissional: p, compact: true),
                ),
              ),
        ],
      ),
    );
  }

  Widget _construirBottomNav(BuildContext context, {required int currentIndex}) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        if (index == 1) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const ServicesScreen()),
          );
        }
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
    );
  }

  void _navegarTelaServicos(BuildContext context, String category) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ServicesScreen(initialCategory: category),
      ),
    );
  }
}
