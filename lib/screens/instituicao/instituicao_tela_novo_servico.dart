import 'package:flutter/material.dart';

// Imports necessarios pra comunicar com a AWS
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';

// Imports dos modelos gerados pelo AMplify em '/models'
import '../../models/amplify/ModelProvider.dart'; 
import '../../models/amplify/Service.dart';

import '../../models/nivel_experiencia.dart';
import '../../models/ordem_servico.dart';
import '../../services/gerenciador_sessao_usuario.dart';
import '../../theme/tema_do_app.dart';
import '../../widgets/selo_de_complexidade.dart';

/// Publicação de novo serviço pela instituição (ÉPICO 03 - US03.1):
/// título, escopo, descrição e classificação automática de
/// complexidade a partir do escopo selecionado. Os dados cadastrais
/// da instituição são incluídos automaticamente ao publicar.
class InstituicaoTelaNovoServico extends StatefulWidget {
  const InstituicaoTelaNovoServico({super.key});

  @override
  State<InstituicaoTelaNovoServico> createState() =>
      _InstituicaoTelaNovoServicoState();
}

class _InstituicaoTelaNovoServicoState
    extends State<InstituicaoTelaNovoServico> {
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _horasController = TextEditingController(text: '4');
  EscopoServico _escopo = EscopoServico.manutencaoBasica;
  bool _marcarAvancado = false;

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    _horasController.dispose();
    super.dispose();
  }

  ComplexidadeServico get _complexidadeAtual =>
      (_marcarAvancado && _escopo.permiteMarcarAvancado)
          ? ComplexidadeServico.avancado
          : _escopo.complexidadeBase;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Publicar novo serviço')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Título',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(
                  hintText: 'Ex: Pintura do salão comunitário'),
            ),
            const SizedBox(height: 16),
            const Text('Escopo',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: CoresApp.branco,
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<EscopoServico>(
                  value: _escopo,
                  isExpanded: true,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  items: EscopoServico.values
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Row(
                              children: [
                                Icon(e.icone,
                                    size: 16, color: CoresApp.azulClaro),
                                const SizedBox(width: 8),
                                Text(e.texto,
                                    style: const TextStyle(fontSize: 13)),
                              ],
                            ),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() {
                    _escopo = v!;
                    if (!_escopo.permiteMarcarAvancado) _marcarAvancado = false;
                  }),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Descrição',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            TextField(
              controller: _descricaoController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText:
                    'Descreva o serviço, o contexto e requisitos prévios',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 16),
            const Text('Duração estimada (horas)',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            TextField(
              controller: _horasController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Ex: 4'),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: CoresApp.fundoTela,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: CoresApp.borda),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.auto_awesome_rounded,
                          size: 16, color: CoresApp.azulClaro),
                      SizedBox(width: 6),
                      Text('Complexidade calculada automaticamente',
                          style: TextStyle(
                              fontSize: 11, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      SeloDeComplexidade(
                          complexidade: _complexidadeAtual, showPoints: true),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Requer operário de nível ${_complexidadeAtual.nivelMinimoExigido.texto}',
                          style: const TextStyle(
                              fontSize: 11, color: CoresApp.textoSecundario),
                        ),
                      ),
                    ],
                  ),
                  if (_escopo.permiteMarcarAvancado) ...[
                    const SizedBox(height: 8),
                    CheckboxListTile(
                      value: _marcarAvancado,
                      onChanged: (v) =>
                          setState(() => _marcarAvancado = v ?? false),
                      title: const Text(
                        'Marcar como Avançado (serviço extenso ou de alta complexidade, exige 5+ serviços)',
                        style: TextStyle(fontSize: 11),
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _publicar,
                child: const Text('Publicar Serviço'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _publicar() async {
    if (_tituloController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Informe um título para o serviço.')));
      return;
    }

    final instituicao = GerenciadorSessaoUsuario.instancia.instituicaoAtual;
    
    // Mostra um loading visual (opcional)
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Publicando serviço na AWS...')));

    try{
      // 1. Cria o objeto do AWS Amplify (Substituindo o OrdemServico local)
      final novoServicoAWS = Service(
        instituicao_id: instituicao.id.isEmpty ? 'inst_001' : instituicao.id, // Fallback para o mock atual
        titulo: _tituloController.text.trim(),
        descricao: _descricaoController.text.trim().isEmpty
            ? 'Sem descrição adicional.'
            : _descricaoController.text.trim(),
        escopo_servico: _escopo.texto, // Puxa a string da sua extension
        complexidade: _complexidadeAtual.texto, 
        nivel_experiencia_exigido: _complexidadeAtual.nivelMinimoExigido.texto,
        endereco_texto: instituicao.localizacao,
        status_servico: StatusServico.aberto.texto,
        instituicao_nome: instituicao.nome,
        // Você pode passar a latitude e longitude se já tiver
      );

      // 2. Envia a Mutação (Create) para a AWS
      final request = ModelMutations.create(novoServicoAWS);
      final response = await Amplify.API.mutate(request: request).response;

      if (response.data != null) {
        // Sucesso! Retorna 'true' para avisar a Home que um serviço foi criado
        if (mounted) Navigator.of(context).pop(true);
      }
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao salvar: \${e.message}')));
      }    
    }        
  }
}
