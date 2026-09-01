import 'package:flutter/material.dart';
import '../../models/experience_level.dart';
import '../../models/operario.dart';
import '../../models/reward.dart';
import '../../theme/app_theme.dart';
import '../../widgets/coupon_card.dart';
import '../../widgets/section_title.dart';

/// Carteira de Benefícios do operário: saldo de pontos acumulados e
/// vitrine de cupons parceiros para resgate (ÉPICO 05 - US05.2).
class BenefitsScreen extends StatefulWidget {
  const BenefitsScreen({super.key});

  @override
  State<BenefitsScreen> createState() => _BenefitsScreenState();
}

class _BenefitsScreenState extends State<BenefitsScreen> {
  late int _saldo = mockOperarioAtual.pontos;
  RewardCategory? _filtro;

  @override
  Widget build(BuildContext context) {
    final cupons = mockCoupons.where((c) => _filtro == null || c.categoria == _filtro).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Carteira de Benefícios')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.azulConfianca, AppColors.azulClaro],
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
                        color: AppColors.branco,
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
                  '${mockOperarioAtual.servicosRealizados} serviços realizados · nível ${mockOperarioAtual.nivelExperiencia.label}',
                  style: const TextStyle(color: Color(0xFFC7D3E6), fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const SectionTitle(title: 'Vitrine de cupons'),
          const SizedBox(height: 10),
          SizedBox(
            height: 34,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: RewardCategory.values.length + 1,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                if (i == 0) {
                  return _filterChip('Todos', _filtro == null, () => setState(() => _filtro = null));
                }
                final cat = RewardCategory.values[i - 1];
                return _filterChip(cat.label, _filtro == cat, () => setState(() => _filtro = cat));
              },
            ),
          ),
          const SizedBox(height: 12),
          ...cupons.map(
            (c) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: CouponCard(
                coupon: c,
                saldoPontos: _saldo,
                onResgatar: () => _resgatar(c),
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
      selectedColor: AppColors.vermelhoAcao,
      backgroundColor: AppColors.branco,
      labelStyle: TextStyle(color: selected ? AppColors.branco : AppColors.azulConfianca),
      shape: StadiumBorder(
        side: BorderSide(color: selected ? AppColors.vermelhoAcao : AppColors.azulConfianca),
      ),
    );
  }

  void _resgatar(Coupon c) {
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
