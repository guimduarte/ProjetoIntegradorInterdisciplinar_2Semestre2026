import 'package:flutter/material.dart';
import 'screens/tela_selecao_tipo_usuario.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MaosSolidariasApp());
}

/// App "Mãos Solidárias": plataforma que conecta operários voluntários
/// (pedreiros, carpinteiros, pintores, eletricistas) a instituições
/// sociais (ONGs, igrejas e causas sociais) que precisam de serviços
/// de manutenção e reforma.
///
/// O fluxo inicial sempre parte da seleção de papel solidário
/// (Operário ou Instituição), conforme ÉPICO 01 - US01.1 da
/// documentação do projeto.
class MaosSolidariasApp extends StatelessWidget {
  const MaosSolidariasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mãos Solidárias',
      debugShowCheckedModeBanner: false,
      theme: TemaApp.temaClaro,
      home: const TelaSelecaoTipoUsuario(),
    );
  }
}
