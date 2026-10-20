import 'package:flutter/services.dart';

class ValidadoresCamposCadastro {
  ValidadoresCamposCadastro._();

  static String? obrigatorio(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }

  static String? email(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'Campo obrigatório';
    }
    final emailRegExp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (!emailRegExp.hasMatch(valor)) {
      return 'E-mail inválido';
    }
    return null;
  }

  /// Validador de senha que reflete exatamente as políticas de segurança da AWS Cognito:
  /// Retorna uma lista de pré-requisitos indicando com (✓) os cumpridos e com (✗) os faltantes.
  static String? senha(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'Campo obrigatório';
    }

    final temOitoCaracteres = valor.length >= 8;
    final temMaiuscula = RegExp(r'[A-Z]').hasMatch(valor);
    final temMinuscula = RegExp(r'[a-z]').hasMatch(valor);
    final temNumero = RegExp(r'[0-9]').hasMatch(valor);
    final temSimbolo = RegExp(r'[\W_]').hasMatch(valor);

    // Se todos os critérios forem atendidos, a senha é válida
    if (temOitoCaracteres &&
        temMaiuscula &&
        temMinuscula &&
        temNumero &&
        temSimbolo) {
      return null;
    }

    // Caso contrário, monta o checklist completo de critérios
    final listaRequisitos = [
      '${temOitoCaracteres ? "✓" : "✗"} Mínimo de 8 caracteres',
      '${temMaiuscula ? "✓" : "✗"} Pelo menos 1 letra maiúscula (A-Z)',
      '${temMinuscula ? "✓" : "✗"} Pelo menos 1 letra minúscula (a-z)',
      '${temNumero ? "✓" : "✗"} Pelo menos 1 número (0-9)',
      '${temSimbolo ? "✓" : "✗"} Pelo menos 1 símbolo especial (!@#\$...)',
    ];

    return 'A senha deve cumprir os requisitos:\n${listaRequisitos.join('\n')}';
  }

  static String? cpf(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'Campo obrigatório';
    }
    final cpfLimpo = valor.replaceAll(RegExp(r'\D'), '');
    if (cpfLimpo.length != 11) {
      return 'CPF deve ter 11 dígitos';
    }
    if (RegExp(r'^(\d)\1{10}$').hasMatch(cpfLimpo)) {
      return 'CPF inválido';
    }

    int soma = 0;
    for (int i = 0; i < 9; i++) {
      soma += int.parse(cpfLimpo[i]) * (10 - i);
    }
    int resto = soma % 11;
    int digito1 = (resto < 2) ? 0 : 11 - resto;
    if (int.parse(cpfLimpo[9]) != digito1) return 'CPF inválido';

    soma = 0;
    for (int i = 0; i < 10; i++) {
      soma += int.parse(cpfLimpo[i]) * (11 - i);
    }
    resto = soma % 11;
    int digito2 = (resto < 2) ? 0 : 11 - resto;
    if (int.parse(cpfLimpo[10]) != digito2) return 'CPF inválido';

    return null;
  }

  static String? cnpj(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'Campo obrigatório';
    }
    final cnpjLimpo = valor.replaceAll(RegExp(r'\D'), '');
    if (cnpjLimpo.length != 14) {
      return 'CNPJ deve ter 14 dígitos';
    }
    if (RegExp(r'^(\d)\1{13}$').hasMatch(cnpjLimpo)) {
      return 'CNPJ inválido';
    }

    // Algoritmo de validação de CNPJ
    List<int> pesos1 = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];
    int soma = 0;
    for (int i = 0; i < 12; i++) {
      soma += int.parse(cnpjLimpo[i]) * pesos1[i];
    }
    int resto = soma % 11;
    int digito1 = (resto < 2) ? 0 : 11 - resto;
    if (int.parse(cnpjLimpo[12]) != digito1) return 'CNPJ inválido';

    List<int> pesos2 = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];
    soma = 0;
    for (int i = 0; i < 13; i++) {
      soma += int.parse(cnpjLimpo[i]) * pesos2[i];
    }
    resto = soma % 11;
    int digito2 = (resto < 2) ? 0 : 11 - resto;
    if (int.parse(cnpjLimpo[13]) != digito2) return 'CNPJ inválido';

    return null;
  }

  static String? telefone(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'Campo obrigatório';
    }
    final telLimpo = valor.replaceAll(RegExp(r'\D'), '');
    if (telLimpo.length < 10 || telLimpo.length > 11) {
      return 'Telefone inválido (deve ter DDD + 8 ou 9 dígitos)';
    }
    return null;
  }

  static String? cep(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'Campo obrigatório';
    }

    final cepLimpo = valor.replaceAll(RegExp(r'\D'), '');
    if (cepLimpo.length != 8 || RegExp(r'^(?:0{8}|00000000)$').hasMatch(cepLimpo)) {
      return 'CEP inválido';
    }

    return null;
  }
}

/// Formatador dinâmico de CEP com máscara 00000-000.
class FormatadorCep extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitos = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digitos.length > 8) {
      return oldValue;
    }

    final buffer = StringBuffer();
    for (int i = 0; i < digitos.length; i++) {
      if (i == 5) {
        buffer.write('-');
      }
      buffer.write(digitos[i]);
    }

    final textoFormatado = buffer.toString();
    return TextEditingValue(
      text: textoFormatado,
      selection: TextSelection.collapsed(offset: textoFormatado.length),
    );
  }
}

/// Formatador dinâmico de telefone que suporta tanto telefone fixo (10 dígitos: (XX) XXXX-XXXX)
/// quanto telefone celular (11 dígitos: (XX) XXXXX-XXXX).
class FormatadorTelefoneDinamico extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitos = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digitos.length > 11) {
      return oldValue;
    }

    final buffer = StringBuffer();
    for (int i = 0; i < digitos.length; i++) {
      if (i == 0) buffer.write('(');
      if (i == 2) buffer.write(') ');

      if (digitos.length <= 10) {
        if (i == 6) buffer.write('-');
      } else {
        if (i == 7) buffer.write('-');
      }
      buffer.write(digitos[i]);
    }

    final textoFormatado = buffer.toString();
    return TextEditingValue(
      text: textoFormatado,
      selection: TextSelection.collapsed(offset: textoFormatado.length),
    );
  }
}
