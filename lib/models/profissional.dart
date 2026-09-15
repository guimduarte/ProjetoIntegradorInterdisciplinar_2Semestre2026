/// Representa um profissional autônomo que oferece serviços
/// manuais (pedreiro, carpinteiro, pintor, eletricista etc.)
/// para entidades públicas e ONGs através do aplicativo.
class Profissional {
  final String nome;
  final String especialidade;
  final double avaliacao;
  final double latitude;  // <-- ADICIONADO
  final double longitude; // <-- ADICIONADO
  final double distanciaKm; // Mantido opcional para não quebrar o seu CardProfissional
  final bool ongEstaVerificada;
  final bool ehServicoVoluntario;

  const Profissional({
    required this.nome,
    required this.especialidade,
    required this.avaliacao,
    required this.latitude,
    required this.longitude,
    this.distanciaKm = 0.0,
    this.ongEstaVerificada = false,
    this.ehServicoVoluntario = false,
  });

  String get iniciais {
    final nomes = nome.trim().split(RegExp(r'\s+'));

    if (nomes.length == 1) {
      return nomes.first[0].toUpperCase();
    }

    return '\({nomes.first[0]}\){nomes.last[0]}'.toUpperCase();
  }
}

/// Categoria de serviço manual oferecida na plataforma.
class CategoriaServico {
  final String texto;
  final String caminhoIcone;

  const CategoriaServico({required this.texto, required this.caminhoIcone});
}

/// Dados de exemplo usados para popular as telas do protótipo.
final List mockProfissionais = [
  const Profissional(
    nome: 'Carlos Alberto',
    especialidade: 'Pedreiro',
    avaliacao: 4.8,
    latitude: -23.6479, // São Caetano do Sul (Dentro do raio de 15km)
    longitude: -46.5742,
    ongEstaVerificada: true,
  ),
  const Profissional(
    nome: 'Marta Souza',
    especialidade: 'Pintora',
    avaliacao: 4.7,
    latitude: -23.5505, // Praça da Sé - SP (Fora do raio de 15km)
    longitude: -46.6333,
    ehServicoVoluntario: true,
  ),
  const Profissional(
    nome: 'João Ricardo',
    especialidade: 'Eletricista',
    avaliacao: 4.9,
    latitude: -23.6800, // São Bernardo do Campo (Dentro do raio de 15km)
    longitude: -46.5500,
    ongEstaVerificada: true,
  ),
  const Profissional(
    nome: 'Felipe Nogueira',
    especialidade: 'Carpinteiro',
    avaliacao: 4.6,
    latitude: -23.4900, // Alphaville - Barueri (Bem fora do raio de 15km)
    longitude: -46.8400,
    ehServicoVoluntario: true,
  ),
];