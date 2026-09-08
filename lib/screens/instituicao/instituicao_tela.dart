import 'package:flutter/material.dart';
import '../../theme/tema_do_app.dart';
import '../shared/tela_perfil.dart';
import '../shared/tela_avaliacoes.dart';
import 'instituicao_tela_home.dart';
import 'instituicao_tela_chamados.dart';

/// Casca de navegação do usuário 'Instituição' (ÉPICO 02 - US02.1):
/// menu inferior fixo com, no mínimo, 'Editar Perfil', 'Avaliar
/// Serviços' e 'Notificações', além da aba adicional 'Chamados'
/// específica deste perfil (ÉPICO 03).
class InstituicaoTela extends StatefulWidget {
  const InstituicaoTela({super.key});

  @override
  State<InstituicaoTela> createState() => _InstituicaoTelaState();
}

class _InstituicaoTelaState extends State<InstituicaoTela> {
  int _index = 0;

  static const _screens = [
    InstituicaoTelaHome(),
    InstituicaoTelaChamados(),
    TelaAvaliacoes(ehInstituicao: true),
    //NotificationsScreen(isInstituicao: true),
    TelaPerfil(ehInstituicao: true),
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
          //BottomNavigationBarItem(icon: Icon(Icons.notifications_none_rounded), label: 'Notificações'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), label: 'Perfil'),
        ],
        selectedItemColor: CoresApp.vermelhoAcao,
        unselectedItemColor: CoresApp.textoSecundario,
      ),
    );
  }
}
