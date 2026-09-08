import 'package:flutter/material.dart';
import '../../models/nivel_experiencia.dart';
import '../../models/operario.dart';
import '../../models/recompensa.dart';
import '../../theme/tema_do_app.dart';
import '../../widgets/card_cupom.dart';
import '../../widgets/titulo_secao.dart';

/// Carteira de Benefícios do operário: saldo de pontos acumulados e
/// vitrine de cupons parceiros para resgate (ÉPICO 05 - US05.2).
class OperarioTelaBeneficios extends StatefulWidget {
  const OperarioTelaBeneficios({super.key});

  @override
  State<OperarioTelaBeneficios> createState() => _OperarioTelaBeneficiosState();
}

class _OperarioTelaBeneficiosState extends State<OperarioTelaBeneficios> {
  late int _saldo = mockOperarioAtual.pontos;
  CategoriaRecompensa? _filtro;

  @override
  Widget build(BuildContext context) {
    final cupons = mockCupons.where((c) => _filtro == null || c.categoria == _filtro).toList();

    return Scaffold(
      appBar: AppBar(
          title: const Text('Carteira de Benefícios'),
          automaticallyImplyLeading: false, //desativar a seta de voltar da topbar
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [CoresApp.azulConfianca, CoresApp.azulClaro],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Saldo disponível',
                    style: TextStyle(color: Color(0xFFC7D3E6), fontSize: 12)),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$_saldo',
                      style: const TextStyle(
                        color: CoresApp.branco,
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 6, bottom: 6),
                      child: Text('pontos',
                          style: TextStyle(color: Color(0xFFC7D3E6), fontSize: 13)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${mockOperarioAtual.servicosRealizados} serviços realizados · nível ${mockOperarioAtual.nivelExperiencia.texto}',
                  style: const TextStyle(color: Color(0xFFC7D3E6), fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const TituloSecao(titulo: 'Vitrine de cupons'),
          const SizedBox(height: 10),
          SizedBox(
            height: 34,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: CategoriaRecompensa.values.length + 1,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                if (i == 0) {
                  return _filterChip('Todos', _filtro == null, () => setState(() => _filtro = null));
                }
                final cat = CategoriaRecompensa.values[i - 1];
                return _filterChip(cat.texto, _filtro == cat, () => setState(() => _filtro = cat));
              },
            ),
          ),
          const SizedBox(height: 12),
          ...cupons.map(
            (c) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: CardCupom(
                cupom: c,
                saldoPontos: _saldo,
                aoResgatar: () => _resgatar(c),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, bool selected, VoidCallback onTap) {
    return ChoiceChip(
      label: Text(label, style: const TextStyle(fontSize: 11)),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: CoresApp.vermelhoAcao,
      backgroundColor: CoresApp.branco,
      labelStyle: TextStyle(color: selected ? CoresApp.branco : CoresApp.azulConfianca),
      shape: StadiumBorder(
        side: BorderSide(color: selected ? CoresApp.vermelhoAcao : CoresApp.azulConfianca),
      ),
    );
  }

  void _resgatar(Cupom c) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar resgate'),
        content: Text('Resgatar "${c.titulo}" por ${c.custoPontos} pontos?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              setState(() => _saldo -= c.custoPontos);
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Cupom "${c.titulo}" resgatado com sucesso!')),
              );
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }
}
