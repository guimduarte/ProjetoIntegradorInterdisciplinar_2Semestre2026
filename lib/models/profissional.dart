/// Representa um profissional autônomo que oferece serviços
/// manuais (pedreiro, carpinteiro, pintor, eletricista etc.)
/// para entidades públicas e ONGs através do aplicativo.
class Profissional {
  final String nome;
  final String especialidade;
  final double avaliacao;
  final double distanciaKm;
  final bool ongEstaVerificada;
  final bool ehServicoVoluntario;

  const Profissional({
    required this.nome,
    required this.especialidade,
    required this.avaliacao,
    required this.distanciaKm,
    this.ongEstaVerificada = false,
    this.ehServicoVoluntario = false,
  });

  String get iniciais {
    final nomes = nome.trim().split(RegExp(r'\s+'));

    if (nomes.length == 1) {
      return nomes.first[0].toUpperCase();
    }

    return '${nomes.first[0]}${nomes.last[0]}'.toUpperCase();
  }
}

/// Categoria de serviço manual oferecida na plataforma.
class CategoriaServico {
  final String texto;
  final String caminhoIcone;

  const CategoriaServico({required this.texto, required this.caminhoIcone});
}

/// Dados de exemplo usados para popular as telas do protótipo.
final List<Profissional> mockProfissionais = [
  const Profissional(
    nome: 'Carlos Alberto',
    especialidade: 'Pedreiro',
    avaliacao: 4.8,
    distanciaKm: 2.3,
    ongEstaVerificada: true,
  ),
  const Profissional(
    nome: 'Marta Souza',
    especialidade: 'Pintora',
    avaliacao: 4.7,
    distanciaKm: 3.1,
    ehServicoVoluntario: true,
  ),
  const Profissional(
    nome: 'João Ricardo',
    especialidade: 'Eletricista',
    avaliacao: 4.9,
    distanciaKm: 1.4,
    ongEstaVerificada: true,
  ),
  const Profissional(
    nome: 'Felipe Nogueira',
    especialidade: 'Carpinteiro',
    avaliacao: 4.6,
    distanciaKm: 4.0,
    ehServicoVoluntario: true,
  ),
];
