import 'package:flutter/material.dart';
import '../models/profissional.dart';
import '../theme/tema_do_app.dart';
import '../widgets/card_profissional.dart';
import '../utils/location_utils.dart';

/// Tela que lista os profissionais/serviços disponíveis, com
/// filtro por categoria e opção de solicitar atendimento.
class TelaServicosDisponiveis extends StatefulWidget {
  final String categoriaInicial;

  const TelaServicosDisponiveis({super.key, this.categoriaInicial = 'Todos'});

  @override
  State<TelaServicosDisponiveis> createState() => _TelaServicosDisponiveisState();
}

class _TelaServicosDisponiveisState extends State<TelaServicosDisponiveis> {
  static const List<String> _categorias = [
    'Todos',
    'Pedreiro',
    'Carpinteiro',
    'Pintor',
    'Eletricista',
  ];

  late String _categoriaSelecionada = widget.categoriaInicial;

  List get _profissionaisFiltrados {
    // 1. Simulando a localização da Instituição (ONG Acolher ABC)
    const double minhaLatitude = -23.6938;
    const double minhaLongitude = -46.5644;
    const double raioMaximoKm = 15.0; // Raio de busca de 15km

    return mockProfissionais.where((p) {
      // 2. Filtro de Categoria (o seu original)
      final categoriaBate = _categoriaSelecionada == 'Todos' ||
          p.especialidade.toLowerCase().contains(
                _categoriaSelecionada.toLowerCase().substring(0, 5),
              );

      // 3. Filtro de Distância (Haversine)
      final distancia = calcularDistancia(
        minhaLatitude,
        minhaLongitude,
        p.latitude,  
        p.longitude, 
      );

      // 4. Retorna true só se bater a categoria E a distância
      return categoriaBate && (distancia <= raioMaximoKm);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Serviços disponíveis'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.tune_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Filtrar por especialidade',
                prefixIcon:
                    const Icon(Icons.search, color: CoresApp.textoSecundario),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              itemCount: _categorias.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final categoria = _categorias[index];
                final selecionado = categoria == _categoriaSelecionada;
                return ChoiceChip(
                  label: Text(categoria),
                  selected: selecionado,
                  onSelected: (_) => setState(() => _categoriaSelecionada = categoria),
                  selectedColor: CoresApp.vermelhoAcao,
                  backgroundColor: CoresApp.branco,
                  labelStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: selecionado ? CoresApp.branco : CoresApp.azulConfianca,
                  ),
                  shape: StadiumBorder(
                    side: BorderSide(
                      color: selecionado ? CoresApp.vermelhoAcao : CoresApp.azulConfianca,
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              itemCount: _profissionaisFiltrados.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final profissional = _profissionaisFiltrados[index];
                return CardProfissional(
                  profissional: profissional,
                  onRequest: () => _showRequestConfirmation(context, profissional),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: CoresApp.vermelhoAcao,
        foregroundColor: CoresApp.branco,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Oferecer meu serviço'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) Navigator.of(context).pop();
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.handyman_outlined),
            label: 'Serviços',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_rounded),
            label: 'Pedidos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }

  void _showRequestConfirmation(BuildContext context, Profissional professional) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Solicitar ${professional.especialidade.toLowerCase()}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              'Sua entidade será conectada com ${professional.nome}. '
              'Confirme para enviar os detalhes da obra.',
              style: const TextStyle(color: CoresApp.textoSecundario, fontSize: 13),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Confirmar solicitação'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
