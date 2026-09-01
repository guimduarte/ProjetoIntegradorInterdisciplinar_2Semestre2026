import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../shared/profile_screen.dart';
import '../shared/ratings_screen.dart';
import 'benefits_screen.dart';
import 'my_services_screen.dart';
import 'operario_home_screen.dart';

/// Casca de navegação do usuário 'Operário' (ÉPICO 02 - US02.1):
/// menu inferior fixo com, no mínimo, 'Editar Perfil' e 'Avaliar
/// Serviços', além da aba adicional 'Benefícios' específica deste
/// perfil.
class OperarioShell extends StatefulWidget {
  const OperarioShell({super.key});

  @override
  State<OperarioShell> createState() => _OperarioShellState();
}

class _OperarioShellState extends State<OperarioShell> {
  int _index = 0;

  static const _screens = [
    OperarioHomeScreen(),
    MyServicesScreen(),
    BenefitsScreen(),
    RatingsScreen(isInstituicao: false),
    ProfileScreen(isInstituicao: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), label: 'Serviços'),
          BottomNavigationBarItem(icon: Icon(Icons.card_giftcard_rounded), label: 'Benefícios'),
          BottomNavigationBarItem(icon: Icon(Icons.star_rate_rounded), label: 'Avaliações'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), label: 'Perfil'),
        ],
        selectedItemColor: AppColors.vermelhoAcao,
        unselectedItemColor: AppColors.textoSecundario,
      ),
    );
  }
}
