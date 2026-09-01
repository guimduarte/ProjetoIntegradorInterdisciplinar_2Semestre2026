import 'experience_level.dart';

enum ApplicationStatus { pendente, aceita, recusada }

/// Candidatura de um operário a um serviço publicado, exibida na
/// central de chamados da instituição com a visualização restrita do
/// perfil do operário (ÉPICO 03 - US03.2).
class ServiceApplication {
  final String id;
  final String servicoTitulo;
  final String operarioNome;
  final String operarioEmail;
  final String operarioTelefone;
  final String escopoPrincipal;
  final ExperienceLevel nivelExperiencia;
  ApplicationStatus status;

  ServiceApplication({
    required this.id,
    required this.servicoTitulo,
    required this.operarioNome,
    required this.operarioEmail,
    required this.operarioTelefone,
    required this.escopoPrincipal,
    required this.nivelExperiencia,
    this.status = ApplicationStatus.pendente,
  });
}

final List<ServiceApplication> mockApplications = [
  ServiceApplication(
    id: 'ap1',
    servicoTitulo: 'Pintura do salão comunitário',
    operarioNome: 'Marta Souza',
    operarioEmail: 'marta.souza@email.com',
    operarioTelefone: '(11) 91234-5678',
    escopoPrincipal: 'Pintura',
    nivelExperiencia: ExperienceLevel.intermediario,
  ),
  ServiceApplication(
    id: 'ap2',
    servicoTitulo: 'Pintura do salão comunitário',
    operarioNome: 'Felipe Nogueira',
    operarioEmail: 'felipe.nogueira@email.com',
    operarioTelefone: '(11) 99876-5432',
    escopoPrincipal: 'Pintura',
    nivelExperiencia: ExperienceLevel.iniciante,
  ),
  ServiceApplication(
    id: 'ap3',
    servicoTitulo: 'Montagem de estantes na biblioteca comunitária',
    operarioNome: 'João Ricardo',
    operarioEmail: 'joao.ricardo@email.com',
    operarioTelefone: '(11) 98888-1122',
    escopoPrincipal: 'Instalação de móveis/eletros',
    nivelExperiencia: ExperienceLevel.avancado,
  ),
];

class AppNotification {
  final String titulo;
  final String mensagem;
  final String tempo;
  final bool lida;

  const AppNotification({
    required this.titulo,
    required this.mensagem,
    required this.tempo,
    this.lida = false,
  });
}

final List<AppNotification> mockNotificacoesOperario = const [
  AppNotification(
    titulo: 'Novo serviço no seu raio',
    mensagem: '"Limpeza pós-obra do refeitório" está a 2,3 km de você.',
    tempo: 'há 10 min',
  ),
  AppNotification(
    titulo: 'Candidatura aceita',
    mensagem: 'A Abrigo Novo Amanhecer aceitou sua candidatura para "Instalação de portas".',
    tempo: 'há 2 h',
  ),
  AppNotification(
    titulo: 'Pontos creditados',
    mensagem: 'Você ganhou 90 pontos pelo serviço "Reforma de piso da sala de aula".',
    tempo: 'ontem',
    lida: true,
  ),
];

final List<AppNotification> mockNotificacoesInstituicao = const [
  AppNotification(
    titulo: 'Nova candidatura recebida',
    mensagem: 'João Ricardo se candidatou para "Montagem de estantes na biblioteca".',
    tempo: 'há 30 min',
  ),
  AppNotification(
    titulo: 'Serviço concluído',
    mensagem: 'Carlos Alberto marcou "Reparo em vazamento de cozinha" como concluído.',
    tempo: 'há 5 h',
    lida: true,
  ),
];
