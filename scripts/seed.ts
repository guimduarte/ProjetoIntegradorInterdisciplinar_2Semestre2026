import { DynamoDBClient, ListTablesCommand } from '@aws-sdk/client-dynamodb';
import { DynamoDBDocumentClient, PutCommand } from '@aws-sdk/lib-dynamodb';
import * as fs from 'fs';
import * as path from 'path';

// Conecta ao DynamoDB usando as credenciais do seu 'aws configure'
const client = new DynamoDBClient({ region: 'us-east-1' });
const docClient = DynamoDBDocumentClient.from(client);

async function seedDatabase() {
  try {
    console.log('🔍 Buscando tabelas no DynamoDB...');
    
    // Lista as tabelas no DynamoDB para achar os nomes exatos criados pelo Sandbox
    const { TableNames } = await client.send(new ListTablesCommand({}));
    
    const userTable = TableNames?.find(name => name.startsWith('User-'));
    const serviceTable = TableNames?.find(name => name.startsWith('Service-'));

    if (!userTable || !serviceTable) {
      console.error('❌ Não foi possível encontrar as tabelas User ou Service no DynamoDB.');
      console.log('Tabelas encontradas:', TableNames);
      return;
    }

    console.log(`✅ Tabela User: ${userTable}`);
    console.log(`✅ Tabela Service: ${serviceTable}`);

    // Carrega os dados fictícios
    const mockDataPath = path.join(__dirname, 'mock_data.json');
    const mockData = JSON.parse(fs.readFileSync(mockDataPath, 'utf-8'));

    // Povoar Usuários
    console.log('\n⏳ Inserindo usuários...');
    for (const user of mockData.users) {
      const item = {
        id: `user_\({Date.now()}_\){Math.random().toString(36).substring(2, 6)}`,
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString(),
        ...user,
      };

      await docClient.send(new PutCommand({
        TableName: userTable,
        Item: item,
      }));
      console.log(`  └─ Usuário inserido: ${user.email}`);
    }

    // Povoar Serviços
    console.log('\n⏳ Inserindo serviços...');
    for (const service of mockData.services) {
      const item = {
        id: `service_\({Date.now()}_\){Math.random().toString(36).substring(2, 6)}`,
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString(),
        ...service,
      };

      await docClient.send(new PutCommand({
        TableName: serviceTable,
        Item: item,
      }));
      console.log(`  └─ Serviço inserido: ${service.titulo}`);
    }

    console.log('\n🚀 Banco de dados povoado com sucesso!');
  } catch (error) {
    console.error('❌ Erro ao povoar o banco de dados:', error);
  }
}

seedDatabase();