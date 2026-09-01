/// Nível de experiência do operário (ÉPICO 03/04), calculado a partir
/// do número de serviços realizados na plataforma. Define quais
/// serviços 'Difícil' e 'Avançado' o operário está apto a visualizar
/// (US04.2).
enum ExperienceLevel { iniciante, intermediario, avancado }

extension ExperienceLevelX on ExperienceLevel {
  /// Quantidade mínima de serviços realizados exigida para este nível.
  int get minServicosRealizados {
    switch (this) {
      case ExperienceLevel.iniciante:
        return 0;
      case ExperienceLevel.intermediario:
        return 3;
      case ExperienceLevel.avancado:
        return 5;
    }
  }

  String get label {
    switch (this) {
      case ExperienceLevel.iniciante:
        return '0+ serviços';
      case ExperienceLevel.intermediario:
        return '3+ serviços';
      case ExperienceLevel.avancado:
        return '5+ serviços';
    }
  }

  String get description {
    switch (this) {
      case ExperienceLevel.iniciante:
        return 'Pode se candidatar a serviços Fácil e Médio';
      case ExperienceLevel.intermediario:
        return 'Apto para serviços de nível Difícil';
      case ExperienceLevel.avancado:
        return 'Apto para serviços de nível Difícil e Avançado';
    }
  }

  static ExperienceLevel fromServicosRealizados(int servicos) {
    if (servicos >= 5) return ExperienceLevel.avancado;
    if (servicos >= 3) return ExperienceLevel.intermediario;
    return ExperienceLevel.iniciante;
  }
}
