import 'package:flutter/material.dart';
import 'screens/tela_principal.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MaosSolidariasApp());
}

/// App "Mãos Solidárias": plataforma que conecta profissionais
/// autônomos (pedreiros, carpinteiros, pintores, eletricistas)
/// a serviços de manutenção e reforma solicitados por entidades
/// públicas e ONGs.
class MaosSolidariasApp extends StatelessWidget {
  const MaosSolidariasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mãos Solidárias',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const TelaPrincipal(),
    );
  }
}
