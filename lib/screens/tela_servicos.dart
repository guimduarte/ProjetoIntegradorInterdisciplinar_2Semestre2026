import 'package:flutter/material.dart';
import '../models/profissional.dart';
import '../theme/app_theme.dart';
import '../widgets/card_profissional.dart';

/// Tela que lista os profissionais/serviços disponíveis, com
/// filtro por categoria e opção de solicitar atendimento.
class ServicesScreen extends StatefulWidget {
  final String initialCategory;

  const ServicesScreen({super.key, this.initialCategory = 'Todos'});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  static const List<String> _categories = [
    'Todos',
    'Pedreiro',
    'Carpinteiro',
    'Pintor',
    'Eletricista',
  ];

  late String _selectedCategory = widget.initialCategory;

  List<Profissional> get _filteredProfessionals {
    if (_selectedCategory == 'Todos') return mockProfessionals;
    return mockProfessionals
        .where((p) => p.especialidade.toLowerCase().contains(
              _selectedCategory.toLowerCase().substring(0, 5),
            ))
        .toList();
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
                    const Icon(Icons.search, color: AppColors.textoSecundario),
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
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = _categories[index];
                final selected = category == _selectedCategory;
                return ChoiceChip(
                  label: Text(category),
                  selected: selected,
                  onSelected: (_) => setState(() => _selectedCategory = category),
                  selectedColor: AppColors.vermelhoAcao,
                  backgroundColor: AppColors.branco,
                  labelStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: selected ? AppColors.branco : AppColors.azulConfianca,
                  ),
                  shape: StadiumBorder(
                    side: BorderSide(
                      color: selected ? AppColors.vermelhoAcao : AppColors.azulConfianca,
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              itemCount: _filteredProfessionals.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final professional = _filteredProfessionals[index];
                return CardProfissional(
                  profissional: professional,
                  onRequest: () => _showRequestConfirmation(context, professional),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppColors.vermelhoAcao,
        foregroundColor: AppColors.branco,
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
              style: const TextStyle(color: AppColors.textoSecundario, fontSize: 13),
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
