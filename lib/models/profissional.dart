/// Representa um profissional autônomo que oferece serviços
/// manuais (pedreiro, carpinteiro, pintor, eletricista etc.)
/// para entidades públicas e ONGs através do aplicativo.
class Profissional {
  final String nome;
  final String especialidade;
  final double avaliacao;
  final double distanciaKm;
  final bool isNgoVerified;
  final bool isVolunteerService;

  const Profissional({
    required this.nome,
    required this.especialidade,
    required this.avaliacao,
    required this.distanciaKm,
    this.isNgoVerified = false,
    this.isVolunteerService = false,
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
class ServiceCategory {
  final String label;
  final String iconAsset;

  const ServiceCategory({required this.label, required this.iconAsset});
}

/// Dados de exemplo usados para popular as telas do protótipo.
final List<Profissional> mockProfessionals = [
  const Profissional(
    nome: 'Carlos Alberto',
    especialidade: 'Pedreiro',
    avaliacao: 4.8,
    distanciaKm: 2.3,
    isNgoVerified: true,
  ),
  const Profissional(
    nome: 'Marta Souza',
    especialidade: 'Pintora',
    avaliacao: 4.7,
    distanciaKm: 3.1,
    isVolunteerService: true,
  ),
  const Profissional(
    nome: 'João Ricardo',
    especialidade: 'Eletricista',
    avaliacao: 4.9,
    distanciaKm: 1.4,
    isNgoVerified: true,
  ),
  const Profissional(
    nome: 'Felipe Nogueira',
    especialidade: 'Carpinteiro',
    avaliacao: 4.6,
    distanciaKm: 4.0,
    isVolunteerService: true,
  ),
];
