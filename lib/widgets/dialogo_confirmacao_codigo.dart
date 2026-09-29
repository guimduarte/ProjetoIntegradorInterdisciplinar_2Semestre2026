import 'package:flutter/material.dart';
import '../services/servico_autenticacao.dart';
import '../theme/tema_do_app.dart';

/// Diálogo modal para inserção do código de verificação numérico de 6 dígitos
/// enviado pela AWS Cognito ao e-mail do usuário no momento do cadastro.
class DialogoConfirmacaoCodigo extends StatefulWidget {
  final String emailUsuario;

  const DialogoConfirmacaoCodigo({
    super.key,
    required this.emailUsuario,
  });

  /// Função utilitária para exibir este diálogo na tela.
  static Future<bool?> exibir({
    required BuildContext contexto,
    required String emailUsuario,
  }) {
    return showDialog<bool>(
      context: contexto,
      barrierDismissible: false,
      builder: (_) => DialogoConfirmacaoCodigo(emailUsuario: emailUsuario),
    );
  }

  @override
  State<DialogoConfirmacaoCodigo> createState() =>
      _DialogoConfirmacaoCodigoState();
}

class _DialogoConfirmacaoCodigoState extends State<DialogoConfirmacaoCodigo> {
  final _controladorCodigo = TextEditingController();
  final _servicoAuth = ServicoAutenticacao.instancia;

  bool _processandoVerificacao = false;
  bool _processandoReenvio = false;
  String? _mensagemErro;

  @override
  void dispose() {
    _controladorCodigo.dispose();
    super.dispose();
  }

  Future<void> _validarCodigoInserido() async {
    final codigoTexto = _controladorCodigo.text.trim();
    if (codigoTexto.isEmpty) {
      setState(() => _mensagemErro = 'Digite o código de verificação');
      return;
    }

    setState(() {
      _processandoVerificacao = true;
      _mensagemErro = null;
    });

    final resultado = await _servicoAuth.confirmarCodigoEmail(
      email: widget.emailUsuario,
      codigoConfirmacao: codigoTexto,
    );

    if (!mounted) return;

    setState(() => _processandoVerificacao = false);

    if (resultado.sucesso) {
      Navigator.of(context).pop(true);
    } else {
      setState(() {
        _mensagemErro =
            resultado.mensagemErro ?? 'Código de verificação inválido.';
      });
    }
  }

  Future<void> _solicitarReenvioCodigo() async {
    setState(() {
      _processandoReenvio = true;
      _mensagemErro = null;
    });

    final sucessoReenvio =
        await _servicoAuth.reenviarCodigoConfirmacao(widget.emailUsuario);

    if (!mounted) return;

    setState(() => _processandoReenvio = false);

    if (sucessoReenvio) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Um novo código foi enviado ao seu e-mail.'),
          backgroundColor: CoresApp.verdeSucesso,
        ),
      );
    } else {
      setState(() {
        _mensagemErro = 'Não foi possível reenviar o código. Tente novamente.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        'Confirmar E-mail',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enviamos um código de verificação para:',
              style: const TextStyle(fontSize: 12, color: CoresApp.textoSecundario),
            ),
            const SizedBox(height: 4),
            Text(
              widget.emailUsuario,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: CoresApp.textoPrimario,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controladorCodigo,
              keyboardType: TextInputType.number,
              maxLength: 6,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                letterSpacing: 8,
                fontWeight: FontWeight.w700,
              ),
              decoration: InputDecoration(
                hintText: '000000',
                counterText: '',
                errorText: _mensagemErro,
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: TextButton(
                onPressed: _processandoReenvio ? null : _solicitarReenvioCodigo,
                child: _processandoReenvio
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        'Reenviar código por e-mail',
                        style: TextStyle(fontSize: 12, color: CoresApp.azulClaro),
                      ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancelar', style: TextStyle(color: CoresApp.textoSecundario)),
        ),
        ElevatedButton(
          onPressed: _processandoVerificacao ? null : _validarCodigoInserido,
          child: _processandoVerificacao
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: CoresApp.branco,
                  ),
                )
              : const Text('Confirmar'),
        ),
      ],
    );
  }
}
