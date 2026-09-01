import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../shared/notifications_screen.dart';
import '../shared/profile_screen.dart';
import '../shared/ratings_screen.dart';
import 'institution_home_screen.dart';
import 'requests_screen.dart';

/// Casca de navegação do usuário 'Instituição' (ÉPICO 02 - US02.1):
/// menu inferior fixo com, no mínimo, 'Editar Perfil', 'Avaliar
/// Serviços' e 'Notificações', além da aba adicional 'Chamados'
/// específica deste perfil (ÉPICO 03).
class InstitutionShell extends StatefulWidget {
  const InstitutionShell({super.key});

  @override
  State<InstitutionShell> createState() => _InstitutionShellState();
}

class _InstitutionShellState extends State<InstitutionShell> {
  int _index = 0;

  static const _screens = [
    InstitutionHomeScreen(),
    RequestsScreen(),
    RatingsScreen(isInstituicao: true),
    NotificationsScreen(isInstituicao: true),
    ProfileScreen(isInstituicao: true),
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
          BottomNavigationBarItem(icon: Icon(Icons.inbox_outlined), label: 'Chamados'),
          BottomNavigationBarItem(icon: Icon(Icons.star_rate_rounded), label: 'Avaliações'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_none_rounded), label: 'Notificações'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), label: 'Perfil'),
        ],
        selectedItemColor: AppColors.vermelhoAcao,
        unselectedItemColor: AppColors.textoSecundario,
      ),
    );
  }
}
