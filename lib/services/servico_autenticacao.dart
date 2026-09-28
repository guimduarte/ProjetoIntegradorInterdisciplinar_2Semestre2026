import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_api/amplify_api.dart';

/// Classe que encapsula o resultado das operações de cadastro e login.
class ResultadoAutenticacao {
  final bool sucesso;
  final String? mensagemErro;
  final bool requerConfirmacaoCodigo;
  final String? perfilUsuario; // 'operario' ou 'instituicao'

  const ResultadoAutenticacao({
    required this.sucesso,
    this.mensagemErro,
    this.requerConfirmacaoCodigo = false,
    this.perfilUsuario,
  });
}

/// Serviço responsável pela integração completa com o AWS Amplify
/// (Cognito para autenticação e AppSync/GraphQL para banco de dados).
class ServicoAutenticacao {
  ServicoAutenticacao._();
  static final ServicoAutenticacao instancia = ServicoAutenticacao._();

  bool _amplifyInicializado = false;
  bool get amplifyInicializado => _amplifyInicializado;

  /// Inicializa os plugins do AWS Amplify com as configurações do `amplify_outputs.json`.
  Future<void> inicializarAmplify() async {
    if (_amplifyInicializado || Amplify.isConfigured) {
      _amplifyInicializado = true;
      return;
    }

    try {
      final pluginAuth = AmplifyAuthCognito();
      final pluginApi = AmplifyAPI();

      await Amplify.addPlugins([pluginAuth, pluginApi]);

      final stringConfiguracaoOutputs =
          await rootBundle.loadString('amplify_outputs.json');
      await Amplify.configure(stringConfiguracaoOutputs);

      _amplifyInicializado = true;
      safePrint('AWS Amplify configurado com sucesso!');
    } catch (erro) {
      safePrint('Erro ao inicializar AWS Amplify: $erro');
      rethrow;
    }
  }

  /// Verifica se existe uma sessão ativa no dispositivo.
  Future<AuthUser?> obterUsuarioAtualLogado() async {
    try {
      final sessao = await Amplify.Auth.fetchAuthSession();
      if (sessao.isSignedIn) {
        return await Amplify.Auth.getCurrentUser();
      }
    } catch (erro) {
      safePrint('Erro ao verificar sessão ativa: $erro');
    }
    return null;
  }

  /// Inicia o processo de cadastro do usuário no AWS Cognito (E-mail e Senha).
  Future<ResultadoAutenticacao> cadastrarUsuarioCognito({
    required String email,
    required String senha,
  }) async {
    try {
      final opcoes = SignUpOptions(
        userAttributes: {
          AuthUserAttributeKey.email: email.trim(),
        },
      );

      final resultado = await Amplify.Auth.signUp(
        username: email.trim(),
        password: senha,
        options: opcoes,
      );

      final precisaConfirmar = !resultado.isSignUpComplete;
      return ResultadoAutenticacao(
        sucesso: true,
        requerConfirmacaoCodigo: precisaConfirmar,
      );
    } on AuthException catch (erro) {
      safePrint('Erro no cadastro Cognito: ${erro.message}');
      return ResultadoAutenticacao(
        sucesso: false,
        mensagemErro: _traduzirMensagemErroAuth(erro.message),
      );
    } catch (erro) {
      safePrint('Erro inesperado no cadastro: $erro');
      return ResultadoAutenticacao(
        sucesso: false,
        mensagemErro: 'Erro inesperado ao realizar cadastro. Tente novamente.',
      );
    }
  }

  /// Valida o código de verificação numérico de 6 dígitos enviado por e-mail.
  Future<ResultadoAutenticacao> confirmarCodigoEmail({
    required String email,
    required String codigoConfirmacao,
  }) async {
    try {
      final resultado = await Amplify.Auth.confirmSignUp(
        username: email.trim(),
        confirmationCode: codigoConfirmacao.trim(),
      );

      return ResultadoAutenticacao(
        sucesso: resultado.isSignUpComplete,
        mensagemErro: resultado.isSignUpComplete
            ? null
            : 'Confirmação pendente. Verifique o código digitado.',
      );
    } on AuthException catch (erro) {
      safePrint('Erro ao confirmar código de e-mail: ${erro.message}');
      return ResultadoAutenticacao(
        sucesso: false,
        mensagemErro: _traduzirMensagemErroAuth(erro.message),
      );
    } catch (erro) {
      return ResultadoAutenticacao(
        sucesso: false,
        mensagemErro: 'Erro ao validar código. Tente novamente.',
      );
    }
  }

  /// Reenvia o código de confirmação para o e-mail informado.
  Future<bool> reenviarCodigoConfirmacao(String email) async {
    try {
      await Amplify.Auth.resendSignUpCode(username: email.trim());
      return true;
    } catch (erro) {
      safePrint('Erro ao reenviar código: $erro');
      return false;
    }
  }

  /// Autentica o usuário com e-mail e senha.
  Future<ResultadoAutenticacao> fazerLogin({
    required String email,
    required String senha,
  }) async {
    try {
      final resultado = await Amplify.Auth.signIn(
        username: email.trim(),
        password: senha,
      );

      if (resultado.isSignedIn) {
        // Busca o perfil do usuário no AppSync GraphQL para saber se é Operário ou Instituição
        final perfil = await obterPerfilUsuarioPorEmail(email.trim());
        final tipoPerfil = perfil?['perfil'] as String?;

        return ResultadoAutenticacao(
          sucesso: true,
          perfilUsuario: tipoPerfil,
        );
      } else if (resultado.nextStep.signInStep ==
          AuthSignInStep.confirmSignUp) {
        return const ResultadoAutenticacao(
          sucesso: false,
          requerConfirmacaoCodigo: true,
          mensagemErro:
              'E-mail ainda não confirmado. Por favor, insira o código enviado ao seu e-mail.',
        );
      } else {
        return const ResultadoAutenticacao(
          sucesso: false,
          mensagemErro: 'Não foi possível concluir o login.',
        );
      }
    } on AuthException catch (erro) {
      safePrint('Erro ao fazer login: ${erro.message}');
      return ResultadoAutenticacao(
        sucesso: false,
        mensagemErro: _traduzirMensagemErroAuth(erro.message),
      );
    } catch (erro) {
      return ResultadoAutenticacao(
        sucesso: false,
        mensagemErro: 'Erro inesperado ao fazer login. Tente novamente.',
      );
    }
  }

  /// Salva os dados completos do usuário na tabela `User` do AppSync GraphQL.
  Future<bool> salvarPerfilUsuarioNoBanco({
    required String perfil, // 'operario' ou 'instituicao'
    required String email,
    required String telefone,
    required String enderecoTexto,
    String? nome,
    String? cpf,
    List<String>? escopoOperario,
    String? nivelOperario,
    int? quantidadeServicosRealizados,
    int? raioAtendimentoKm,
    String? experienciasAnteriores,
    String? nomeInstituicao,
    String? cnpj,
    String? tipoEntidade,
  }) async {
    try {
      const mutacaoCriarUsuarioGraphQL = '''
        mutation CriarUsuario(\$input: CreateUserInput!) {
          createUser(input: \$input) {
            id
            perfil
            email
            nome
            nome_instituicao
          }
        }
      ''';

      final idUnico = DateTime.now().millisecondsSinceEpoch.toString();

      final dadosEntradaMap = <String, dynamic>{
        'id': idUnico,
        'perfil': perfil,
        'email': email.trim(),
        'telefone': telefone,
        'endereco_texto': enderecoTexto,
        if (nome != null && nome.isNotEmpty) 'nome': nome,
        if (cpf != null && cpf.isNotEmpty) 'cpf': cpf,
        if (escopoOperario != null && escopoOperario.isNotEmpty)
          'escopo_operario': escopoOperario,
        if (nivelOperario != null) 'nivel_operario': nivelOperario,
        if (quantidadeServicosRealizados != null)
          'quantidade_servicos_realizados': quantidadeServicosRealizados,
        if (raioAtendimentoKm != null)
          'raio_atendimento_km': raioAtendimentoKm,
        if (experienciasAnteriores != null && experienciasAnteriores.isNotEmpty)
          'experiencias_anteriores': experienciasAnteriores,
        if (nomeInstituicao != null && nomeInstituicao.isNotEmpty)
          'nome_instituicao': nomeInstituicao,
        if (cnpj != null && cnpj.isNotEmpty) 'cnpj': cnpj,
        if (tipoEntidade != null && tipoEntidade.isNotEmpty)
          'tipo_entidade': tipoEntidade,
      };

      final requisicaoGraphQL = GraphQLRequest<String>(
        document: mutacaoCriarUsuarioGraphQL,
        variables: {'input': dadosEntradaMap},
      );

      final resposta = await Amplify.API.mutate(request: requisicaoGraphQL).response;

      if (resposta.hasErrors) {
        safePrint('Erros no GraphQL ao salvar usuário: ${resposta.errors}');
        return false;
      }

      safePrint('Perfil de usuário salvo no banco de dados com sucesso!');
      return true;
    } catch (erro) {
      safePrint('Erro ao salvar perfil no banco de dados: $erro');
      return false;
    }
  }

  /// Busca os dados do usuário na tabela `User` filtrando pelo e-mail.
  Future<Map<String, dynamic>?> obterPerfilUsuarioPorEmail(String email) async {
    try {
      const consultaListarUsuariosGraphQL = '''
        query BuscarUsuarioPorEmail(\$filter: ModelUserFilterInput) {
          listUsers(filter: \$filter) {
            items {
              id
              perfil
              email
              nome
              nome_instituicao
              cpf
              cnpj
              telefone
              endereco_texto
              escopo_operario
              raio_atendimento_km
              quantidade_servicos_realizados
              tipo_entidade
              experiencias_anteriores
            }
          }
        }
      ''';

      final requisicaoGraphQL = GraphQLRequest<String>(
        document: consultaListarUsuariosGraphQL,
        variables: {
          'filter': {
            'email': {'eq': email.trim()}
          }
        },
      );

      final resposta = await Amplify.API.query(request: requisicaoGraphQL).response;

      if (resposta.hasErrors || resposta.data == null) {
        safePrint('Erros ao buscar usuário por e-mail: ${resposta.errors}');
        return null;
      }

      final mapaDadosJson = jsonDecode(resposta.data!) as Map<String, dynamic>;
      final itens = mapaDadosJson['listUsers']?['items'] as List<dynamic>?;

      if (itens != null && itens.isNotEmpty) {
        return itens.first as Map<String, dynamic>;
      }
    } catch (erro) {
      safePrint('Erro ao obter perfil por e-mail: $erro');
    }
    return null;
  }

  /// Encerra a sessão atual do usuário.
  Future<void> fazerLogout() async {
    try {
      await Amplify.Auth.signOut();
      safePrint('Logout realizado com sucesso.');
    } catch (erro) {
      safePrint('Erro ao fazer logout: $erro');
    }
  }

  /// Traduz mensagens de erro do AWS Cognito para português amigável.
  String _traduzirMensagemErroAuth(String mensagemOriginal) {
    if (mensagemOriginal.contains('UsernameExistsException') ||
        mensagemOriginal.contains('An account with the given email already exists')) {
      return 'Já existe uma conta cadastrada com este e-mail.';
    }
    if (mensagemOriginal.contains('InvalidPasswordException') ||
        mensagemOriginal.contains('Password does not conform')) {
      return 'A senha deve ter pelo menos 8 caracteres, contendo letras maiúsculas, minúsculas, números e símbolos.';
    }
    if (mensagemOriginal.contains('UserNotFoundException') ||
        mensagemOriginal.contains('User does not exist')) {
      return 'E-mail ou senha incorretos.';
    }
    if (mensagemOriginal.contains('NotAuthorizedException') ||
        mensagemOriginal.contains('Incorrect username or password')) {
      return 'E-mail ou senha incorretos.';
    }
    if (mensagemOriginal.contains('CodeMismatchException') ||
        mensagemOriginal.contains('Invalid verification code')) {
      return 'Código de verificação incorreto. Tente novamente.';
    }
    if (mensagemOriginal.contains('ExpiredCodeException')) {
      return 'Código de verificação expirado. Solicite um novo código.';
    }
    return 'Ocorreu um erro ao processar a solicitação: $mensagemOriginal';
  }
}
