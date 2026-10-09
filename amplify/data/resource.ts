import { type ClientSchema, a, defineData } from '@aws-amplify/backend';

const schema = a.schema({
  // Tabela Unificada de Usuários (Operários e Instituições)
  User: a.model({
    perfil: a.string().required(), // 'OPERARIO' ou 'INSTITUICAO'
    email: a.string().required(),
    telefone: a.string().required(),
    endereco_texto: a.string().required(),
    latitude: a.float(),
    longitude: a.float(),
    
    // Atributos exclusivos do Operário
    nome: a.string(),
    cpf: a.string(),
    escopo_operario: a.string().array(),
    nivel_operario: a.string(),
    nivel_de_experiencia_sistema: a.string(),
    quantidade_servicos_realizados: a.integer(),
    raio_atendimento_km: a.integer(),
    portfolio_url: a.string(),
    experiencias_anteriores: a.string(),
    
    // Atributos exclusivos da Instituição
    nome_instituicao: a.string(),
    cnpj: a.string(),
    tipo_entidade: a.string(),
    estatuto_social_url: a.string(),
  }).authorization(allow => [allow.publicApiKey()]),

  // Tabela de Vagas/Serviços
  Service: a.model({
    instituicao_id: a.string().required(),
    titulo: a.string().required(),
    escopo_servico: a.string(),
    complexidade: a.string(),
    descricao: a.string(),
    nivel_experiencia_exigido: a.string(),
    endereco_texto: a.string(),
    latitude: a.float(),
    longitude: a.float(),
    status_servico: a.string(),
    instituicao_nome: a.string(),
    instituicao_telefone: a.string(),
  }).authorization(allow => [allow.publicApiKey()]),

  // Tabela de Candidaturas e Triagem
  Application: a.model({
    service_id: a.string().required(),
    operario_id: a.string().required(),
    status_candidatura: a.string(),
    data_solicitacao: a.datetime(),
    resumo_operario_nome: a.string(),
    resumo_operario_escopo: a.string().array(),
    resumo_operario_nivel: a.string(),
  }).authorization(allow => [allow.publicApiKey()]),

  // Tabela de Pontuação e Benefícios
  Reward: a.model({
    operario_id: a.string().required(),
    saldo_pontos_atual: a.float(),
    historico_ganhos_json: a.json(), // Salva o histórico de serviços como um objeto JSON embutido
  }).authorization(allow => [allow.publicApiKey()]),

  // Tabela de Sustentabilidade Financeira
  Donation: a.model({
    instituicao_id: a.string().required(),
    valor_doado: a.float(),
    data_doacao: a.datetime(),
    codigo_pix_gerado: a.string(),
    status_pagamento: a.string(),
  }).authorization(allow => [allow.publicApiKey()]),
});

export type Schema = ClientSchema<typeof schema>;

export const data = defineData({
  schema,
  authorizationModes: {
    defaultAuthorizationMode: 'apiKey',
    apiKeyAuthorizationMode: { expiresInDays: 365 }
  },
});