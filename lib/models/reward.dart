import 'package:flutter/material.dart';

/// Categoria de parceiro exibida na vitrine de cupons (ÉPICO 05 - US05.2).
enum CategoriaRecompensa { mercado, farmacia, materiaisConstrucao, vestuario }

extension CategoriaRecompensaX on CategoriaRecompensa {
  String get texto {
    switch (this) {
      case CategoriaRecompensa.mercado:
        return 'Mercado';
      case CategoriaRecompensa.farmacia:
        return 'Farmácia';
      case CategoriaRecompensa.materiaisConstrucao:
        return 'Materiais de construção';
      case CategoriaRecompensa.vestuario:
        return 'Vestuário';
    }
  }

  IconData get icone {
    switch (this) {
      case CategoriaRecompensa.mercado:
        return Icons.local_grocery_store_rounded;
      case CategoriaRecompensa.farmacia:
        return Icons.local_pharmacy_rounded;
      case CategoriaRecompensa.materiaisConstrucao:
        return Icons.hardware_rounded;
      case CategoriaRecompensa.vestuario:
        return Icons.checkroom_rounded;
    }
  }
}

/// Cupom de desconto resgatável na Carteira de Benefícios (US05.2).
class Cupom {
  final String id;
  final String titulo;
  final String parceiro;
  final CategoriaRecompensa categoria;
  final int custoPontos;

  const Cupom({
    required this.id,
    required this.titulo,
    required this.parceiro,
    required this.categoria,
    required this.custoPontos,
  });
}

final List<Cupom> mockCupons = const [
  Cupom(
    id: 'c1',
    titulo: '10% de desconto em compras',
    parceiro: 'Mercado Boa Safra',
    categoria: CategoriaRecompensa.mercado,
    custoPontos: 60,
  ),
  Cupom(
    id: 'c2',
    titulo: 'R\$ 15 de desconto em medicamentos',
    parceiro: 'Farmácia Vida Saudável',
    categoria: CategoriaRecompensa.farmacia,
    custoPontos: 40,
  ),
  Cupom(
    id: 'c3',
    titulo: '15% de desconto em ferramentas',
    parceiro: 'Casa & Construção Silva',
    categoria: CategoriaRecompensa.materiaisConstrucao,
    custoPontos: 90,
  ),
  Cupom(
    id: 'c4',
    titulo: 'R\$ 30 de desconto em uniformes',
    parceiro: 'Vestuário Popular',
    categoria: CategoriaRecompensa.vestuario,
    custoPontos: 120,
  ),
  Cupom(
    id: 'c5',
    titulo: '5% de desconto na feira semanal',
    parceiro: 'Feira do Produtor',
    categoria: CategoriaRecompensa.mercado,
    custoPontos: 25,
  ),
];
