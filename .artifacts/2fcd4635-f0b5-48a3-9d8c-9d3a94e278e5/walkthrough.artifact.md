# Walkthrough - Conexão Backend AWS Amplify Concluída

Implementação e integração completa do frontend em Flutter com os serviços AWS Amplify Cognito (Autenticação) e AppSync GraphQL (Banco de Dados) utilizando as configurações de `amplify_outputs.json`.

> [!NOTE]
> Todos os nomes de arquivos, classes, métodos e variáveis criados por nós foram desenvolvidos em **Português**, garantindo total clareza para distinguir o código customizado do projeto das palavras-chave do Flutter/Amplify.

---

## 🛠️ Modificações Realizadas

### Configurações de Dependências e Ativos
- **[pubspec.yaml](file:///C:/Users/aliru/Desktop/maos_solidarias/pubspec.yaml)**:
  - Adicionado `amplify_api: ^2.11.0` para consultas e mutações GraphQL no AppSync.
  - Adicionado `amplify_outputs.json` como asset do aplicativo.

---

### Serviço Centralizador e Diálogo Modal
- **[NEW] [servico_autenticacao.dart](file:///C:/Users/aliru/Desktop/maos_solidarias/lib/services/servico_autenticacao.dart)**:
  - `inicializarAmplify()`: Configura `AmplifyAuthCognito()` e `AmplifyAPI()` com o `amplify_outputs.json`.
  - `cadastrarUsuarioCognito()`: Registra novo e-mail e senha no Cognito User Pool.
  - `confirmarCodigoEmail()`: Valida o código numérico de 6 dígitos enviado por e-mail.
  - `reenviarCodigoConfirmacao()`: Solicita novo código se necessário.
  - `fazerLogin()`: Realiza a autenticação de e-mail e senha no Cognito.
  - `salvarPerfilUsuarioNoBanco()`: Envia uma mutação GraphQL (`createUser`) para persistir o perfil na tabela `User` do AppSync.
  - `obterPerfilUsuarioPorEmail()`: Consulta o perfil GraphQL para identificar se o usuário é `'operario'` ou `'instituicao'`.
  - `fazerLogout()`: Encerra a sessão ativa no dispositivo.

- **[NEW] [dialogo_confirmacao_codigo.dart](file:///C:/Users/aliru/Desktop/maos_solidarias/lib/widgets/dialogo_confirmacao_codigo.dart)**:
  - Diálogo modal intuitivo para digitação do código de 6 dígitos enviado por e-mail, com tratamento de erros, estados de carregamento e botão para reenviar código.

---

### Inicialização e Fluxos de Autenticação
- **[main.dart](file:///C:/Users/aliru/Desktop/maos_solidarias/lib/main.dart)**:
  - Inicializa o `ServicoAutenticacao` antes da renderização da interface.

- **[tela_autenticacao_operario.dart](file:///C:/Users/aliru/Desktop/maos_solidarias/lib/screens/auth/tela_autenticacao_operario.dart)**:
  - Conectado o formulário de login ao `ServicoAutenticacao.instancia.fazerLogin`.
  - Conectado o formulário de cadastro em 2 etapas ao `cadastrarUsuarioCognito`, `DialogoConfirmacaoCodigo` e `salvarPerfilUsuarioNoBanco` para perfil `'operario'`.

- **[tela_autenticacao_instituicao.dart](file:///C:/Users/aliru/Desktop/maos_solidarias/lib/screens/auth/tela_autenticacao_instituicao.dart)**:
  - Conectado o formulário de login ao `ServicoAutenticacao.instancia.fazerLogin`.
  - Conectado o formulário de cadastro em 2 etapas ao `cadastrarUsuarioCognito`, `DialogoConfirmacaoCodigo` e `salvarPerfilUsuarioNoBanco` para perfil `'instituicao'`.

- **[tela_perfil.dart](file:///C:/Users/aliru/Desktop/maos_solidarias/lib/screens/shared/tela_perfil.dart)**:
  - Botão "Sair" conectado ao `ServicoAutenticacao.instancia.fazerLogout()` antes de retornar à tela de seleção inicial.

---

## 🔍 Resultados das Análises

| Arquivo | Status Análise |
| :--- | :--- |
| `servico_autenticacao.dart` | ✅ 0 Erros |
| `dialogo_confirmacao_codigo.dart` | ✅ 0 Erros |
| `main.dart` | ✅ 0 Erros |
| `tela_autenticacao_operario.dart` | ✅ 0 Erros |
| `tela_autenticacao_instituicao.dart` | ✅ 0 Erros |
| `tela_perfil.dart` | ✅ 0 Erros |
