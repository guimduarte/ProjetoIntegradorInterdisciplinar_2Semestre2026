import 'package:flutter/material.dart';
import '../models/tipo_usuario.dart';
import '../services/servico_autenticacao.dart';
import '../theme/tema_do_app.dart';
import '../widgets/card_selecao_tipo_usuario.dart';
import 'auth/tela_autenticacao_operario.dart';
import 'auth/tela_autenticacao_instituicao.dart';
import 'operario/operario_tela.dart';
import 'instituicao/instituicao_tela.dart';

/// Tela inicial do app: seleção do papel solidário do usuário (ÉPICO 01 - US01.1).
/// Se o usuário já possuir uma sessão ativa na AWS, é redirecionado automaticamente
/// para a tela principal correspondente ao seu perfil.
class TelaSelecaoTipoUsuario extends StatefulWidget {
  const TelaSelecaoTipoUsuario({super.key});

  @override
  State<TelaSelecaoTipoUsuario> createState() => _TelaSelecaoTipoUsuarioState();
}

class _TelaSelecaoTipoUsuarioState extends State<TelaSelecaoTipoUsuario> {
  bool _verificandoSessao = true;

  @override
  void initState() {
    super.initState();
    _verificarSessaoEAutoLogar();
  }

  Future<void> _verificarSessaoEAutoLogar() async {
    try {
      final tipoPerfil =
          await ServicoAutenticacao.instancia.carregarPerfilUsuarioLogado();

      if (!mounted) return;

      if (tipoPerfil == 'operario') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const OperarioTela()),
        );
        return;
      } else if (tipoPerfil == 'instituicao') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const InstituicaoTela()),
        );
        return;
      }
    } catch (erro) {
      debugPrint('Erro na verificação de auto-login: $erro');
    } finally {
      if (mounted) {
        setState(() => _verificandoSessao = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_verificandoSessao) {
      return Scaffold(
        backgroundColor: CoresApp.azulConfianca,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: CoresApp.branco,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.volunteer_activism_rounded,
                    color: CoresApp.vermelhoAcao, size: 36),
              ),
              const SizedBox(height: 20),
              const CircularProgressIndicator(
                color: CoresApp.branco,
                strokeWidth: 2.5,
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: CoresApp.azulConfianca,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Container(
                width: 84,
                height: 84,
                decoration: const BoxDecoration(
                  color: CoresApp.branco,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.volunteer_activism_rounded,
                    color: CoresApp.vermelhoAcao, size: 42),
              ),
              const SizedBox(height: 20),
              const Text(
                'Mãos Solidárias',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: CoresApp.branco,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Conectando trabalho voluntário a quem mais precisa',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFC7D3E6),
                  fontSize: 13,
                ),
              ),
              const Spacer(flex: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Como você quer participar?',
                    style: TextStyle(
                      color: CoresApp.branco,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              CardSelecaoTipoUsuario(
                icon: Icons.handyman_rounded,
                title: TipoUsuario.operario.NomeDoTipo,
                subtitle: TipoUsuario.operario.descricaoDoTipo,
                accentColor: CoresApp.vermelhoAcao,
                accentBackground: CoresApp.vermelhoFundo,
                onTap: () => _selecionarTipoUsuario(context, TipoUsuario.operario),
              ),
              const SizedBox(height: 12),
              CardSelecaoTipoUsuario(
                icon: Icons.apartment_rounded,
                title: TipoUsuario.instituicao.NomeDoTipo,
                subtitle: TipoUsuario.instituicao.descricaoDoTipo,
                accentColor: CoresApp.amareloEscuro,
                accentBackground: CoresApp.amareloFundo,
                onTap: () => _selecionarTipoUsuario(context, TipoUsuario.instituicao),
              ),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }

  void _selecionarTipoUsuario(BuildContext context, TipoUsuario tipo) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => tipo == TipoUsuario.operario
            ? const TelaAutenticacaoOperario()
            : const TelaAutenticacaoInstituicao(),
      ),
    );
  }
}
