/// Papel solidário escolhido pelo usuário ao abrir o aplicativo
/// (ÉPICO 01 - US01.1). Define todo o fluxo de cadastro, navegação
/// e telas exibidas a partir da tela de seleção inicial.
enum TipoUsuario { operario, instituicao }

//TipoUsuarioX é o nome dessa extensão
extension TipoUsuarioX on TipoUsuario {
  String get NomeDoTipo {
    switch (this) {
      case TipoUsuario.operario:
        return 'Operário';
      case TipoUsuario.instituicao:
        return 'Instituição';
    }
  }

  String get descricaoDoTipo {
    switch (this) {
      case TipoUsuario.operario:
        return 'Quero oferecer meu trabalho manual de forma solidária';
      case TipoUsuario.instituicao:
        return 'Quero publicar demandas de manutenção e reforma';
    }
  }
}
