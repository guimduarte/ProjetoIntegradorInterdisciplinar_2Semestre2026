import 'package:flutter/material.dart';
import '../../models/operario.dart';
import '../../theme/app_theme.dart';
import '../../widgets/step_progress_bar.dart';
import '../operario/operario_tela.dart';

/// Tela de autenticação do usuário 'Operário' (ÉPICO 01 - US01.2):
/// login simples ou cadastro completo em duas etapas (dados pessoais
/// e perfil profissional). Interface apenas — sem chamadas a backend.
class TelaAutenticacaoOperario extends StatefulWidget {
  const TelaAutenticacaoOperario({super.key});

  @override
  State<TelaAutenticacaoOperario> createState() => _TelaAutenticacaoOperarioState();
}

class _TelaAutenticacaoOperarioState extends State<TelaAutenticacaoOperario> with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(length: 2, vsync: this);

  @override
  void dispose() { // mét.odo usado para liberar recursos usado por esse tabcontroler (funcao do proprio Flutter)
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sou Operário'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Entrar'), Tab(text: 'Cadastrar')],
          labelColor: CoresApp.branco,
          unselectedLabelColor: Color(0xFFB9C3D6),
          indicatorColor: CoresApp.branco,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _OperarioLoginFormulario(),
          _OperarioCadastroFormulario(),
        ],
      ),
    );
  }
}

class _OperarioLoginFormulario extends StatelessWidget {
  const _OperarioLoginFormulario();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          const Text('Bem-vindo de volta!',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          const Text(
            'Entre com seus dados para ver os serviços disponíveis na sua região.',
            style: TextStyle(fontSize: 12, color: CoresApp.textoSecundario),
          ),
          const SizedBox(height: 20),
          const TextField(
            decoration: InputDecoration(labelText: 'E-mail', hintText: 'seuemail@exemplo.com'),
          ),
          const SizedBox(height: 12),
          const TextField(
            obscureText: true,
            decoration: InputDecoration(labelText: 'Senha'),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const OperarioTela()),
              ),
              child: const Text('Entrar'),
            ),
          ),
        ],
      ),
    );
  }
}

class _OperarioCadastroFormulario extends StatefulWidget {
  const _OperarioCadastroFormulario();

  @override
  State<_OperarioCadastroFormulario> createState() => _OperarioCadastroFormularioState();
}

class _OperarioCadastroFormularioState extends State<_OperarioCadastroFormulario> {
  int _step = 0;

  // Parte 1 — Dados pessoais
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _cpfController = TextEditingController();
  final _localizacaoController = TextEditingController();

  // Parte 2 — Perfil profissional
  bool _portfolioAnexado = false;
  final _experienciasController = TextEditingController();
  final Set<String> _escoposSelecionados = {};
  int _nivelDeclarado = 0; // 0, 3 ou 5 serviços
  double _raioKm = 10;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _cpfController.dispose();
    _localizacaoController.dispose();
    _experienciasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
          child: BarraProgressoEtapas(
            etapaAtual: _step,
            rotulosEtapas: const ['Dados pessoais', 'Perfil profissional'],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
            child: _step == 0 ? _buildStepUm() : _buildStepDois(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Row(
            children: [
              if (_step == 1)
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(() => _step = 0),
                    child: const Text('Voltar'),
                  ),
                ),
              if (_step == 1) const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {
                    if (_step == 0) {
                      setState(() => _step = 1);
                    } else {
                      _finalizarCadastro(context);
                    }
                  },
                  child: Text(_step == 0 ? 'Continuar' : 'Concluir cadastro'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepUm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Parte 1 — Dados pessoais',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
        const SizedBox(height: 14),
        TextField(
          controller: _nomeController,
          decoration: const InputDecoration(labelText: 'Nome completo'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(labelText: 'E-mail'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _telefoneController,
          decoration: const InputDecoration(labelText: 'Telefone'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _cpfController,
          decoration: const InputDecoration(labelText: 'CPF'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _localizacaoController,
          decoration: const InputDecoration(labelText: 'Localização de referência'),
        ),
        const SizedBox(height: 12),
        const TextField(
          obscureText: true,
          decoration: InputDecoration(labelText: 'Senha de acesso'),
        ),
      ],
    );
  }

  Widget _buildStepDois() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Parte 2 — Perfil profissional',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
        const SizedBox(height: 14),
        InkWell(
          onTap: () => setState(() => _portfolioAnexado = !_portfolioAnexado),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _portfolioAnexado ? CoresApp.verdeFundo : CoresApp.branco,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _portfolioAnexado ? CoresApp.verdeSucesso : CoresApp.borda,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _portfolioAnexado ? Icons.check_circle_rounded : Icons.upload_file_rounded,
                  color: _portfolioAnexado ? CoresApp.verdeSucesso : CoresApp.textoSecundario,
                ),
                const SizedBox(width: 10),
                Text(
                  _portfolioAnexado ? 'Portfólio anexado' : 'Anexar portfólio (fotos de trabalhos)',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: _experienciasController,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Experiências anteriores',
            hintText: 'Conte um pouco sobre seus trabalhos já realizados',
            alignLabelWithHint: true,
          ),
        ),
        const SizedBox(height: 16),
        const Text('Escopo de trabalho',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: escoposDisponiveis.map((escopo) {
            final selected = _escoposSelecionados.contains(escopo);
            return FilterChip(
              label: Text(escopo, style: const TextStyle(fontSize: 11)),
              selected: selected,
              onSelected: (v) => setState(() {
                v ? _escoposSelecionados.add(escopo) : _escoposSelecionados.remove(escopo);
              }),
              selectedColor: CoresApp.vermelhoFundo,
              checkmarkColor: CoresApp.vermelhoAcao,
              side: BorderSide(color: selected ? CoresApp.vermelhoAcao : CoresApp.borda),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        const Text('Nível de experiência',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
        Column(
          children: [
            _radioNivel(0, '0+ serviços realizados (iniciante)'),
            _radioNivel(3, '3+ serviços realizados'),
            _radioNivel(5, '5+ serviços realizados'),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Raio de distância máximo de atendimento: ${_raioKm.round()} km',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        ),
        Slider(
          value: _raioKm,
          min: 1,
          max: 30,
          divisions: 29,
          label: '${_raioKm.round()} km',
          onChanged: (v) => setState(() => _raioKm = v),
        ),
      ],
    );
  }

  Widget _radioNivel(int valor, String label) {
    return RadioListTile<int>(
      value: valor,
      groupValue: _nivelDeclarado,
      onChanged: (v) => setState(() => _nivelDeclarado = v ?? 0),
      title: Text(label, style: const TextStyle(fontSize: 12)),
      dense: true,
      contentPadding: EdgeInsets.zero,
    );
  }

  void _finalizarCadastro(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cadastro de operário concluído com sucesso!')),
    );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const OperarioTela()),
    );
  }
}
