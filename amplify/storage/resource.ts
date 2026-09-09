import { defineStorage } from '@aws-amplify/backend';

export const storage = defineStorage({
  name: 'maosAmigasStorage',
  access: (allow) => ({
    'portfolios/*': [
      allow.authenticated.to(['read', 'write']), // Operários logados podem salvar e ler
      allow.guest.to(['read']) // Visitantes podem visualizar
    ],
    'estatutos/*': [
      allow.authenticated.to(['read', 'write']),
      allow.guest.to(['read'])
    ],
  })
});