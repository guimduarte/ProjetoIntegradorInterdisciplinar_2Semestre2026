import 'package:flutter/foundation.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'servico_autenticacao.dart';

/// Item de avaliação recebido por um usuário (Operário ou Instituição).
class AvaliacaoItem {
  final String id;
  final String autor;
  final int estrelas;
  final String comentario;
  final String operarioEmail;
  final DateTime data;

  const AvaliacaoItem({
    required this.id,
    required this.autor,
    required this.estrelas,
    required this.comentario,
    required this.operarioEmail,
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'autor': autor,
      'estrelas': estrelas,
      'comentario': comentario,
      'operarioEmail': operarioEmail,
      'data': data.toIso8601String(),
    };
  }

  factory AvaliacaoItem.fromMap(Map<String, dynamic> map) {
    return AvaliacaoItem(
      id: map['id'] as String? ?? '',
      autor: map['autor'] as String? ?? 'Instituição Solidária',
      estrelas: (map['estrelas'] as num?)?.toInt() ?? 5,
      comentario: map['comentario'] as String? ?? '',
      operarioEmail: map['operarioEmail'] as String? ?? '',
      data: map['data'] != null
          ? DateTime.tryParse(map['data'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

/// Serviço responsável pelo gerenciamento de avaliações prestadas e recebidas
/// no aplicativo, mantendo o cálculo da nota média de reputação.
class ServicoAvaliacoes extends ChangeNotifier {
  ServicoAvaliacoes._();
  static final ServicoAvaliacoes instancia = ServicoAvaliacoes._();

  final Map<String, List<AvaliacaoItem>> _avaliacoesPorEmail = {};

  /// Salva uma nova avaliação realizada por uma instituição para um operário
  Future<bool> salvarAvaliacaoOperario({
    required String operarioEmail,
    required String instituicaoNome,
    required int estrelas,
    required String comentario,
  }) async {
    try {
      final item = AvaliacaoItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        autor: instituicaoNome,
        estrelas: estrelas,
        comentario: comentario.trim(),
        operarioEmail: operarioEmail.trim(),
        data: DateTime.now(),
      );

      _avaliacoesPorEmail.putIfAbsent(operarioEmail.trim(), () => []).add(item);
      notifyListeners();

      safePrint('Avaliação do operário $operarioEmail gravada com sucesso!');
      return true;
    } catch (e) {
      safePrint('Erro ao salvar avaliação do operário: $e');
      return false;
    }
  }

  /// Recupera as avaliações reais recebidas por um operário específico
  List<AvaliacaoItem> obterAvaliacoesDoOperario(String emailOperario) {
    return _avaliacoesPorEmail[emailOperario.trim()] ?? [];
  }

  /// Calcula a nota média ponderada do operário (padrão 5.0 se ainda não avaliado)
  double calcularMediaOperario(String emailOperario) {
    final lista = obterAvaliacoesDoOperario(emailOperario);
    if (lista.isEmpty) return 5.0;
    final somaEstrelas = lista.fold<int>(0, (total, a) => total + a.estrelas);
    return somaEstrelas / lista.length;
  }
}
