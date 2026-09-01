import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';

/// Menu "Ajude a Aplicação": permite que a instituição contribua
/// voluntariamente via Pix para a manutenção da plataforma
/// (ÉPICO 06 - US06.1). Interface apenas — a geração real do QR Code
/// Pix ficará a cargo da função AWS Lambda no backend.
class DonateScreen extends StatefulWidget {
  const DonateScreen({super.key});

  @override
  State<DonateScreen> createState() => _DonateScreenState();
}

class _DonateScreenState extends State<DonateScreen> {
  final List<double> _valoresPredefinidos = const [5, 10, 20, 50];
  double? _valorSelecionado = 20;
  final _valorLivreController = TextEditingController();
  bool _qrGerado = false;

  @override
  void dispose() {
    _valorLivreController.dispose();
    super.dispose();
  }

  double? get _valorFinal {
    final livre = double.tryParse(_valorLivreController.text.replaceAll(',', '.'));
    return livre ?? _valorSelecionado;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajude a Aplicação')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.amareloFundo,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: const [
                  Icon(Icons.favorite_rounded, color: AppColors.amareloEscuro),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Sua contribuição é totalmente voluntária e ajuda a manter o app gratuito para instituições e operários.',
                      style: TextStyle(fontSize: 12, color: AppColors.amareloEscuro),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text('Escolha um valor', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _valoresPredefinidos.map((v) {
                final selected = _valorSelecionado == v && _valorLivreController.text.isEmpty;
                return ChoiceChip(
                  label: Text('R\$ ${v.toStringAsFixed(0)}'),
                  selected: selected,
                  onSelected: (_) => setState(() {
                    _valorSelecionado = v;
                    _valorLivreController.clear();
                    _qrGerado = false;
                  }),
                  selectedColor: AppColors.vermelhoAcao,
                  labelStyle: TextStyle(
                    color: selected ? AppColors.branco : AppColors.azulConfianca,
                    fontWeight: FontWeight.w600,
                  ),
                  backgroundColor: AppColors.branco,
                  shape: StadiumBorder(
                    side: BorderSide(color: selected ? AppColors.vermelhoAcao : AppColors.azulConfianca),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text('Ou digite um valor livre',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            TextField(
              controller: _valorLivreController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onChanged: (_) => setState(() => _qrGerado = false),
              decoration: const InputDecoration(prefixText: 'R\$ ', hintText: '0,00'),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (_valorFinal != null && _valorFinal! > 0)
                    ? () => setState(() => _qrGerado = true)
                    : null,
                child: const Text('Gerar QR Code Pix'),
              ),
            ),
            if (_qrGerado && _valorFinal != null) ...[
              const SizedBox(height: 24),
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 180,
                      height: 180,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.branco,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.borda),
                      ),
                      child: const Icon(Icons.qr_code_2_rounded, size: 150, color: AppColors.azulConfianca),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Doação de R\$ ${_valorFinal!.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.fundoTela,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.borda),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '00020126580014BR.GOV.BCB.PIX0136maos-solidarias-doacao${_valorFinal!.toStringAsFixed(2)}5204000053039865802BR',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 11, color: AppColors.textoSecundario),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy_rounded, size: 18, color: AppColors.azulClaro),
                      onPressed: () {
                        Clipboard.setData(const ClipboardData(text: 'PIX_COPIA_E_COLA_MAOS_SOLIDARIAS'));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Código Pix copiado!')),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Copia e Cola',
                style: TextStyle(fontSize: 11, color: AppColors.textoSecundario),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
