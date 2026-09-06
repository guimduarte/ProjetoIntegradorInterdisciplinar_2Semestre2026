import 'package:flutter/material.dart';

/// Paleta de cores da marca "Mãos Solidárias".
///
/// - Azul confiança: cabeçalhos, navegação, elementos institucionais.
/// - Vermelho ação: botões primários e chamadas para ação.
/// - Amarelo solidário: destaques, avaliações e selos de impacto social.
/// - Branco: fundo e superfícies de conteúdo.
class CoresApp {
  CoresApp._();

  static const Color azulConfianca = Color(0xFF14213D);
  static const Color azulClaro = Color(0xFF0C447C);
  static const Color azulFundo = Color(0xFFE6F1FB);

  static const Color vermelhoAcao = Color(0xFFE63946);
  static const Color vermelhoEscuro = Color(0xFFA32D2D);
  static const Color vermelhoFundo = Color(0xFFFCEBEB);

  static const Color amareloSolidario = Color(0xFFFFB703);
  static const Color amareloEscuro = Color(0xFF854F0B);
  static const Color amareloFundo = Color(0xFFFAEEDA);

  // Verde: usado para status positivos (serviço concluído, aceito,
  // disponibilidade dentro do raio) e para o nível de complexidade "Fácil".
  static const Color verdeSucesso = Color(0xFF2E9E5B);
  static const Color verdeEscuro = Color(0xFF1E6B3E);
  static const Color verdeFundo = Color(0xFFE3F5EA);

  // Roxo: reservado para o nível de complexidade "Avançado" e para
  // indicadores de gamificação/pontuação de alto nível.
  static const Color roxoAvancado = Color(0xFF6D3EA1);
  static const Color roxoEscuro = Color(0xFF4A2A70);
  static const Color roxoFundo = Color(0xFFF0E8F7);

  static const Color branco = Color(0xFFFFFFFF);
  static const Color fundoTela = Color(0xFFF7F7F9);
  static const Color textoPrimario = Color(0xFF14213D);
  static const Color textoSecundario = Color(0xFF6B7280);
  static const Color borda = Color(0xFFE5E7EB);
  static const Color bloqueado = Color(0xFF9CA3AF);
  static const Color bloqueadoFundo = Color(0xFFF0F1F3);
}

class TemaApp {
  TemaApp._();

  static ThemeData get temaClaro {
    final base = ThemeData.light(useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: CoresApp.fundoTela,
      colorScheme: base.colorScheme.copyWith(
        primary: CoresApp.vermelhoAcao,
        secondary: CoresApp.azulConfianca,
        tertiary: CoresApp.amareloSolidario,
        surface: CoresApp.branco,
        error: CoresApp.vermelhoEscuro,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: CoresApp.azulConfianca,
        foregroundColor: CoresApp.branco,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: CoresApp.branco,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      textTheme: base.textTheme.apply(
        bodyColor: CoresApp.textoPrimario,
        displayColor: CoresApp.textoPrimario,
        fontFamily: 'Roboto',
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: CoresApp.vermelhoAcao,
          foregroundColor: CoresApp.branco,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: CoresApp.branco,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(color: CoresApp.textoSecundario, fontSize: 13),
      ),
      cardTheme: CardThemeData(
        color: CoresApp.branco,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: CoresApp.borda),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: CoresApp.branco,
        selectedItemColor: CoresApp.vermelhoAcao,
        unselectedItemColor: CoresApp.textoSecundario,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      dividerColor: CoresApp.borda,
      tabBarTheme: const TabBarThemeData(
        labelColor: CoresApp.vermelhoAcao,
        unselectedLabelColor: CoresApp.textoSecundario,
        indicatorColor: CoresApp.vermelhoAcao,
        labelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        unselectedLabelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? CoresApp.vermelhoAcao
              : CoresApp.branco,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      radioTheme: const RadioThemeData(
        fillColor: WidgetStatePropertyAll(CoresApp.vermelhoAcao),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: const WidgetStatePropertyAll(CoresApp.branco),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? CoresApp.vermelhoAcao
              : CoresApp.textoSecundario,
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: CoresApp.vermelhoAcao,
        thumbColor: CoresApp.vermelhoAcao,
        inactiveTrackColor: CoresApp.borda,
        valueIndicatorColor: CoresApp.azulConfianca,
      ),
    );
  }
}
