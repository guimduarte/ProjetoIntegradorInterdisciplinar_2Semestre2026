import 'package:flutter/material.dart';
import '../../models/service_application.dart';
import '../../theme/app_theme.dart';
import '../../widgets/application_card.dart';

/// Central de chamados da instituição (ÉPICO 03 - US03.2): lista as
/// candidaturas recebidas com a visualização restrita do perfil do
/// operário e as ações de aceitar/recusar.
class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  final List<ServiceApplication> _applications = mockApplications;

  @override
  Widget build(BuildContext context) {
    final pendentes = _applications.where((a) => a.status == ApplicationStatus.pendente).toList();
    final decididas = _applications.where((a) => a.status != ApplicationStatus.pendente).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Central de Chamados')),
      body: _applications.isEmpty
          ? const Center(
              child: Text('Nenhuma candidatura recebida ainda.',
                  style: TextStyle(color: AppColors.textoSecundario, fontSize: 13)),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (pendentes.isNotEmpty) ...[
                  Text('Pendentes (${pendentes.length})',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  ...pendentes.map((a) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ApplicationCard(
                          application: a,
                          onAceitar: () => _decidir(a, ApplicationStatus.aceita),
                          onRecusar: () => _decidir(a, ApplicationStatus.recusada),
                        ),
                      )),
                ],
                if (decididas.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  const Text('Já decididas',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  ...decididas.map((a) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ApplicationCard(
                          application: a,
                          onAceitar: () {},
                          onRecusar: () {},
                        ),
                      )),
                ],
              ],
            ),
    );
  }

  void _decidir(ServiceApplication a, ApplicationStatus status) {
    setState(() => a.status = status);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          status == ApplicationStatus.aceita
              ? '${a.operarioNome} foi aceito para o serviço.'
              : 'Candidatura de ${a.operarioNome} recusada.',
        ),
      ),
    );
  }
}
