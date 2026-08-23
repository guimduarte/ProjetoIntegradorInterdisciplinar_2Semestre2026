import 'package:flutter/material.dart';

/// Paleta de cores da marca "Mãos Solidárias".
///
/// - Azul confiança: cabeçalhos, navegação, elementos institucionais.
/// - Vermelho ação: botões primários e chamadas para ação.
/// - Amarelo solidário: destaques, avaliações e selos de impacto social.
/// - Branco: fundo e superfícies de conteúdo.
class AppColors {
  AppColors._();

  static const Color azulConfianca = Color(0xFF14213D);
  static const Color azulClaro = Color(0xFF0C447C);
  static const Color azulFundo = Color(0xFFE6F1FB);

  static const Color vermelhoAcao = Color(0xFFE63946);
  static const Color vermelhoEscuro = Color(0xFFA32D2D);
  static const Color vermelhoFundo = Color(0xFFFCEBEB);

  static const Color amareloSolidario = Color(0xFFFFB703);
  static const Color amareloEscuro = Color(0xFF854F0B);
  static const Color amareloFundo = Color(0xFFFAEEDA);

  static const Color branco = Color(0xFFFFFFFF);
  static const Color fundoTela = Color(0xFFF7F7F9);
  static const Color textoPrimario = Color(0xFF14213D);
  static const Color textoSecundario = Color(0xFF6B7280);
  static const Color borda = Color(0xFFE5E7EB);
}

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    final base = ThemeData.light(useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.fundoTela,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.vermelhoAcao,
        secondary: AppColors.azulConfianca,
        tertiary: AppColors.amareloSolidario,
        surface: AppColors.branco,
        error: AppColors.vermelhoEscuro,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.azulConfianca,
        foregroundColor: AppColors.branco,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.branco,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      textTheme: base.textTheme.apply(
        bodyColor: AppColors.textoPrimario,
        displayColor: AppColors.textoPrimario,
        fontFamily: 'Roboto',
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.vermelhoAcao,
          foregroundColor: AppColors.branco,
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
        fillColor: AppColors.branco,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(color: AppColors.textoSecundario, fontSize: 13),
      ),
      cardTheme: CardThemeData(
        color: AppColors.branco,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.borda),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.branco,
        selectedItemColor: AppColors.vermelhoAcao,
        unselectedItemColor: AppColors.textoSecundario,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      dividerColor: AppColors.borda,
    );
  }
}
