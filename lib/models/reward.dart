import 'package:flutter/material.dart';

/// Categoria de parceiro exibida na vitrine de cupons (ÉPICO 05 - US05.2).
enum RewardCategory { mercado, farmacia, materiaisConstrucao, vestuario }

extension RewardCategoryX on RewardCategory {
  String get label {
    switch (this) {
      case RewardCategory.mercado:
        return 'Mercado';
      case RewardCategory.farmacia:
        return 'Farmácia';
      case RewardCategory.materiaisConstrucao:
        return 'Materiais de construção';
      case RewardCategory.vestuario:
        return 'Vestuário';
    }
  }

  IconData get icon {
    switch (this) {
      case RewardCategory.mercado:
        return Icons.local_grocery_store_rounded;
      case RewardCategory.farmacia:
        return Icons.local_pharmacy_rounded;
      case RewardCategory.materiaisConstrucao:
        return Icons.hardware_rounded;
      case RewardCategory.vestuario:
        return Icons.checkroom_rounded;
    }
  }
}

/// Cupom de desconto resgatável na Carteira de Benefícios (US05.2).
class Coupon {
  final String id;
  final String titulo;
  final String parceiro;
  final RewardCategory categoria;
  final int custoPontos;

  const Coupon({
    required this.id,
    required this.titulo,
    required this.parceiro,
    required this.categoria,
    required this.custoPontos,
  });
}

final List<Coupon> mockCoupons = const [
  Coupon(
    id: 'c1',
    titulo: '10% de desconto em compras',
    parceiro: 'Mercado Boa Safra',
    categoria: RewardCategory.mercado,
    custoPontos: 60,
  ),
  Coupon(
    id: 'c2',
    titulo: 'R\$ 15 de desconto em medicamentos',
    parceiro: 'Farmácia Vida Saudável',
    categoria: RewardCategory.farmacia,
    custoPontos: 40,
  ),
  Coupon(
    id: 'c3',
    titulo: '15% de desconto em ferramentas',
    parceiro: 'Casa & Construção Silva',
    categoria: RewardCategory.materiaisConstrucao,
    custoPontos: 90,
  ),
  Coupon(
    id: 'c4',
    titulo: 'R\$ 30 de desconto em uniformes',
    parceiro: 'Vestuário Popular',
    categoria: RewardCategory.vestuario,
    custoPontos: 120,
  ),
  Coupon(
    id: 'c5',
    titulo: '5% de desconto na feira semanal',
    parceiro: 'Feira do Produtor',
    categoria: RewardCategory.mercado,
    custoPontos: 25,
  ),
];
