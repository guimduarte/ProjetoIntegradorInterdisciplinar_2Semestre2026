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
    final emailRegExp = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (!emailRegExp.hasMatch(valor)) {
      return 'E-mail inválido';
    }
    return null;
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
    
    // Algoritmo de validação simplificado
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
      return 'Telefone inválido';
    }
    return null;
  }
}
