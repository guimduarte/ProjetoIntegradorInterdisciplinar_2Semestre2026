/// Nível de experiência do operário (ÉPICO 03/04), calculado a partir
/// do número de serviços realizados na plataforma. Define quais
/// serviços 'Difícil' e 'Avançado' o operário está apto a visualizar
/// (US04.2).
enum NivelExperiencia { iniciante, intermediario, avancado }

extension NivelExperienciaX on NivelExperiencia {
  /// Quantidade mínima de serviços realizados exigida para este nível.
  int get minServicosRealizados {
    switch (this) {
      case NivelExperiencia.iniciante:
        return 0;
      case NivelExperiencia.intermediario:
        return 3;
      case NivelExperiencia.avancado:
        return 5;
    }
  }

  String get texto {
    switch (this) {
      case NivelExperiencia.iniciante:
        return '0+ serviços';
      case NivelExperiencia.intermediario:
        return '3+ serviços';
      case NivelExperiencia.avancado:
        return '5+ serviços';
    }
  }

  String get descricao {
    switch (this) {
      case NivelExperiencia.iniciante:
        return 'Pode se candidatar a serviços Fácil e Médio';
      case NivelExperiencia.intermediario:
        return 'Apto para serviços de nível Difícil';
      case NivelExperiencia.avancado:
        return 'Apto para serviços de nível Difícil e Avançado';
    }
  }

  static NivelExperiencia deServicosRealizados(int servicos) {
    if (servicos >= 5) return NivelExperiencia.avancado;
    if (servicos >= 3) return NivelExperiencia.intermediario;
    return NivelExperiencia.iniciante;
  }
}
