import 'package:flutter/material.dart';
import '../models/reward.dart';
import '../theme/app_theme.dart';

/// Card de cupom exibido na vitrine da Carteira de Benefícios
/// (US05.2), com o custo em pontos e a opção de resgate.
class CouponCard extends StatelessWidget {
  final Coupon coupon;
  final int saldoPontos;
  final VoidCallback onResgatar;

  const CouponCard({
    super.key,
    required this.coupon,
    required this.saldoPontos,
    required this.onResgatar,
  });

  @override
  Widget build(BuildContext context) {
    final podeResgatar = saldoPontos >= coupon.custoPontos;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.branco,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borda),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.amareloFundo,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(coupon.categoria.icon,
                color: AppColors.amareloEscuro, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  coupon.titulo,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textoPrimario,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  coupon.parceiro,
                  style: const TextStyle(fontSize: 11, color: AppColors.textoSecundario),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.toll_rounded, size: 13, color: AppColors.amareloEscuro),
                    const SizedBox(width: 3),
                    Text(
                      '${coupon.custoPontos} pontos',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.amareloEscuro,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 84,
            child: ElevatedButton(
              onPressed: podeResgatar ? onResgatar : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 8),
                disabledBackgroundColor: AppColors.bloqueadoFundo,
                disabledForegroundColor: AppColors.bloqueado,
              ),
              child: const Text('Resgatar', style: TextStyle(fontSize: 11)),
            ),
          ),
        ],
      ),
    );
  }
}
