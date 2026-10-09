import 'package:flutter/material.dart';
import '../../theme/tema_do_app.dart';
import '../shared/tela_perfil.dart';
import '../shared/tela_avaliacoes.dart';
import 'operario_tela_beneficios.dart';
import 'operario_tela_servicos.dart';
import 'operario_tela_home.dart';

/// Casca de navegação do usuário 'Operário' (ÉPICO 02 - US02.1):
/// menu inferior fixo com, no mínimo, 'Editar Perfil' e 'Avaliar
/// Serviços', além da aba adicional 'Benefícios' específica deste
/// perfil.
class OperarioTela extends StatefulWidget {
  const OperarioTela({super.key});

  @override
  State<OperarioTela> createState() => _OperarioTelaState();
}

class _OperarioTelaState extends State<OperarioTela> {
  int _index = 0;

  void _mudarAba(int novoIndex) {
    setState(() => _index = novoIndex);
  }

  @override
  Widget build(BuildContext context) {
    final telasOperarios = [
      OperarioTelaHome(onMudarAba: _mudarAba),
      const OperarioTelaServicos(),
      const OperarioTelaBeneficios(),
      const TelaAvaliacoes(ehInstituicao: false),
      const TelaPerfil(ehInstituicao: false),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: telasOperarios),
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
        selectedItemColor: CoresApp.vermelhoAcao,
        unselectedItemColor: CoresApp.textoSecundario,
      ),
    );
  }
}
