import 'dart:async';
import 'package:flutter/material.dart';
import 'package:maos_solidarias/models/nivel_experiencia.dart';
import '../../models/candidatura_de_servico.dart';
import '../../theme/tema_do_app.dart';

class ModalControleChamado extends StatefulWidget {
  final CandidaturaDeServico candidatura;
  final double horasEstimadas;
  final Function(double horasTrabalhadas, double pontosGanhos) onEncerrar;

  const ModalControleChamado({
    super.key,
    required this.candidatura,
    this.horasEstimadas = 4.0,
    required this.onEncerrar,
  });

  static Future<void> exibir(
    BuildContext context, {
    required CandidaturaDeServico candidatura,
    double horasEstimadas = 4.0,
    required Function(double horasTrabalhadas, double pontosGanhos) onEncerrar,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => ModalControleChamado(
        candidatura: candidatura,
        horasEstimadas: horasEstimadas,
        onEncerrar: onEncerrar,
      ),
    );
  }

  @override
  State<ModalControleChamado> createState() => _ModalControleChamadoState();
}

class _ModalControleChamadoState extends State<ModalControleChamado> {
  late Stopwatch _stopwatch;
  late Timer _timer;
  bool _encerrado = false;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch()..start();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_encerrado) return;

      final limiteSegundos = (widget.horasEstimadas * 3600).toInt();
      // Se o serviço atingiu o limite estipulado de horas, encerra automaticamente
      if (_stopwatch.elapsed.inSeconds >= limiteSegundos) {
        _finalizarServico(motivoLimite: true);
      } else {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _stopwatch.stop();
    super.dispose();
  }

  String _formatarTempo(Duration duration) {
    String doisDigitos(int n) => n.toString().padLeft(2, '0');
    final horas = doisDigitos(duration.inHours);
    final minutos = doisDigitos(duration.inMinutes.remainder(60));
    final segundos = doisDigitos(duration.inSeconds.remainder(60));
    return '$horas:$minutos:$segundos';
  }

  void _finalizarServico({bool motivoLimite = false}) {
    if (_encerrado) return;
    _encerrado = true;

    _stopwatch.stop();
    _timer.cancel();

    final duracao = _stopwatch.elapsed;
    final double horasTrabalhadas =
        duracao.inSeconds > 0 ? (duracao.inSeconds / 3600.0) : 1.0;

    final double pontosBase = (horasTrabalhadas.floor()) * 2.5;
    final bool economizouUmaHora = (widget.horasEstimadas - horasTrabalhadas) >= 1.0;
    final double bonus = economizouUmaHora ? 5.0 : 0.0;
    final double totalPontos = pontosBase + bonus;

    widget.onEncerrar(horasTrabalhadas, totalPontos);
    Navigator.of(context).pop();

    _exibirResumoDialog(horasTrabalhadas, pontosBase, bonus, totalPontos, motivoLimite);
  }

  void _exibirResumoDialog(
      double horas, double base, double bonus, double total, bool motivoLimite) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(motivoLimite ? 'Limite de Tempo Atingido! ⏰' : 'Serviço Concluído! 🎉'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tempo total registrado: ${horas.toStringAsFixed(2)}h'),
            const SizedBox(height: 8),
            Text('Pontos de trabalho: +${base.toStringAsFixed(1)} pts'),
            if (bonus > 0) ...[
              const SizedBox(height: 4),
              const Text(
                'Bônus por conclusão antecipada (≥1h antes): +5.0 pts',
                style: TextStyle(
                  color: CoresApp.verdeEscuro,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
            const Divider(),
            Text(
              'Total creditado ao operário: +${total.toStringAsFixed(1)} pts',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.candidatura;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Serviço em Andamento',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: CoresApp.textoPrimario,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: CoresApp.verdeFundo,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'EM EXECUÇÃO',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: CoresApp.verdeEscuro,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            Text(c.servicoTitulo,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
            Text(
              'Prazo Estimado: ${widget.horasEstimadas.toStringAsFixed(0)} hora(s)',
              style: const TextStyle(fontSize: 12, color: CoresApp.textoSecundario),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: CoresApp.fundoTela,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: CoresApp.borda),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Operário: ${c.operarioNome}',
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  Text('E-mail: ${c.operarioEmail}',
                      style: const TextStyle(fontSize: 11, color: CoresApp.textoSecundario)),
                  Text('Telefone: ${c.operarioTelefone}',
                      style: const TextStyle(fontSize: 11, color: CoresApp.textoSecundario)),
                  Text('Nível: ${c.nivelExperiencia.texto}',
                      style: const TextStyle(fontSize: 11, color: CoresApp.textoSecundario)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  const Text('Tempo Decorrido',
                      style: TextStyle(fontSize: 12, color: CoresApp.textoSecundario)),
                  const SizedBox(height: 4),
                  Text(
                    _formatarTempo(_stopwatch.elapsed),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: CoresApp.azulConfianca,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _finalizarServico(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: CoresApp.vermelhoAcao,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.stop_circle_outlined, color: Colors.white),
                label: const Text(
                  'Encerrar Serviço',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}