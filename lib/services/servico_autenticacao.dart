import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'gerenciador_sessao_usuario.dart';

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
/// (Cognito para autenticação, AppSync/GraphQL para banco de dados e S3 para arquivos).
class ServicoAutenticacao {
  //Isso é um construtor privado. o "_" é o nome dele. Em dart, é possível ter construtores nomeados, e o nome vc coloca após o "."
  ServicoAutenticacao._();
  //A razão dessa linha acima e abaixo é fazer com que haja apenas uma instância de ServicoAutenticacao no código inteiro.
  static final ServicoAutenticacao instancia = ServicoAutenticacao._();

  bool _amplifyInicializado = false;
  bool get amplifyInicializado => _amplifyInicializado;

  /// Inicializa os plugins do AWS Amplify (Auth, API GraphQL e Storage S3)
  /// com as configurações do `amplify_outputs.json`.
  Future<void> inicializarAmplify() async {
    if (_amplifyInicializado || Amplify.isConfigured) {
      _amplifyInicializado = true;
      return;
    }

    try {
      final pluginAuth = AmplifyAuthCognito();
      final pluginApi = AmplifyAPI();
      final pluginStorage = AmplifyStorageS3();

      await Amplify.addPlugins([pluginAuth, pluginApi, pluginStorage]);

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

  /// Carrega os dados reais do perfil do usuário autenticado no Cognito
  /// buscando o mapa no GraphQL AppSync e registrando no [GerenciadorSessaoUsuario].
  Future<String?> carregarPerfilUsuarioLogado() async {
    try {
      final usuarioCognito = await obterUsuarioAtualLogado();
      if (usuarioCognito == null) return null;

      // Obtém o e-mail real do usuário dos atributos do Cognito
      String emailReal = usuarioCognito.username;
      try {
        final atributos = await Amplify.Auth.fetchUserAttributes();
        for (final attr in atributos) {
          if (attr.userAttributeKey == AuthUserAttributeKey.email) {
            emailReal = attr.value;
            break;
          }
        }
      } catch (erroAtributos) {
        safePrint(
            'Aviso: Não foi possível obter os atributos de e-mail do Cognito: $erroAtributos');
      }

      final mapaUsuario = await obterPerfilUsuarioPorEmail(emailReal);

      if (mapaUsuario == null) return null;

      final perfilTipo = mapaUsuario['perfil'] as String?;

      if (perfilTipo == 'operario') {
        final perfilOperario =
            GerenciadorSessaoUsuario.converterMapParaOperario(mapaUsuario);
        GerenciadorSessaoUsuario.instancia
            .definirOperarioLogado(perfilOperario);
      } else if (perfilTipo == 'instituicao') {
        final perfilInstituicao =
            GerenciadorSessaoUsuario.converterMapParaInstituicao(mapaUsuario);
        GerenciadorSessaoUsuario.instancia
            .definirInstituicaoLogada(perfilInstituicao);
      }

      return perfilTipo;
    } catch (erro) {
      safePrint('Erro ao carregar perfil do usuário logado: $erro');
      return null;
    }
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
      return const ResultadoAutenticacao(
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
        // Busca e popula os dados reais do perfil no GerenciadorSessaoUsuario
        final tipoPerfil = await carregarPerfilUsuarioLogado();

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

  /// Envia um arquivo de portfólio (PDF, Word, Imagem) para a pasta `portfolios/*` do Amazon S3 Storage.
  /// Compatível com Flutter Web, Android, iOS e Desktop.
  Future<String?> enviarArquivoPortfolioParaS3({
    required String nomeOriginalArquivo,
    String? caminhoArquivoLocal,
    Uint8List? bytesArquivo,
  }) async {
    try {
      final nomeUnico =
          '${DateTime.now().millisecondsSinceEpoch}_$nomeOriginalArquivo';
      final caminhoS3 = 'portfolios/$nomeUnico';

      AWSFile awsFile;
      if (bytesArquivo != null) {
        awsFile = AWSFile.fromData(bytesArquivo);
      } else if (caminhoArquivoLocal != null && caminhoArquivoLocal.isNotEmpty) {
        awsFile = AWSFile.fromPath(caminhoArquivoLocal);
      } else {
        safePrint('Aviso: Nenhum dado de arquivo (bytes ou caminho) fornecido.');
        return null;
      }

      final resultadoUpload = await Amplify.Storage.uploadFile(
        localFile: awsFile,
        path: StoragePath.fromString(caminhoS3),
      ).result.timeout(const Duration(seconds: 25));

      safePrint(
          'Arquivo de portfólio enviado para o S3 com sucesso: ${resultadoUpload.uploadedItem.path}');
      return resultadoUpload.uploadedItem.path;
    } catch (erro) {
      safePrint('Erro ao fazer upload do portfólio no Amazon S3: $erro');
      return null;
    }
  }

  /// Obtém a URL pública/assinada temporária para visualizar ou baixar um arquivo do S3 Storage.
  Future<String?> obterUrlDownloadPortfolio(String caminhoS3) async {
    try {
      final resultado = await Amplify.Storage.getUrl(
        path: StoragePath.fromString(caminhoS3),
        options: const StorageGetUrlOptions(
          pluginOptions: S3GetUrlPluginOptions(
            expiresIn: Duration(hours: 1),
          ),
        ),
      ).result;
      return resultado.url.toString();
    } catch (erro) {
      safePrint('Erro ao gerar URL do arquivo no S3: $erro');
      return null;
    }
  }

  /// Envia um arquivo de Estatuto Social (PDF, Word, Imagem) para a pasta `estatutos/*` do Amazon S3 Storage.
  Future<String?> enviarEstatutoSocialParaS3({
    required String nomeOriginalArquivo,
    String? caminhoArquivoLocal,
    Uint8List? bytesArquivo,
  }) async {
    try {
      final nomeUnico =
          '${DateTime.now().millisecondsSinceEpoch}_$nomeOriginalArquivo';
      final caminhoS3 = 'estatutos/$nomeUnico';

      AWSFile awsFile;
      if (bytesArquivo != null) {
        awsFile = AWSFile.fromData(bytesArquivo);
      } else if (caminhoArquivoLocal != null && caminhoArquivoLocal.isNotEmpty) {
        awsFile = AWSFile.fromPath(caminhoArquivoLocal);
      } else {
        safePrint('Aviso: Nenhum dado de arquivo fornecido para Estatuto Social.');
        return null;
      }

      final resultadoUpload = await Amplify.Storage.uploadFile(
        localFile: awsFile,
        path: StoragePath.fromString(caminhoS3),
      ).result.timeout(const Duration(seconds: 25));

      safePrint(
          'Estatuto Social enviado para o S3 com sucesso: ${resultadoUpload.uploadedItem.path}');
      return resultadoUpload.uploadedItem.path;
    } catch (erro) {
      safePrint('Erro ao fazer upload do Estatuto Social no Amazon S3: $erro');
      return null;
    }
  }

  /// Obtém a URL pública/assinada temporária do Estatuto Social no S3 Storage.
  Future<String?> obterUrlDownloadEstatuto(String caminhoS3) async {
    return obterUrlDownloadPortfolio(caminhoS3);
  }

  /// Atualiza os dados de perfil de um operário na tabela `User` do AppSync GraphQL.
  Future<bool> atualizarPerfilUsuarioNoBanco({
    required String id,
    String? nome,
    String? telefone,
    String? enderecoTexto,
    int? raioAtendimentoKm,
    List<String>? escopoOperario,
    String? experienciasAnteriores,
    String? portfolioUrl,
    double? latitude,
    double? longitude,
  }) async {
    try {
      const mutacaoAtualizarUsuarioGraphQL = '''
        mutation AtualizarUsuario(\$input: UpdateUserInput!) {
          updateUser(input: \$input) {
            id
            nome
            telefone
            endereco_texto
            raio_atendimento_km
            escopo_operario
            experiencias_anteriores
            portfolio_url
            latitude
            longitude
          }
        }
      ''';

      final dadosEntradaMap = <String, dynamic>{
        'id': id,
        if (nome != null) 'nome': nome.trim(),
        if (telefone != null) 'telefone': telefone,
        if (enderecoTexto != null) 'endereco_texto': enderecoTexto.trim(),
        if (raioAtendimentoKm != null) 'raio_atendimento_km': raioAtendimentoKm,
        if (escopoOperario != null) 'escopo_operario': escopoOperario,
        if (experienciasAnteriores != null)
          'experiencias_anteriores': experienciasAnteriores.trim(),
        if (portfolioUrl != null) 'portfolio_url': portfolioUrl,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
      };

      final requisicaoGraphQL = GraphQLRequest<String>(
        document: mutacaoAtualizarUsuarioGraphQL,
        variables: {'input': dadosEntradaMap},
      );

      final resposta = await Amplify.API
          .mutate(request: requisicaoGraphQL)
          .response
          .timeout(const Duration(seconds: 15));

      if (resposta.hasErrors) {
        safePrint(
            'Erros no GraphQL ao atualizar usuário no DynamoDB: ${resposta.errors}');
        return false;
      }

      safePrint('Perfil de usuário atualizado no DynamoDB com sucesso!');
      await carregarPerfilUsuarioLogado();
      return true;
    } catch (erro) {
      safePrint('Erro ao atualizar perfil no banco de dados DynamoDB: $erro');
      return false;
    }
  }

  /// Atualiza os dados de perfil de uma instituição na tabela `User` do AppSync GraphQL.
  Future<bool> atualizarPerfilInstituicaoNoBanco({
    required String id,
    String? nomeInstituicao,
    String? telefone,
    String? enderecoTexto,
    String? tipoEntidade,
    String? estatutoSocialUrl,
    double? latitude,
    double? longitude,
  }) async {
    try {
      const mutacaoAtualizarInstituicaoGraphQL = '''
        mutation AtualizarInstituicao(\$input: UpdateUserInput!) {
          updateUser(input: \$input) {
            id
            nome_instituicao
            telefone
            endereco_texto
            tipo_entidade
            estatuto_social_url
            latitude
            longitude
          }
        }
      ''';

      final dadosEntradaMap = <String, dynamic>{
        'id': id,
        if (nomeInstituicao != null) 'nome_instituicao': nomeInstituicao.trim(),
        if (telefone != null) 'telefone': telefone,
        if (enderecoTexto != null) 'endereco_texto': enderecoTexto.trim(),
        if (tipoEntidade != null) 'tipo_entidade': tipoEntidade,
        if (estatutoSocialUrl != null) 'estatuto_social_url': estatutoSocialUrl,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
      };

      final requisicaoGraphQL = GraphQLRequest<String>(
        document: mutacaoAtualizarInstituicaoGraphQL,
        variables: {'input': dadosEntradaMap},
      );

      final resposta = await Amplify.API
          .mutate(request: requisicaoGraphQL)
          .response
          .timeout(const Duration(seconds: 15));

      if (resposta.hasErrors) {
        safePrint(
            'Erros no GraphQL ao atualizar instituição no DynamoDB: ${resposta.errors}');
        return false;
      }

      safePrint('Perfil de instituição atualizado no DynamoDB com sucesso!');
      await carregarPerfilUsuarioLogado();
      return true;
    } catch (erro) {
      safePrint('Erro ao atualizar instituição no banco de dados DynamoDB: $erro');
      return false;
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
    String? portfolioUrl,
    String? nomeInstituicao,
    String? cnpj,
    String? tipoEntidade,
    String? estatutoSocialUrl,
    double? latitude,
    double? longitude,
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
            portfolio_url
            estatuto_social_url
            latitude
            longitude
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
        if (portfolioUrl != null && portfolioUrl.isNotEmpty)
          'portfolio_url': portfolioUrl,
        if (nomeInstituicao != null && nomeInstituicao.isNotEmpty)
          'nome_instituicao': nomeInstituicao,
        if (cnpj != null && cnpj.isNotEmpty) 'cnpj': cnpj,
        if (tipoEntidade != null && tipoEntidade.isNotEmpty)
          'tipo_entidade': tipoEntidade,
        if (estatutoSocialUrl != null && estatutoSocialUrl.isNotEmpty)
          'estatuto_social_url': estatutoSocialUrl,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
      };

      final requisicaoGraphQL = GraphQLRequest<String>(
        document: mutacaoCriarUsuarioGraphQL,
        variables: {'input': dadosEntradaMap},
      );

      final resposta = await Amplify.API
          .mutate(request: requisicaoGraphQL)
          .response
          .timeout(const Duration(seconds: 15));

      if (resposta.hasErrors) {
        safePrint(
            'Erros no GraphQL ao salvar usuário no DynamoDB: ${resposta.errors}');
        return false;
      }

      safePrint('Perfil de usuário salvo no banco de dados DynamoDB com sucesso!');
      await carregarPerfilUsuarioLogado();
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
              portfolio_url
              estatuto_social_url
              latitude
              longitude
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

      final resposta = await Amplify.API
          .query(request: requisicaoGraphQL)
          .response
          .timeout(const Duration(seconds: 10));

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
      GerenciadorSessaoUsuario.instancia.limparSessao();
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
